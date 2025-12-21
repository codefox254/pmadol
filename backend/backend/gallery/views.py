
# ============================================
# gallery/views.py
# ============================================
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import GalleryCategory, GalleryPhoto, GalleryVideo
from .serializers import *


class GalleryCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = GalleryCategory.objects.filter(is_active=True)
    serializer_class = GalleryCategorySerializer
    lookup_field = 'slug'


class GalleryPhotoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = GalleryPhoto.objects.filter(is_active=True)
    serializer_class = GalleryPhotoSerializer
    
    @action(detail=False, methods=['get'])
    def by_category(self, request):
        category_slug = request.query_params.get('category')
        if category_slug:
            photos = self.queryset.filter(category__slug=category_slug)
        else:
            photos = self.queryset
        page = self.paginate_queryset(photos)
        serializer = self.get_serializer(page, many=True)
        return self.get_paginated_response(serializer.data)


class GalleryVideoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = GalleryVideo.objects.filter(is_active=True)
    serializer_class = GalleryVideoSerializer
    
    @action(detail=False, methods=['get'])
    def by_category(self, request):
        category_slug = request.query_params.get('category')
        if category_slug:
            videos = self.queryset.filter(category__slug=category_slug)
        else:
            videos = self.queryset
        page = self.paginate_queryset(videos)
        serializer = self.get_serializer(page, many=True)
        return self.get_paginated_response(serializer.data)

