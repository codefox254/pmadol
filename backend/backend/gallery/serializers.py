
# ============================================
# gallery/serializers.py
# ============================================
from rest_framework import serializers
from .models import GalleryCategory, GalleryPhoto, GalleryVideo


class GalleryCategorySerializer(serializers.ModelSerializer):
    item_count = serializers.SerializerMethodField()
    
    class Meta:
        model = GalleryCategory
        fields = '__all__'
    
    def get_item_count(self, obj):
        if obj.type == 'photo':
            return obj.photos.filter(is_active=True).count()
        return obj.videos.filter(is_active=True).count()


class GalleryPhotoSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    
    class Meta:
        model = GalleryPhoto
        fields = '__all__'


class GalleryVideoSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    
    class Meta:
        model = GalleryVideo
        fields = '__all__'


