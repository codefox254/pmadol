# ============================================
# services/models.py
# ============================================
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Service(models.Model):
    """Chess services offered"""
    CATEGORY_CHOICES = [
        ('lessons', 'Lessons'),
        ('training', 'Training'),
        ('workshops', 'Workshops'),
        ('tournaments', 'Tournaments'),
    ]
    
    name = models.CharField(max_length=200)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES)
    description = models.TextField()
    features = models.JSONField(default=list)
    image = models.ImageField(upload_to='services/')
    price = models.DecimalField(max_digits=10, decimal_places=2)
    duration = models.CharField(max_length=100)
    is_active = models.BooleanField(default=True)
    is_featured = models.BooleanField(default=False)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['display_order', 'name']
    
    def __str__(self):
        return self.name


class MembershipPlan(models.Model):
    """Membership subscription plans"""
    PLAN_TYPE_CHOICES = [
        ('monthly', 'Monthly'),
        ('quarterly', 'Quarterly'),
        ('semi_annual', 'Semi-Annual'),
        ('annual', 'Annual'),
    ]
    
    name = models.CharField(max_length=100)
    plan_type = models.CharField(max_length=20, choices=PLAN_TYPE_CHOICES, default='monthly')
    price = models.DecimalField(max_digits=10, decimal_places=2, help_text="Price in KES")
    description = models.TextField()
    features = models.JSONField(default=list, help_text="List of features included in this plan")
    is_active = models.BooleanField(default=True)
    is_default = models.BooleanField(default=False, help_text="Default plan for new registrations")
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['display_order', 'price']
        verbose_name = "Membership Plan"
        verbose_name_plural = "Membership Plans"
    
    def __str__(self):
        return f"{self.name} - KES {self.price}/{self.plan_type}"


class ServiceEnrollment(models.Model):
    """Service enrollment requests"""
    APPROVAL_STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
    ]
    
    service = models.ForeignKey(Service, on_delete=models.CASCADE, related_name='enrollments')
    full_name = models.CharField(max_length=200)
    email = models.EmailField()
    phone_number = models.CharField(max_length=20)
    message = models.TextField(blank=True, help_text="Additional message or questions")
    subscribed_to_newsletter = models.BooleanField(default=False)
    approval_status = models.CharField(max_length=20, choices=APPROVAL_STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = "Service Enrollment"
        verbose_name_plural = "Service Enrollments"
    
    def __str__(self):
        return f"{self.full_name} - {self.service.name}"
    
    def save(self, *args, **kwargs):
        # If this is "Become Team Member" enrollment and it's being approved, create a team member
        old_status = None
        if self.pk:
            try:
                old_status = ServiceEnrollment.objects.get(pk=self.pk).approval_status
            except ServiceEnrollment.DoesNotExist:
                pass
        
        super().save(*args, **kwargs)
        
        # Create team member when enrollment is approved for the first time
        if (old_status != 'approved' and self.approval_status == 'approved' and 
            self.service.name == 'Become Team Member'):
            TeamMember.objects.get_or_create(
                email=self.email,
                defaults={
                    'full_name': self.full_name,
                    'phone_number': self.phone_number,
                    'bio': self.message or '',
                    'is_active': True,
                }
            )


class TeamMember(models.Model):
    """Team members approved from service enrollments"""
    full_name = models.CharField(max_length=200)
    email = models.EmailField(unique=True)
    phone_number = models.CharField(max_length=20)
    bio = models.TextField(blank=True, help_text="Member bio or background")
    role = models.CharField(max_length=100, blank=True, help_text="Role or position")
    image = models.ImageField(upload_to='team/', blank=True, null=True)
    is_active = models.BooleanField(default=True)
    joined_date = models.DateTimeField(auto_now_add=True)
    display_order = models.PositiveIntegerField(default=0)
    
    class Meta:
        ordering = ['display_order', 'full_name']
        verbose_name = "Team Member"
        verbose_name_plural = "Team Members"
    
    def __str__(self):
        return self.full_name


class ClubMembership(models.Model):
    """Club membership registration"""
    MEMBER_TYPE_CHOICES = [
        ('student', 'Student'),
        ('adult', 'Adult'),
        ('parent_child', 'Parent registering for Child'),
    ]
    
    PAYMENT_STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('completed', 'Completed'),
        ('failed', 'Failed'),
    ]
    
    REGISTRATION_STATUS_CHOICES = [
        ('pending', 'Pending Approval'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('active', 'Active Member'),
        ('inactive', 'Inactive'),
    ]
    
    # Personal Information
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField()
    phone_number = models.CharField(max_length=20)
    age = models.PositiveIntegerField()
    location = models.CharField(max_length=200)
    
    # Membership Details
    member_type = models.CharField(max_length=20, choices=MEMBER_TYPE_CHOICES, default='student')
    membership_plan = models.ForeignKey(MembershipPlan, on_delete=models.SET_NULL, null=True)
    
    # Parent/Guardian Information (if registering for child)
    is_child_registration = models.BooleanField(default=False)
    parent_name = models.CharField(max_length=200, blank=True, null=True)
    parent_email = models.EmailField(blank=True, null=True)
    parent_phone = models.CharField(max_length=20, blank=True, null=True)
    
    # Payment Information
    payment_status = models.CharField(max_length=20, choices=PAYMENT_STATUS_CHOICES, default='pending')
    mpesa_transaction_id = models.CharField(max_length=100, blank=True, null=True)
    mpesa_phone_number = models.CharField(max_length=15, blank=True, null=True)
    payment_amount = models.DecimalField(max_digits=10, decimal_places=2, default=3000.00)
    payment_date = models.DateTimeField(blank=True, null=True)
    
    # Consents and Agreements
    consent_given = models.BooleanField(default=False, help_text="Consent to terms and conditions")
    privacy_accepted = models.BooleanField(default=False, help_text="Privacy policy accepted")
    newsletter_subscription = models.BooleanField(default=False, help_text="Subscribe to newsletters")
    
    # Registration Status
    registration_status = models.CharField(max_length=20, choices=REGISTRATION_STATUS_CHOICES, default='pending')
    registration_date = models.DateTimeField(auto_now_add=True)
    approval_date = models.DateTimeField(blank=True, null=True)
    approved_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='approved_memberships')
    
    # Additional Info
    notes = models.TextField(blank=True, help_text="Admin notes")
    membership_number = models.CharField(max_length=20, unique=True, blank=True, null=True)
    
    class Meta:
        ordering = ['-registration_date']
        verbose_name = "Club Membership"
        verbose_name_plural = "Club Memberships"
    
    def __str__(self):
        return f"{self.first_name} {self.last_name} - {self.get_registration_status_display()}"
    
    def save(self, *args, **kwargs):
        # Generate membership number if not exists
        if not self.membership_number:
            import random
            import string
            year = self.registration_date.year if self.registration_date else 2025
            random_str = ''.join(random.choices(string.digits, k=4))
            self.membership_number = f"PMC{year}{random_str}"
        super().save(*args, **kwargs)

