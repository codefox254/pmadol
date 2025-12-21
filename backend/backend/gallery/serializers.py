# apps/gallery/serializers.py
from rest_framework import serializers
from apps.gallery.models import GalleryItem

class GalleryItemSerializer(serializers.ModelSerializer):
    """Serializer for gallery items"""
    
    media_url_full = serializers.SerializerMethodField()
    thumbnail_url_full = serializers.SerializerMethodField()
    
    class Meta:
        model = GalleryItem
        fields = [
            'id', 'title', 'description', 'media_type',
            'media_url', 'media_url_full', 'image',
            'thumbnail_url', 'thumbnail_url_full', 'thumbnail_image',
            'category', 'display_order', 'is_featured', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']
    
    def get_media_url_full(self, obj):
        return obj.get_media_url()
    
    def get_thumbnail_url_full(self, obj):
        return obj.get_thumbnail_url()


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