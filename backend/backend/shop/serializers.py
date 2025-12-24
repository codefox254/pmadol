
# ============================================
# shop/serializers.py
# ============================================
from rest_framework import serializers
from .models import *
from django.contrib.auth import get_user_model

User = get_user_model()


class ProductCategorySerializer(serializers.ModelSerializer):
    product_count = serializers.SerializerMethodField()
    
    class Meta:
        model = ProductCategory
        fields = ['id', 'name', 'slug', 'description', 'is_active', 'product_count']
    
    def get_product_count(self, obj):
        return obj.products.filter(is_active=True).count()


class ProductSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    category_id = serializers.IntegerField(source='category.id', read_only=True)
    average_rating = serializers.SerializerMethodField()
    review_count = serializers.SerializerMethodField()
    discounted_price = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    savings = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    
    class Meta:
        model = Product
        fields = [
            'id', 'name', 'slug', 'category', 'category_name', 'category_id',
            'description', 'short_description', 'price', 'discount_percentage',
            'discounted_price', 'savings', 'stock', 'image', 'gallery_images',
            'sku', 'is_featured', 'is_active', 'average_rating', 'review_count',
            'in_stock', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_average_rating(self, obj):
        reviews = obj.reviews.all()
        if reviews:
            return round(sum(r.rating for r in reviews) / len(reviews), 1)
        return 0
    
    def get_review_count(self, obj):
        return obj.reviews.count()


class CartItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    product_id = serializers.IntegerField(write_only=True)
    subtotal = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    discounted_subtotal = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    discount_savings = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    
    class Meta:
        model = CartItem
        fields = [
            'id', 'cart', 'product', 'product_id', 'quantity', 'added_at',
            'subtotal', 'discounted_subtotal', 'discount_savings'
        ]
        read_only_fields = ['cart', 'added_at', 'id']
    
    def validate_quantity(self, value):
        if value < 1:
            raise serializers.ValidationError("Quantity must be at least 1")
        return value


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    total_amount = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    discounted_amount = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    total_discount = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    total_items = serializers.IntegerField(read_only=True)
    
    class Meta:
        model = Cart
        fields = [
            'id', 'user', 'items', 'total_amount', 'discounted_amount',
            'total_discount', 'total_items', 'is_active', 'created_at', 'updated_at'
        ]
        read_only_fields = ['user', 'created_at', 'updated_at', 'id']


class OrderItemSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.name', read_only=True)
    product_image = serializers.CharField(source='product.image', read_only=True)
    subtotal = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    
    class Meta:
        model = OrderItem
        fields = [
            'id', 'order', 'product', 'product_name', 'product_image',
            'quantity', 'price', 'subtotal'
        ]
        read_only_fields = ['order', 'id']


class OrderStatusHistorySerializer(serializers.ModelSerializer):
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    
    class Meta:
        model = OrderStatusHistory
        fields = ['id', 'order', 'status', 'status_display', 'timestamp', 'note']
        read_only_fields = ['id', 'timestamp']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    payment_status_display = serializers.CharField(source='get_payment_status_display', read_only=True)
    payment_method_display = serializers.CharField(source='get_payment_method_display', read_only=True)
    status_history = OrderStatusHistorySerializer(many=True, read_only=True)
    
    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'user', 'items', 'total_amount', 'discount_applied',
            'final_amount', 'status', 'status_display', 'payment_status',
            'payment_status_display', 'payment_method', 'payment_method_display',
            'delivery_name', 'delivery_phone', 'delivery_email', 'delivery_address',
            'delivery_city', 'delivery_state', 'delivery_zip', 'notes',
            'estimated_delivery', 'status_history', 'created_at', 'updated_at'
        ]
        read_only_fields = ['user', 'order_number', 'created_at', 'updated_at', 'id']


class ProductReviewSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.username', read_only=True)
    user_id = serializers.IntegerField(source='user.id', read_only=True)
    
    class Meta:
        model = ProductReview
        fields = [
            'id', 'product', 'user', 'user_id', 'user_name', 'rating', 'title',
            'comment', 'is_verified_purchase', 'helpful_count', 'created_at', 'updated_at'
        ]
        read_only_fields = ['user', 'id', 'created_at', 'updated_at', 'helpful_count', 'is_verified_purchase']


