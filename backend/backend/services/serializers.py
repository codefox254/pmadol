# ============================================
# services/serializers.py
# ============================================
from rest_framework import serializers
from .models import Service, PricingPlan, ServiceBooking, ServiceInquiry


class ServiceSerializer(serializers.ModelSerializer):
    category_display = serializers.CharField(source='get_category_display', read_only=True)
    
    class Meta:
        model = Service
        fields = '__all__'


class PricingPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = PricingPlan
        fields = '__all__'


class ServiceBookingSerializer(serializers.ModelSerializer):
    service_name = serializers.CharField(source='service.name', read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    payment_status_display = serializers.CharField(source='get_payment_status_display', read_only=True)
    
    class Meta:
        model = ServiceBooking
        fields = '__all__'
        read_only_fields = ['user', 'total_amount', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        validated_data['total_amount'] = validated_data['service'].price
        return super().create(validated_data)


class ServiceInquirySerializer(serializers.ModelSerializer):
    service_name = serializers.CharField(source='service.name', read_only=True)
    
    class Meta:
        model = ServiceInquiry
        fields = '__all__'
        read_only_fields = ['status', 'created_at']


