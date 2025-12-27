

# ============================================
# core/serializers.py
# ============================================
from rest_framework import serializers
from .models import *


class SiteSettingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = SiteSettings
        fields = '__all__'


class HeroSlideSerializer(serializers.ModelSerializer):
    class Meta:
        model = HeroSlide
        fields = '__all__'


class StatisticsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Statistics
        fields = '__all__'


class TestimonialSerializer(serializers.ModelSerializer):
    role_display = serializers.CharField(source='get_role_display', read_only=True)
    
    class Meta:
        model = Testimonial
        fields = '__all__'


class PartnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Partner
        fields = '__all__'


class TeamMemberSerializer(serializers.ModelSerializer):
    role_display = serializers.CharField(source='get_role_display', read_only=True)
    
    class Meta:
        model = TeamMember
        fields = '__all__'


class FAQSerializer(serializers.ModelSerializer):
    category_display = serializers.CharField(source='get_category_display', read_only=True)
    
    class Meta:
        model = FAQ
        fields = '__all__'


class CoreValueSerializer(serializers.ModelSerializer):
    class Meta:
        model = CoreValue
        fields = '__all__'


class NewsUpdateSerializer(serializers.ModelSerializer):
    update_type_display = serializers.CharField(source='get_update_type_display', read_only=True)
    
    class Meta:
        model = NewsUpdate
        fields = '__all__'


class HomeGalleryImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = HomeGalleryImage
        fields = '__all__'


class AboutContentSerializer(serializers.ModelSerializer):
    core_values = CoreValueSerializer(many=True, read_only=True, source='corevalue_set')
    
    class Meta:
        model = AboutContent
        fields = '__all__'


class HomePageDataSerializer(serializers.Serializer):
    """Combined serializer for homepage data from multiple models"""
    site_settings = SiteSettingsSerializer(read_only=True)
    statistics = StatisticsSerializer(read_only=True)
    testimonials = TestimonialSerializer(many=True, read_only=True)
    partners = PartnerSerializer(many=True, read_only=True)
    hero_slides = HeroSlideSerializer(many=True, read_only=True)
    news_updates = NewsUpdateSerializer(many=True, read_only=True)
    gallery_images = HomeGalleryImageSerializer(many=True, read_only=True)
    
    def to_representation(self, instance):
        """Override to_representation to properly handle mixed data types"""
        return {
            'site_settings': SiteSettingsSerializer(instance['site_settings']).data,
            'statistics': StatisticsSerializer(instance['statistics']).data,
            'testimonials': TestimonialSerializer(instance['testimonials'], many=True).data,
            'partners': PartnerSerializer(instance['partners'], many=True).data,
            'hero_slides': HeroSlideSerializer(instance['hero_slides'], many=True).data,
            'news_updates': NewsUpdateSerializer(instance['news_updates'], many=True).data,
            'gallery_images': HomeGalleryImageSerializer(instance['gallery_images'], many=True).data,
        }

