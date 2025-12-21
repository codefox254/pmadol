# ============================================
# accounts/models.py
# ============================================
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import RegexValidator


class User(AbstractUser):
    """Extended User model"""
    USER_TYPE_CHOICES = [
        ('student', 'Student'),
        ('parent', 'Parent'),
        ('instructor', 'Instructor'),
        ('admin', 'Administrator'),
    ]
    
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES, default='student')
    phone = models.CharField(max_length=20, blank=True)
    avatar = models.ImageField(upload_to='avatars/', blank=True, null=True)
    date_of_birth = models.DateField(blank=True, null=True)
    address = models.TextField(blank=True)
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.username} - {self.get_user_type_display()}"


class StudentProfile(models.Model):
    """Student specific information"""
    LEVEL_CHOICES = [
        ('beginner', 'Beginner'),
        ('intermediate', 'Intermediate'),
        ('advanced', 'Advanced'),
        ('expert', 'Expert'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='student_profile')
    parent_name = models.CharField(max_length=100, blank=True)
    parent_phone = models.CharField(max_length=20, blank=True)
    parent_email = models.EmailField(blank=True)
    school = models.CharField(max_length=200, blank=True)
    grade = models.CharField(max_length=20, blank=True)
    chess_level = models.CharField(max_length=20, choices=LEVEL_CHOICES, default='beginner')
    rating = models.PositiveIntegerField(default=0)
    joined_date = models.DateField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.user.username} - Student Profile"


class InstructorProfile(models.Model):
    """Instructor specific information"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='instructor_profile')
    bio = models.TextField()
    qualifications = models.TextField()
    specialization = models.CharField(max_length=200)
    rating = models.CharField(max_length=50, blank=True)
    years_experience = models.PositiveIntegerField(default=0)
    hourly_rate = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    is_available = models.BooleanField(default=True)
    
    def __str__(self):
        return f"{self.user.username} - Instructor Profile"

