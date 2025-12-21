# apps/gallery/views.py
from rest_framework import viewsets, filters, permissions
from django_filters.rest_framework import DjangoFilterBackend
from apps.gallery.models import GalleryItem
from apps.gallery.serializers import GalleryItemSerializer

class GalleryItemViewSet(viewsets.ModelViewSet):
    """ViewSet for gallery items"""
    queryset = GalleryItem.objects.all()
    serializer_class = GalleryItemSerializer
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    filterset_fields = ['media_type', 'category', 'is_featured']
    ordering_fields = ['display_order', 'created_at']
    ordering = ['display_order', '-created_at']
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.AllowAny()]

