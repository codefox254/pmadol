from django.db import models
from django.conf import settings
from django.utils.text import slugify
from django.utils import timezone

class BlogPost(models.Model):
    """Blog posts for content marketing"""
    
    STATUS_CHOICES = (
        ('draft', 'Draft'),
        ('published', 'Published'),
    )
    
    CATEGORY_CHOICES = (
        ('tips', 'Tips & Tricks'),
        ('strategy', 'Strategy'),
        ('tournaments', 'Tournaments'),
        ('news', 'News'),
        ('training', 'Training'),
        ('beginner', 'Beginner Guide'),
    )
    
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='blog_posts'
    )
    
    title = models.CharField(max_length=300)
    slug = models.SlugField(max_length=350, unique=True, blank=True)
    excerpt = models.TextField(max_length=500, help_text="Brief summary for listings")
    content = models.TextField(help_text="Full article content (supports HTML)")
    
    featured_image = models.ImageField(upload_to='blog/', null=True, blank=True)
    
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES, default='tips')
    tags = models.JSONField(default=list, blank=True, help_text="List of tags")
    
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='draft')
    is_featured = models.BooleanField(default=False, help_text="Display prominently on blog page")
    
    view_count = models.IntegerField(default=0)
    
    # SEO fields
    meta_title = models.CharField(max_length=60, blank=True, help_text="SEO title (60 chars max)")
    meta_description = models.CharField(max_length=160, blank=True, help_text="SEO description (160 chars max)")
    
    published_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'blog_posts'
        verbose_name = 'Blog Post'
        verbose_name_plural = 'Blog Posts'
        ordering = ['-published_at', '-created_at']
        indexes = [
            models.Index(fields=['-published_at']),
            models.Index(fields=['status']),
            models.Index(fields=['category']),
        ]
    
    def __str__(self):
        return self.title
    
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        
        # Auto-set published_at when status changes to published
        if self.status == 'published' and not self.published_at:
            self.published_at = timezone.now()
        
        # Auto-generate SEO fields if not provided
        if not self.meta_title:
            self.meta_title = self.title[:60]
        if not self.meta_description:
            self.meta_description = self.excerpt[:160]
        
        super().save(*args, **kwargs)
    
    def increment_views(self):
        """Increment view count"""
        self.view_count += 1
        self.save(update_fields=['view_count'])