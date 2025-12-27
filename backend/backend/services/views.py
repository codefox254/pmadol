# ============================================
# services/views.py
# ============================================
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated, AllowAny
from django.utils import timezone
from .models import Service, PricingPlan, ServiceBooking, ServiceInquiry, MembershipPlan, ClubMembership
from .serializers import *


class ServiceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Service.objects.filter(is_active=True)
    serializer_class = ServiceSerializer
    
    @action(detail=False, methods=['get'])
    def featured(self, request):
        services = self.queryset.filter(is_featured=True)
        serializer = self.get_serializer(services, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def by_category(self, request):
        category = request.query_params.get('category')
        if not category:
            return Response({'error': 'Category parameter required'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        services = self.queryset.filter(category=category)
        serializer = self.get_serializer(services, many=True)
        return Response(serializer.data)


class PricingPlanViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = PricingPlan.objects.filter(is_active=True)
    serializer_class = PricingPlanSerializer
    
    @action(detail=False, methods=['get'])
    def popular(self, request):
        plans = self.queryset.filter(is_popular=True)
        serializer = self.get_serializer(plans, many=True)
        return Response(serializer.data)


class ServiceBookingViewSet(viewsets.ModelViewSet):
    queryset = ServiceBooking.objects.all()
    serializer_class = ServiceBookingSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        if self.request.user.is_staff:
            return self.queryset
        return self.queryset.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        booking = self.get_object()
        if booking.status == 'completed':
            return Response({'error': 'Cannot cancel completed booking'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        booking.status = 'cancelled'
        booking.save()
        return Response({'message': 'Booking cancelled successfully'})
    
    @action(detail=False, methods=['get'])
    def upcoming(self, request):
        from django.utils import timezone
        bookings = self.get_queryset().filter(
            date__gte=timezone.now().date(),
            status__in=['pending', 'confirmed']
        )
        serializer = self.get_serializer(bookings, many=True)
        return Response(serializer.data)


class ServiceInquiryViewSet(viewsets.ModelViewSet):
    queryset = ServiceInquiry.objects.all()
    serializer_class = ServiceInquirySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_permissions(self):
        if self.action == 'create':
            return [IsAuthenticatedOrReadOnly()]
        return [IsAuthenticated()]


class MembershipPlanViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MembershipPlan.objects.filter(is_active=True)
    serializer_class = MembershipPlanSerializer
    permission_classes = [AllowAny]
    
    @action(detail=False, methods=['get'])
    def default_plan(self, request):
        """Get the default membership plan"""
        plan = self.queryset.filter(is_default=True).first()
        if plan:
            serializer = self.get_serializer(plan)
            return Response(serializer.data)
        return Response({'message': 'No default plan set'}, status=status.HTTP_404_NOT_FOUND)


class ClubMembershipViewSet(viewsets.ModelViewSet):
    queryset = ClubMembership.objects.all()
    serializer_class = ClubMembershipSerializer
    permission_classes = [AllowAny]
    
    def get_permissions(self):
        if self.action == 'create':
            return [AllowAny()]
        return [IsAuthenticated()]
    
    def get_queryset(self):
        if self.request.user.is_staff:
            return self.queryset
        elif self.request.user.is_authenticated:
            return self.queryset.filter(email=self.request.user.email)
        return self.queryset.none()
    
    @action(detail=False, methods=['post'])
    def register(self, request):
        """Public endpoint for membership registration"""
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            membership = serializer.save()
            return Response({
                'message': 'Registration submitted successfully',
                'membership_number': membership.membership_number,
                'data': serializer.data
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    @action(detail=True, methods=['post'])
    def confirm_payment(self, request, pk=None):
        """Confirm M-Pesa payment"""
        membership = self.get_object()
        mpesa_transaction_id = request.data.get('mpesa_transaction_id')
        
        if not mpesa_transaction_id:
            return Response({'error': 'M-Pesa transaction ID required'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        membership.mpesa_transaction_id = mpesa_transaction_id
        membership.payment_status = 'completed'
        membership.payment_date = timezone.now()
        membership.save()
        
        return Response({
            'message': 'Payment confirmed successfully',
            'membership_number': membership.membership_number
        })
    
    @action(detail=False, methods=['get'])
    def check_status(self, request):
        """Check membership status by membership number"""
        membership_number = request.query_params.get('membership_number')
        if not membership_number:
            return Response({'error': 'Membership number required'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        try:
            membership = ClubMembership.objects.get(membership_number=membership_number)
            serializer = self.get_serializer(membership)
            return Response(serializer.data)
        except ClubMembership.DoesNotExist:
            return Response({'error': 'Membership not found'}, 
                          status=status.HTTP_404_NOT_FOUND)
