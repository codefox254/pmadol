
# apps/core/serializers.py
from rest_framework import serializers
from apps.core.models import SiteSettings, Testimonial

class SiteSettingsSerializer(serializers.ModelSerializer):
    """Serializer for site settings"""
    
    class Meta:
        model = SiteSettings
        fields = ['id', 'key', 'value', 'description', 'updated_at']
        read_only_fields = ['id', 'updated_at']

class TestimonialSerializer(serializers.ModelSerializer):
    """Serializer for testimonials"""
    
    class Meta:
        model = Testimonial
        fields = [
            'id', 'student_name', 'student_age', 'parent_name',
            'rating', 'testimonial_text', 'student_image',
            'is_featured', 'display_order', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']