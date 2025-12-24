
# ============================================
# shop/views.py
# Enhanced with secure practices and advanced features
# ============================================
from rest_framework import viewsets, status
from rest_framework.decorators import action, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated, AllowAny
from django.db.models import Q, Avg, Count
from django.db import transaction
from django.utils import timezone
from datetime import timedelta
import uuid
from .models import *
from .serializers import *


class ProductCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for product categories
    - GET /api/products/categories/
    - GET /api/products/categories/{slug}/
    """
    queryset = ProductCategory.objects.filter(is_active=True)
    serializer_class = ProductCategorySerializer
    lookup_field = 'slug'
    permission_classes = [AllowAny]


class ProductViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for products with search, filtering, and advanced features
    """
    queryset = Product.objects.filter(is_active=True).select_related('category').prefetch_related('reviews')
    serializer_class = ProductSerializer
    lookup_field = 'slug'
    permission_classes = [AllowAny]
    
    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Get featured products"""
        products = self.queryset.filter(is_featured=True)[:12]
        serializer = self.get_serializer(products, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def by_category(self, request):
        """Get products filtered by category"""
        category_slug = request.query_params.get('category')
        if not category_slug:
            return Response({'error': 'Category parameter required'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        products = self.queryset.filter(category__slug=category_slug)
        page = self.paginate_queryset(products)
        serializer = self.get_serializer(page, many=True)
        return self.get_paginated_response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def search(self, request):
        """Search products by name or description"""
        query = request.query_params.get('q', '').strip()
        if len(query) < 2:
            return Response({'error': 'Search query too short'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        products = self.queryset.filter(
            Q(name__icontains=query) | Q(description__icontains=query) | Q(short_description__icontains=query)
        )
        page = self.paginate_queryset(products)
        serializer = self.get_serializer(page, many=True)
        return self.get_paginated_response(serializer.data)
    
    @action(detail='slug', methods=['get'])
    def reviews(self, request, slug=None):
        """Get reviews for a specific product"""
        product = self.get_object()
        reviews = product.reviews.all()
        serializer = ProductReviewSerializer(reviews, many=True)
        return Response({
            'product': ProductSerializer(product).data,
            'reviews': serializer.data,
            'average_rating': product.reviews.aggregate(Avg('rating'))['rating__avg'] or 0,
            'review_count': product.reviews.count()
        })


class CartViewSet(viewsets.ModelViewSet):
    """
    ViewSet for shopping cart management
    - GET /api/cart/
    - POST /api/cart/add_item/
    - POST /api/cart/update_item/
    - DELETE /api/cart/remove_item/
    - POST /api/cart/clear/
    """
    serializer_class = CartSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Cart.objects.filter(user=self.request.user)
    
    def get_object(self):
        """Get or create cart for authenticated user"""
        cart, created = Cart.objects.get_or_create(
            user=self.request.user,
            defaults={'is_active': True}
        )
        return cart
    
    @action(detail=False, methods=['get'])
    def retrieve_cart(self, request):
        """Retrieve user's cart"""
        cart = self.get_object()
        serializer = self.get_serializer(cart)
        return Response(serializer.data)
    
    @action(detail=False, methods=['post'])
    def add_item(self, request):
        """Add item to cart"""
        cart = self.get_object()
        product_id = request.data.get('product_id')
        quantity = int(request.data.get('quantity', 1))
        
        # Validation
        if not product_id or quantity < 1:
            return Response(
                {'error': 'Invalid product_id or quantity'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            product = Product.objects.get(id=product_id, is_active=True)
        except Product.DoesNotExist:
            return Response(
                {'error': 'Product not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Check stock availability
        if product.stock < quantity:
            return Response(
                {'error': f'Only {product.stock} items in stock'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        cart_item, created = CartItem.objects.get_or_create(
            cart=cart,
            product=product,
            defaults={'quantity': quantity}
        )
        
        if not created:
            cart_item.quantity += quantity
            if cart_item.quantity > product.stock:
                cart_item.quantity = product.stock
            cart_item.save()
        
        return Response(
            CartItemSerializer(cart_item).data,
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK
        )
    
    @action(detail=False, methods=['post'])
    def update_item(self, request):
        """Update cart item quantity"""
        cart = self.get_object()
        item_id = request.data.get('item_id')
        quantity = int(request.data.get('quantity', 1))
        
        if quantity < 1:
            return Response(
                {'error': 'Quantity must be at least 1'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            item = CartItem.objects.get(id=item_id, cart=cart)
            if item.product.stock < quantity:
                return Response(
                    {'error': f'Only {item.product.stock} items in stock'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            item.quantity = quantity
            item.save()
            return Response(CartItemSerializer(item).data)
        except CartItem.DoesNotExist:
            return Response(
                {'error': 'Cart item not found'},
                status=status.HTTP_404_NOT_FOUND
            )
    
    @action(detail=False, methods=['delete'])
    def remove_item(self, request):
        """Remove item from cart"""
        cart = self.get_object()
        item_id = request.data.get('item_id')
        
        try:
            item = CartItem.objects.get(id=item_id, cart=cart)
            item.delete()
            return Response({
                'message': 'Item removed from cart',
                'cart': CartSerializer(cart).data
            })
        except CartItem.DoesNotExist:
            return Response(
                {'error': 'Item not found'},
                status=status.HTTP_404_NOT_FOUND
            )
    
    @action(detail=False, methods=['post'])
    def clear(self, request):
        """Clear entire cart"""
        cart = self.get_object()
        cart.items.all().delete()
        return Response({
            'message': 'Cart cleared',
            'cart': CartSerializer(cart).data
        })


class OrderViewSet(viewsets.ModelViewSet):
    """
    ViewSet for order management
    - GET /api/orders/
    - POST /api/orders/
    - GET /api/orders/{id}/
    - POST /api/orders/{id}/track/
    - POST /api/orders/{id}/cancel/
    """
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related(
            'items', 'items__product', 'status_history'
        )
    
    def perform_create(self, serializer):
        """Create order from cart with transaction"""
        with transaction.atomic():
            order = serializer.save(
                user=self.request.user,
                order_number=self._generate_order_number()
            )
            
            # Create initial status history
            OrderStatusHistory.objects.create(
                order=order,
                status='pending',
                note='Order placed'
            )
    
    def create(self, request, *args, **kwargs):
        """Create order from cart items"""
        cart = Cart.objects.get(user=request.user)
        
        if not cart.items.exists():
            return Response(
                {'error': 'Cart is empty'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Validate delivery information
        required_fields = [
            'delivery_name', 'delivery_phone', 'delivery_email',
            'delivery_address', 'delivery_city', 'delivery_state', 'delivery_zip'
        ]
        
        for field in required_fields:
            if not request.data.get(field):
                return Response(
                    {'error': f'{field} is required'},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        with transaction.atomic():
            # Calculate totals
            total_amount = cart.total_amount
            discount_applied = cart.total_discount
            final_amount = cart.discounted_amount
            
            # Create order
            order = Order.objects.create(
                user=request.user,
                order_number=self._generate_order_number(),
                total_amount=total_amount,
                discount_applied=discount_applied,
                final_amount=final_amount,
                payment_method=request.data.get('payment_method', 'cod'),
                delivery_name=request.data['delivery_name'],
                delivery_phone=request.data['delivery_phone'],
                delivery_email=request.data['delivery_email'],
                delivery_address=request.data['delivery_address'],
                delivery_city=request.data['delivery_city'],
                delivery_state=request.data['delivery_state'],
                delivery_zip=request.data['delivery_zip'],
                notes=request.data.get('notes', ''),
                estimated_delivery=timezone.now() + timedelta(days=3)
            )
            
            # Create order items from cart
            for cart_item in cart.items.all():
                OrderItem.objects.create(
                    order=order,
                    product=cart_item.product,
                    quantity=cart_item.quantity,
                    price=cart_item.product.discounted_price
                )
            
            # Create status history
            OrderStatusHistory.objects.create(
                order=order,
                status='pending',
                note='Order placed'
            )
            
            # Clear cart
            cart.items.all().delete()
        
        serializer = self.get_serializer(order)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    @action(detail=True, methods=['get'])
    def track(self, request, pk=None):
        """Track order status and delivery"""
        order = self.get_object()
        status_history = OrderStatusHistory.objects.filter(order=order)
        
        return Response({
            'order': OrderSerializer(order).data,
            'status_history': OrderStatusHistorySerializer(status_history, many=True).data,
            'current_status': order.status,
            'estimated_delivery': order.estimated_delivery,
            'payment_status': order.payment_status
        })
    
    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        """Cancel an order"""
        order = self.get_object()
        
        if not order.can_be_cancelled():
            return Response(
                {'error': f'Cannot cancel order in {order.get_status_display()} status'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        with transaction.atomic():
            order.status = 'cancelled'
            order.save()
            
            OrderStatusHistory.objects.create(
                order=order,
                status='cancelled',
                note='Order cancelled by user'
            )
        
        return Response({
            'message': 'Order cancelled successfully',
            'order': OrderSerializer(order).data
        })


class ProductReviewViewSet(viewsets.ModelViewSet):
    """
    ViewSet for product reviews and ratings
    - GET /api/reviews/
    - POST /api/reviews/
    - PUT /api/reviews/{id}/
    - DELETE /api/reviews/{id}/
    """
    serializer_class = ProductReviewSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_queryset(self):
        product_id = self.request.query_params.get('product')
        if product_id:
            return ProductReview.objects.filter(product_id=product_id).select_related('user')
        return ProductReview.objects.all().select_related('user')
    
    def perform_create(self, serializer):
        """Create review"""
        product_id = self.request.data.get('product')
        
        # Check if user already reviewed this product
        if ProductReview.objects.filter(
            product_id=product_id,
            user=self.request.user
        ).exists():
            raise serializers.ValidationError("You have already reviewed this product")
        
        # Check if user purchased the product
        is_verified_purchase = OrderItem.objects.filter(
            order__user=self.request.user,
            product_id=product_id
        ).exists()
        
        review = serializer.save(
            user=self.request.user,
            is_verified_purchase=is_verified_purchase
        )
    
    def perform_update(self, serializer):
        """Update own review only"""
        review = self.get_object()
        if review.user != self.request.user:
            raise serializers.ValidationError("You can only edit your own reviews")
        serializer.save()
    
    def perform_destroy(self, instance):
        """Delete own review only"""
        if instance.user != self.request.user:
            raise serializers.ValidationError("You can only delete your own reviews")
        instance.delete()
    
    @action(detail=False, methods=['get'])
    def by_product(self, request):
        """Get reviews for a specific product with statistics"""
        product_id = request.query_params.get('product_id')
        if not product_id:
            return Response(
                {'error': 'product_id is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            product = Product.objects.get(id=product_id)
        except Product.DoesNotExist:
            return Response(
                {'error': 'Product not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        reviews = ProductReview.objects.filter(product_id=product_id)
        
        # Calculate statistics
        rating_stats = reviews.aggregate(
            average=Avg('rating'),
            count=Count('id')
        )
        
        # Get reviews per rating
        rating_distribution = {}
        for i in range(1, 6):
            rating_distribution[i] = reviews.filter(rating=i).count()
        
        serializer = self.get_serializer(reviews, many=True)
        
        return Response({
            'product': ProductSerializer(product).data,
            'reviews': serializer.data,
            'statistics': {
                'average_rating': rating_stats['average'] or 0,
                'total_reviews': rating_stats['count'],
                'rating_distribution': rating_distribution
            }
        })
    
    @action(detail=True, methods=['post'])
    def mark_helpful(self, request, pk=None):
        """Mark review as helpful"""
        review = self.get_object()
        review.helpful_count += 1
        review.save()
        return Response({
            'message': 'Thank you for your feedback',
            'helpful_count': review.helpful_count
        })


class OrderViewSet(viewsets.ModelViewSet):
    """
    ViewSet for order management
    - GET /api/orders/
    - POST /api/orders/
    - GET /api/orders/{id}/
    - POST /api/orders/{id}/track/
    - POST /api/orders/{id}/cancel/
    """
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related(
            'items', 'items__product', 'status_history'
        )
    
    @staticmethod
    def _generate_order_number():
        """Generate unique order number"""
        return f"ORD-{timezone.now().strftime('%Y%m%d')}-{uuid.uuid4().hex[:8].upper()}"

