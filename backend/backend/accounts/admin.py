from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, CoachProfile


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    model = User
    list_display = ("username", "email", "is_staff", "is_active")
    search_fields = ("username", "email")
    ordering = ("username",)


@admin.register(CoachProfile)
class CoachProfileAdmin(admin.ModelAdmin):
    list_display = ("user", "experience_years", "is_verified")
    list_filter = ("is_verified",)
