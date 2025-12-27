# ============================================
# services/serializers.py
# ============================================
from rest_framework import serializers
from .models import Service, PricingPlan, ServiceBooking, ServiceInquiry, MembershipPlan, ClubMembership


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


class MembershipPlanSerializer(serializers.ModelSerializer):
    plan_type_display = serializers.CharField(source='get_plan_type_display', read_only=True)
    
    class Meta:
        model = MembershipPlan
        fields = '__all__'


class ClubMembershipSerializer(serializers.ModelSerializer):
    member_type_display = serializers.CharField(source='get_member_type_display', read_only=True)
    payment_status_display = serializers.CharField(source='get_payment_status_display', read_only=True)
    registration_status_display = serializers.CharField(source='get_registration_status_display', read_only=True)
    membership_plan_name = serializers.CharField(source='membership_plan.name', read_only=True)
    
    class Meta:
        model = ClubMembership
        fields = '__all__'
        read_only_fields = [
            'membership_number', 'registration_date', 'approval_date', 
            'approved_by', 'registration_status'
        ]
    
    def validate(self, data):
        # Validate child registration fields
        if data.get('is_child_registration'):
            if not data.get('parent_name'):
                raise serializers.ValidationError("Parent name is required for child registrations")
            if not data.get('parent_email'):
                raise serializers.ValidationError("Parent email is required for child registrations")
            if not data.get('parent_phone'):
                raise serializers.ValidationError("Parent phone is required for child registrations")
        
        # Validate consents
        if not data.get('consent_given'):
            raise serializers.ValidationError("You must agree to the terms and conditions")
        if not data.get('privacy_accepted'):
            raise serializers.ValidationError("You must accept the privacy policy")
        
        return data

