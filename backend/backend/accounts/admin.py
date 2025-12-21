# ============================================
# accounts/admin.py
# ============================================
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, StudentProfile, InstructorProfile


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ['username', 'email', 'user_type', 'is_verified', 'is_active', 'created_at']
    list_filter = ['user_type', 'is_verified', 'is_active']
    search_fields = ['username', 'email', 'first_name', 'last_name']
    
    fieldsets = BaseUserAdmin.fieldsets + (
        ('Additional Info', {'fields': ('user_type', 'phone', 'avatar', 
                                        'date_of_birth', 'address', 'is_verified')}),
    )


@admin.register(StudentProfile)
class StudentProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'chess_level', 'rating', 'school', 'joined_date']
    list_filter = ['chess_level']
    search_fields = ['user__username', 'school']


@admin.register(InstructorProfile)
class InstructorProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'specialization', 'years_experience', 'hourly_rate', 'is_available']
    list_filter = ['is_available']
    search_fields = ['user__username', 'specialization']


# ============================================
# accounts/apps.py
# ============================================
from django.apps import AppConfig


class AccountsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'accounts'