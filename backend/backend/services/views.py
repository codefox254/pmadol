# ============================================
# services/views.py
# ============================================
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from .models import Service, PricingPlan, ServiceBooking, ServiceInquiry
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

