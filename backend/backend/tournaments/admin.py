# ============================================
# tournaments/admin.py
# ============================================
from django.contrib import admin
from .models import Tournament, TournamentRegistration


@admin.register(Tournament)
class TournamentAdmin(admin.ModelAdmin):
    list_display = ['title', 'start_date', 'location', 'format', 'registration_count', 'is_active']
    list_filter = ['is_active', 'location', 'format', 'start_date']
    search_fields = ['title', 'description']
    date_hierarchy = 'start_date'
    ordering = ['-start_date']
    
    fieldsets = (
        ('Basic Information', {
            'fields': ('title', 'description', 'image', 'is_active')
        }),
        ('Schedule', {
            'fields': ('start_date', 'end_date')
        }),
        ('Location & Format', {
            'fields': ('location', 'venue_details', 'format', 'time_control')
        }),
        ('Registration', {
            'fields': ('requires_registration', 'max_participants', 'entry_fee')
        }),
        ('External Links', {
            'fields': ('lichess_link', 'results_link'),
            'description': 'Add Lichess tournament link for daily/weekly tournaments'
        }),
    )
    
    def registration_count(self, obj):
        return obj.registration_count
    registration_count.short_description = 'Registrations'


@admin.register(TournamentRegistration)
class TournamentRegistrationAdmin(admin.ModelAdmin):
    list_display = ['full_name', 'tournament', 'email', 'lichess_username', 'is_confirmed', 'attended', 'registered_at']
    list_filter = ['is_confirmed', 'attended', 'tournament', 'registered_at']
    search_fields = ['full_name', 'email', 'lichess_username', 'tournament__title']
    date_hierarchy = 'registered_at'
    ordering = ['-registered_at']
    
    fieldsets = (
        ('Tournament', {
            'fields': ('tournament',)
        }),
        ('Participant Information', {
            'fields': ('full_name', 'email', 'phone_number', 'lichess_username', 'rating')
        }),
        ('Message', {
            'fields': ('message',)
        }),
        ('Status', {
            'fields': ('is_confirmed', 'attended')
        }),
    )
    
    actions = ['confirm_registrations', 'mark_as_attended']
    
    def confirm_registrations(self, request, queryset):
        updated = queryset.update(is_confirmed=True)
        self.message_user(request, f'{updated} registration(s) confirmed.')
    confirm_registrations.short_description = "Confirm selected registrations"
    
    def mark_as_attended(self, request, queryset):
        updated = queryset.update(attended=True)
        self.message_user(request, f'{updated} registration(s) marked as attended.')
    mark_as_attended.short_description = "Mark as attended"
