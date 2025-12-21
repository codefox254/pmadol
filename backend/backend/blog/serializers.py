
# ============================================
# blog/serializers.py
# ============================================
from rest_framework import serializers
from .models import Category, Post, Comment, PostLike


class CategorySerializer(serializers.ModelSerializer):
    post_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Category
        fields = '__all__'
    
    def get_post_count(self, obj):
        return obj.posts.filter(status='published').count()


class CommentSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.username', read_only=True)
    user_avatar = serializers.ImageField(source='user.avatar', read_only=True)
    replies = serializers.SerializerMethodField()
    
    class Meta:
        model = Comment
        fields = '__all__'
        read_only_fields = ['user', 'created_at', 'updated_at']
    
    def get_replies(self, obj):
        if obj.parent is None:
            replies = obj.replies.filter(is_approved=True)
            return CommentSerializer(replies, many=True).data
        return []


class PostListSerializer(serializers.ModelSerializer):
    """Simplified serializer for list views"""
    author_name = serializers.CharField(source='author.username', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)
    comments_count = serializers.SerializerMethodField()
    likes_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Post
        fields = ['id', 'title', 'slug', 'author_name', 'category_name', 
                  'excerpt', 'featured_image', 'is_featured', 'views', 
                  'comments_count', 'likes_count', 'published_at']
    
    def get_comments_count(self, obj):
        return obj.comments.filter(is_approved=True).count()
    
    def get_likes_count(self, obj):
        return obj.likes.count()


class PostDetailSerializer(serializers.ModelSerializer):
    """Detailed serializer for single post view"""
    author_name = serializers.CharField(source='author.username', read_only=True)
    author_avatar = serializers.ImageField(source='author.avatar', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)
    comments = CommentSerializer(many=True, read_only=True)
    comments_count = serializers.SerializerMethodField()
    likes_count = serializers.SerializerMethodField()
    is_liked = serializers.SerializerMethodField()
    
    class Meta:
        model = Post
        fields = '__all__'
    
    def get_comments_count(self, obj):
        return obj.comments.filter(is_approved=True, parent=None).count()
    
    def get_likes_count(self, obj):
        return obj.likes.count()
    
    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.likes.filter(user=request.user).exists()
        return False
