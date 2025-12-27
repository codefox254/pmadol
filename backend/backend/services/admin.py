
# ============================================
# services/admin.py
# ============================================
from django.contrib import admin
from django.utils import timezone
from .models import Service, MembershipPlan, ClubMembership, ServiceEnrollment, TeamMember


@admin.register(Service)
class ServiceAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'price', 'is_featured', 'is_active', 'display_order']
    list_filter = ['category', 'is_featured', 'is_active']
    search_fields = ['name', 'description']
    list_editable = ['is_featured', 'is_active', 'display_order']


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


@admin.register(ServiceEnrollment)
class ServiceEnrollmentAdmin(admin.ModelAdmin):
    list_display = ['full_name', 'email', 'phone_number', 'service', 'approval_status', 'created_at']
    list_filter = ['approval_status', 'subscribed_to_newsletter', 'created_at']
    search_fields = ['full_name', 'email', 'phone_number', 'service__name', 'message']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'
    
    fieldsets = (
        ('Contact Information', {
            'fields': ('full_name', 'email', 'phone_number')
        }),
        ('Enrollment Details', {
            'fields': ('service', 'message', 'subscribed_to_newsletter')
        }),
        ('Status', {
            'fields': ('approval_status', 'created_at', 'updated_at')
        }),
    )
    
    actions = ['approve_enrollments', 'reject_enrollments']
    
    def approve_enrollments(self, request, queryset):
        updated = queryset.update(approval_status='approved')
        self.message_user(request, f'{updated} enrollment(s) approved successfully.')
    approve_enrollments.short_description = 'Approve selected enrollments'
    
    def reject_enrollments(self, request, queryset):
        updated = queryset.update(approval_status='rejected')
        self.message_user(request, f'{updated} enrollment(s) rejected.')
    reject_enrollments.short_description = 'Reject selected enrollments'


@admin.register(TeamMember)
class TeamMemberAdmin(admin.ModelAdmin):
    list_display = ['full_name', 'email', 'phone_number', 'role', 'is_active', 'joined_date', 'display_order']
    list_filter = ['is_active', 'joined_date']
    search_fields = ['full_name', 'email', 'phone_number', 'bio', 'role']
    list_editable = ['is_active', 'display_order']
    readonly_fields = ['joined_date']
    ordering = ['display_order', 'full_name']
    
    fieldsets = (
        ('Personal Information', {
            'fields': ('full_name', 'email', 'phone_number', 'image')
        }),
        ('Team Details', {
            'fields': ('role', 'bio', 'display_order')
        }),
        ('Status', {
            'fields': ('is_active', 'joined_date')
        }),
    )
