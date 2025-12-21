# apps/blog/views.py
from rest_framework import viewsets, filters, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from .models import BlogPost
from .serializers import (
    BlogPostSerializer, BlogPostListSerializer,
    BlogPostCreateUpdateSerializer
)

class BlogPostViewSet(viewsets.ModelViewSet):
    """ViewSet for blog posts"""
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['category', 'status', 'is_featured']
    search_fields = ['title', 'content', 'excerpt']
    ordering_fields = ['published_at', 'view_count', 'created_at']
    ordering = ['-published_at']
    lookup_field = 'slug'
    
    def get_queryset(self):
        user = self.request.user
        if user.is_staff:
            return BlogPost.objects.all()
        return BlogPost.objects.filter(status='published')
    
    def get_serializer_class(self):
        if self.action == 'list':
            return BlogPostListSerializer
        if self.action in ['create', 'update', 'partial_update']:
            return BlogPostCreateUpdateSerializer
        return BlogPostSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.AllowAny()]
    
    @action(detail=True, methods=['post'])
    def increment_view(self, request, slug=None):
        """Increment view count for a blog post"""
        post = self.get_object()
        post.increment_views()
        return Response({'view_count': post.view_count})
    
    @action(detail=False, methods=['get'])
    def categories(self, request):
        """Get all blog categories"""
        categories = [{'value': choice[0], 'label': choice[1]} 
                     for choice in BlogPost.CATEGORY_CHOICES]
        return Response({'categories': categories})