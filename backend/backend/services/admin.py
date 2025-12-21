
# ============================================
# services/admin.py
# ============================================
from django.contrib import admin
from .models import Service, PricingPlan, ServiceBooking, ServiceInquiry


@admin.register(Service)
class ServiceAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'price', 'is_featured', 'is_active', 'display_order']
    list_filter = ['category', 'is_featured', 'is_active']
    search_fields = ['name', 'description']
    list_editable = ['is_featured', 'is_active', 'display_order']


@admin.register(PricingPlan)
class PricingPlanAdmin(admin.ModelAdmin):
    list_display = ['name', 'price', 'duration', 'is_popular', 'is_active', 'display_order']
    list_filter = ['is_popular', 'is_active']
    list_editable = ['is_popular', 'is_active', 'display_order']


@admin.register(ServiceBooking)
class ServiceBookingAdmin(admin.ModelAdmin):
    list_display = ['user', 'service', 'date', 'time', 'status', 'payment_status', 'created_at']
    list_filter = ['status', 'payment_status', 'date']
    search_fields = ['user__username', 'service__name']
    date_hierarchy = 'date'


@admin.register(ServiceInquiry)
class ServiceInquiryAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'service', 'status', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['name', 'email', 'message']

