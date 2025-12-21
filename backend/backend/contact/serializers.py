# apps/contact/serializers.py
from rest_framework import serializers
from apps.contact.models import ContactSubmission

class ContactSubmissionSerializer(serializers.ModelSerializer):
    """Serializer for contact form submissions"""
    
    class Meta:
        model = ContactSubmission
        fields = [
            'id', 'name', 'email', 'phone', 'subject',
            'message', 'is_read', 'created_at'
        ]
        read_only_fields = ['id', 'is_read', 'created_at']

class ContactSubmissionCreateSerializer(serializers.ModelSerializer):
    """Serializer for creating contact submissions"""
    
    class Meta:
        model = ContactSubmission
        fields = ['name', 'email', 'phone', 'subject', 'message']

