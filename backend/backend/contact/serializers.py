# ============================================
# contact/serializers.py
# ============================================
from rest_framework import serializers
from .models import ContactMessage, ConsultationRequest, NewsletterSubscriber, ContactInfo


class ContactMessageSerializer(serializers.ModelSerializer):
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    
    class Meta:
        model = ContactMessage
        fields = '__all__'
        read_only_fields = ['status', 'created_at']


class ConsultationRequestSerializer(serializers.ModelSerializer):
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    
    class Meta:
        model = ConsultationRequest
        fields = '__all__'
        read_only_fields = ['status', 'created_at']


class NewsletterSubscriberSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewsletterSubscriber
        fields = '__all__'
        read_only_fields = ['is_active', 'subscribed_at']


class ContactInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContactInfo
        fields = '__all__'

