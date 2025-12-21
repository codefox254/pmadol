

# ============================================
# contact/admin.py
# ============================================
from django.contrib import admin
from .models import ContactMessage, ConsultationRequest, NewsletterSubscriber, ContactInfo


@admin.register(ContactMessage)
class ContactMessageAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'subject', 'status', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['name', 'email', 'subject', 'message']
    list_editable = ['status']


@admin.register(ConsultationRequest)
class ConsultationRequestAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'service_interest', 'preferred_date', 'status', 'created_at']
    list_filter = ['status', 'preferred_date', 'created_at']
    search_fields = ['name', 'email', 'service_interest']
    list_editable = ['status']


@admin.register(NewsletterSubscriber)
class NewsletterSubscriberAdmin(admin.ModelAdmin):
    list_display = ['email', 'is_active', 'subscribed_at']
    list_filter = ['is_active', 'subscribed_at']
    search_fields = ['email']


@admin.register(ContactInfo)
class ContactInfoAdmin(admin.ModelAdmin):
    list_display = ['phone', 'email', 'updated_at']
    
    def has_add_permission(self, request):
        return not ContactInfo.objects.exists()
    
    def has_delete_permission(self, request, obj=None):
        return False


