
# ============================================
# services/admin.py
# ============================================
from django.contrib import admin
from django.utils import timezone
from .models import Service, PricingPlan, ServiceBooking, ServiceInquiry, MembershipPlan, ClubMembership


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


@admin.register(MembershipPlan)
class MembershipPlanAdmin(admin.ModelAdmin):
    list_display = ['name', 'plan_type', 'price', 'is_default', 'is_active', 'display_order', 'created_at']
    list_filter = ['plan_type', 'is_default', 'is_active']
    search_fields = ['name', 'description']
    list_editable = ['is_default', 'is_active', 'display_order']
    ordering = ['display_order', 'price']


@admin.register(ClubMembership)
class ClubMembershipAdmin(admin.ModelAdmin):
    list_display = [
        'membership_number', 'full_name', 'email', 'phone_number', 
        'member_type', 'payment_status', 'registration_status', 'registration_date'
    ]
    list_filter = [
        'member_type', 'payment_status', 'registration_status', 
        'is_child_registration', 'newsletter_subscription', 'registration_date'
    ]
    search_fields = [
        'first_name', 'last_name', 'email', 'phone_number', 
        'membership_number', 'mpesa_transaction_id'
    ]
    readonly_fields = ['membership_number', 'registration_date', 'payment_date']
    date_hierarchy = 'registration_date'
    
    fieldsets = (
        ('Personal Information', {
            'fields': ('first_name', 'last_name', 'email', 'phone_number', 'age', 'location')
        }),
        ('Membership Details', {
            'fields': ('member_type', 'membership_plan', 'membership_number')
        }),
        ('Parent/Guardian Information', {
            'fields': ('is_child_registration', 'parent_name', 'parent_email', 'parent_phone'),
            'classes': ('collapse',),
        }),
        ('Payment Information', {
            'fields': (
                'payment_status', 'payment_amount', 'payment_date',
                'mpesa_transaction_id', 'mpesa_phone_number'
            )
        }),
        ('Consents', {
            'fields': ('consent_given', 'privacy_accepted', 'newsletter_subscription')
        }),
        ('Registration Management', {
            'fields': (
                'registration_status', 'registration_date', 
                'approval_date', 'approved_by', 'notes'
            )
        }),
    )
    
    actions = ['approve_memberships', 'mark_as_active', 'mark_payment_completed']
    
    def full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"
    full_name.short_description = 'Full Name'
    
    def approve_memberships(self, request, queryset):
        updated = queryset.update(
            registration_status='approved',
            approval_date=timezone.now(),
            approved_by=request.user
        )
        self.message_user(request, f'{updated} membership(s) approved successfully.')
    approve_memberships.short_description = 'Approve selected memberships'
    
    def mark_as_active(self, request, queryset):
        updated = queryset.update(registration_status='active')
        self.message_user(request, f'{updated} membership(s) marked as active.')
    mark_as_active.short_description = 'Mark as active members'
    
    def mark_payment_completed(self, request, queryset):
        updated = queryset.update(payment_status='completed', payment_date=timezone.now())
        self.message_user(request, f'{updated} payment(s) marked as completed.')
    mark_payment_completed.short_description = 'Mark payment as completed'
