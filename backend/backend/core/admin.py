
# ============================================
# core/admin.py
# ============================================
from django.contrib import admin
from .models import *


@admin.register(SiteSettings)
class SiteSettingsAdmin(admin.ModelAdmin):
    list_display = ['site_name', 'email', 'phone', 'updated_at']
    
    def has_add_permission(self, request):
        return not SiteSettings.objects.exists()
    
    def has_delete_permission(self, request, obj=None):
        return False


@admin.register(Statistics)
class StatisticsAdmin(admin.ModelAdmin):
    list_display = ['awards_count', 'years_experience', 'students_count', 'trainers_count', 'updated_at']
    
    def has_add_permission(self, request):
        return not Statistics.objects.exists()
    
    def has_delete_permission(self, request, obj=None):
        return False


@admin.register(Testimonial)
class TestimonialAdmin(admin.ModelAdmin):
    list_display = ['author', 'role', 'rating', 'is_featured', 'is_active', 'display_order']
    list_filter = ['role', 'is_featured', 'is_active']
    search_fields = ['author', 'content']
    list_editable = ['is_featured', 'is_active', 'display_order']


@admin.register(Partner)
class PartnerAdmin(admin.ModelAdmin):
    list_display = ['name', 'website', 'is_active', 'display_order']
    list_filter = ['is_active']
    search_fields = ['name']
    list_editable = ['is_active', 'display_order']


@admin.register(TeamMember)
class TeamMemberAdmin(admin.ModelAdmin):
    list_display = ['name', 'role', 'email', 'is_active', 'display_order']
    list_filter = ['role', 'is_active']
    search_fields = ['name', 'email']
    list_editable = ['is_active', 'display_order']


@admin.register(FAQ)
class FAQAdmin(admin.ModelAdmin):
    list_display = ['question', 'category', 'is_active', 'display_order']
    list_filter = ['category', 'is_active']
    search_fields = ['question', 'answer']
    list_editable = ['is_active', 'display_order']


@admin.register(AboutContent)
class AboutContentAdmin(admin.ModelAdmin):
    list_display = ['story_title', 'founded_year', 'updated_at']
    
    def has_add_permission(self, request):
        return not AboutContent.objects.exists()
    
    def has_delete_permission(self, request, obj=None):
        return False


@admin.register(CoreValue)
class CoreValueAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_active', 'display_order']
    list_filter = ['is_active']
    search_fields = ['title', 'description']
    list_editable = ['is_active', 'display_order']


