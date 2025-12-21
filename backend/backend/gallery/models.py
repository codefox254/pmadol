# ============================================
# gallery/models.py
# ============================================
from django.db import models


class GalleryCategory(models.Model):
    """Gallery categories"""
    TYPE_CHOICES = [
        ('photo', 'Photo'),
        ('video', 'Video'),
    ]
    
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    type = models.CharField(max_length=10, choices=TYPE_CHOICES)
    is_active = models.BooleanField(default=True)
    
    class Meta:
        verbose_name_plural = 'Gallery Categories'
        ordering = ['name']
    
    def __str__(self):
        return f"{self.name} ({self.type})"


class GalleryPhoto(models.Model):
    """Gallery photos"""
    title = models.CharField(max_length=200)
    image = models.ImageField(upload_to='gallery/photos/')
    caption = models.TextField(blank=True)
    category = models.ForeignKey(GalleryCategory, on_delete=models.SET_NULL, null=True, related_name='photos')
    date_taken = models.DateField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['display_order', '-created_at']
        verbose_name_plural = 'Gallery Photos'
    
    def __str__(self):
        return self.title


class GalleryVideo(models.Model):
    """Gallery videos"""
    title = models.CharField(max_length=200)
    video_url = models.URLField()
    thumbnail = models.ImageField(upload_to='gallery/videos/')
    description = models.TextField(blank=True)
    category = models.ForeignKey(GalleryCategory, on_delete=models.SET_NULL, null=True, related_name='videos')
    date_recorded = models.DateField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['display_order', '-created_at']
        verbose_name_plural = 'Gallery Videos'
    
    def __str__(self):
        return self.title



