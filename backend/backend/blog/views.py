
# ============================================
# blog/views.py
# ============================================
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from django.db.models import F, Q
from .models import Category, Post, Comment, PostLike
from .serializers import *


class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.filter(is_active=True)
    serializer_class = CategorySerializer
    lookup_field = 'slug'


class PostViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Post.objects.filter(status='published')
    permission_classes = [IsAuthenticatedOrReadOnly]
    lookup_field = 'slug'
    
    def get_serializer_class(self):
        if self.action == 'list':
            return PostListSerializer
        return PostDetailSerializer
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.views = F('views') + 1
        instance.save(update_fields=['views'])
        instance.refresh_from_db()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def featured(self, request):
        posts = self.queryset.filter(is_featured=True)[:3]
        serializer = PostListSerializer(posts, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def by_category(self, request):
        category_slug = request.query_params.get('category')
        if not category_slug:
            return Response({'error': 'Category parameter required'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        posts = self.queryset.filter(category__slug=category_slug)
        page = self.paginate_queryset(posts)
        serializer = PostListSerializer(page, many=True)
        return self.get_paginated_response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def search(self, request):
        query = request.query_params.get('q', '')
        posts = self.queryset.filter(
            Q(title__icontains=query) | Q(content__icontains=query) | Q(excerpt__icontains=query)
        )
        page = self.paginate_queryset(posts)
        serializer = PostListSerializer(page, many=True)
        return self.get_paginated_response(serializer.data)
    
    @action(detail=True, methods=['get'])
    def related(self, request, slug=None):
        post = self.get_object()
        related = self.queryset.filter(category=post.category).exclude(id=post.id)[:3]
        serializer = PostListSerializer(related, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'], permission_classes=[IsAuthenticated])
    def like(self, request, slug=None):
        post = self.get_object()
        like, created = PostLike.objects.get_or_create(post=post, user=request.user)
        if not created:
            like.delete()
            return Response({'message': 'Post unliked'})
        return Response({'message': 'Post liked'})


class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.filter(is_approved=True)
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    def get_queryset(self):
        post_id = self.request.query_params.get('post')
        if post_id:
            return self.queryset.filter(post_id=post_id, parent=None)
        return self.queryset.filter(parent=None)


