# ============================================
# core/models.py
# ============================================
from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator


class SiteSettings(models.Model):
    """Single instance model for site-wide settings"""
    site_name = models.CharField(max_length=100, default="PMadol Chess Club")
    tagline = models.CharField(max_length=200, default="Building and Nurturing Champions")
    logo = models.ImageField(upload_to='site/', blank=True, null=True)
    favicon = models.ImageField(upload_to='site/', blank=True, null=True)
    primary_color = models.CharField(max_length=7, default="#5886BF")
    secondary_color = models.CharField(max_length=7, default="#283D57")
    phone = models.CharField(max_length=20, default="+254 714 272 082")
    email = models.EmailField(default="info@pmadol.com")
    address = models.TextField(default="Nairobi - Kenya")
    working_hours = models.TextField(default="Monday - Saturday: 8AM - 10PM\nSunday: 10AM - 8PM")
    facebook_url = models.URLField(blank=True, null=True)
    instagram_url = models.URLField(blank=True, null=True)
    twitter_url = models.URLField(blank=True, null=True)
    youtube_url = models.URLField(blank=True, null=True)
    linkedin_url = models.URLField(blank=True, null=True)
    map_url = models.URLField(blank=True, null=True, help_text="Google Maps location URL for the academy")
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = "Site Settings"
        verbose_name_plural = "Site Settings"
    
    def __str__(self):
        return self.site_name
    
    def save(self, *args, **kwargs):
        self.pk = 1
        super().save(*args, **kwargs)
    
    @classmethod
    def get_settings(cls):
        obj, created = cls.objects.get_or_create(pk=1)
        return obj


class HeroSlide(models.Model):
    """Images used for the homepage hero carousel"""
    title = models.CharField(max_length=150, blank=True, default="")
    subtitle = models.CharField(max_length=250, blank=True, default="")
    image = models.ImageField(upload_to='hero/')
    is_active = models.BooleanField(default=True)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['display_order', '-created_at']

    def __str__(self):
        return self.title or f"Hero Slide {self.pk}"


class Statistics(models.Model):
    """Homepage statistics"""
    awards_count = models.PositiveIntegerField(default=23)
    years_experience = models.PositiveIntegerField(default=9)
    students_count = models.PositiveIntegerField(default=771)
    trainers_count = models.PositiveIntegerField(default=12)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = "Statistics"
        verbose_name_plural = "Statistics"
    
    def __str__(self):
        return f"Site Statistics - {self.updated_at}"
    
    def save(self, *args, **kwargs):
        self.pk = 1
        super().save(*args, **kwargs)
    
    @classmethod
    def get_stats(cls):
        obj, created = cls.objects.get_or_create(pk=1)
        return obj


class Testimonial(models.Model):
    """Customer testimonials"""
    ROLE_CHOICES = [
        ('parent', 'Parent'),
        ('student', 'Student'),
        ('instructor', 'Instructor'),
        ('partner', 'Partner'),
    ]
    
    author = models.CharField(max_length=100)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='parent')
    content = models.TextField()
    rating = models.PositiveIntegerField(
        default=5,
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    photo = models.ImageField(upload_to='testimonials/', blank=True, null=True)
    is_featured = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['display_order', '-created_at']
    
    def __str__(self):
        return f"{self.author} - {self.role}"


class Partner(models.Model):
    """Partners and sponsors"""
    name = models.CharField(max_length=100)
    logo = models.ImageField(upload_to='partners/')
    website = models.URLField(blank=True, null=True)
    description = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['display_order', 'name']
    
    def __str__(self):
        return self.name


class TeamMember(models.Model):
    """Team members and coaches"""
    ROLE_CHOICES = [
        ('founder', 'Founder'),
        ('director', 'Director'),
        ('head_coach', 'Head Coach'),
        ('coach', 'Coach'),
        ('assistant_coach', 'Assistant Coach'),
    ]
    
    name = models.CharField(max_length=100)
    role = models.CharField(max_length=50, choices=ROLE_CHOICES)
    bio = models.TextField()
    photo = models.ImageField(upload_to='team/')
    qualifications = models.TextField(blank=True)
    rating = models.CharField(max_length=50, blank=True)
    email = models.EmailField(blank=True)
    phone = models.CharField(max_length=20, blank=True)
    is_active = models.BooleanField(default=True)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['display_order', 'name']
    
    def __str__(self):
        return f"{self.name} - {self.role}"


class FAQ(models.Model):
    """Frequently Asked Questions"""
    CATEGORY_CHOICES = [
        ('general', 'General'),
        ('services', 'Services'),
        ('pricing', 'Pricing'),
        ('booking', 'Booking'),
    ]
    
    question = models.CharField(max_length=300)
    answer = models.TextField()
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='general')
    is_active = models.BooleanField(default=True)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['category', 'display_order']
    
    def __str__(self):
        return self.question


class AboutContent(models.Model):
    """About page content"""
    story_title = models.CharField(max_length=200, default="Our Story")
    story_content = models.TextField()
    story_image = models.ImageField(upload_to='about/', blank=True, null=True)
    mission_statement = models.TextField()
    vision_statement = models.TextField()
    founded_year = models.PositiveIntegerField(default=2016)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = "About Content"
        verbose_name_plural = "About Content"
    
    def __str__(self):
        return "About Page Content"
    
    def save(self, *args, **kwargs):
        self.pk = 1
        super().save(*args, **kwargs)
    
    @classmethod
    def get_content(cls):
        obj, created = cls.objects.get_or_create(pk=1)
        return obj


class CoreValue(models.Model):
    """Core values"""
    title = models.CharField(max_length=100)
    description = models.TextField()
    icon = models.CharField(max_length=50, blank=True)
    display_order = models.PositiveIntegerField(default=0)
    is_active = models.BooleanField(default=True)
    
    class Meta:
        ordering = ['display_order']
    
    def __str__(self):
        return self.title
