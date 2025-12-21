
# ============================================
# gallery/admin.py
# ============================================
from django.contrib import admin
from .models import GalleryCategory, GalleryPhoto, GalleryVideo


@admin.register(GalleryCategory)
class GalleryCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'type', 'is_active']
    prepopulated_fields = {'slug': ('name',)}


@admin.register(GalleryPhoto)
class GalleryPhotoAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'date_taken', 'is_active', 'display_order']
    list_filter = ['category', 'is_active', 'date_taken']
    search_fields = ['title', 'caption']
    list_editable = ['is_active', 'display_order']


@admin.register(GalleryVideo)
class GalleryVideoAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'date_recorded', 'is_active', 'display_order']
    list_filter = ['category', 'is_active', 'date_recorded']
    search_fields = ['title', 'description']
    list_editable = ['is_active', 'display_order']


