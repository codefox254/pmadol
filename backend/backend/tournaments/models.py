# ============================================
# tournaments/models.py
# ============================================
from django.db import models
from django.core.validators import MinValueValidator


class Tournament(models.Model):
    """Tournament model for both internal and Lichess tournaments"""
    FORMAT_CHOICES = [
        ('round_robin', 'Round Robin'),
        ('swiss', 'Swiss System'),
        ('knockout', 'Knockout'),
        ('arena', 'Arena'),
    ]
    
    LOCATION_CHOICES = [
        ('online_lichess', 'Online (Lichess)'),
        ('online_chesscom', 'Online (Chess.com)'),
        ('physical', 'Physical Venue'),
        ('hybrid', 'Hybrid (Online & Physical)'),
    ]
    
    title = models.CharField(max_length=200)
    description = models.TextField()
    start_date = models.DateTimeField()
    end_date = models.DateTimeField(null=True, blank=True)
    location = models.CharField(max_length=50, choices=LOCATION_CHOICES, default='online_lichess')
    venue_details = models.TextField(blank=True, help_text="Physical address or additional location info")
    format = models.CharField(max_length=20, choices=FORMAT_CHOICES, default='swiss')
    time_control = models.CharField(max_length=50, default='10+0', help_text="E.g., 10+0, 5+3, 15+10")
    entry_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0, validators=[MinValueValidator(0)])
    max_participants = models.PositiveIntegerField(null=True, blank=True)
    image = models.ImageField(upload_to='tournaments/', blank=True, null=True)
    
    # Lichess integration
    lichess_link = models.URLField(blank=True, help_text="Lichess tournament link for users to join directly")
    
    # Results
    results_link = models.URLField(blank=True, help_text="Link to tournament results/standings")
    
    # Status
    is_active = models.BooleanField(default=True)
    requires_registration = models.BooleanField(
        default=True, 
        help_text="If False, users click Lichess link directly without registering"
    )
    
    # Meta
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-start_date']
    
    def __str__(self):
        return self.title
    
    @property
    def registration_count(self):
        return self.registrations.count()
    
    @property
    def is_full(self):
        if self.max_participants:
            return self.registration_count >= self.max_participants
        return False


class TournamentRegistration(models.Model):
    """User registration for tournaments"""
    tournament = models.ForeignKey(
        Tournament, 
        on_delete=models.CASCADE, 
        related_name='registrations'
    )
    full_name = models.CharField(max_length=100)
    email = models.EmailField()
    phone_number = models.CharField(max_length=20, blank=True)
    lichess_username = models.CharField(max_length=100, blank=True, help_text="Optional Lichess username")
    rating = models.PositiveIntegerField(null=True, blank=True, help_text="Chess rating (optional)")
    message = models.TextField(blank=True)
    
    # Status
    is_confirmed = models.BooleanField(default=False)
    attended = models.BooleanField(default=False)
    
    # Meta
    registered_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['registered_at']
        unique_together = ['tournament', 'email']
    
    def __str__(self):
        return f"{self.full_name} - {self.tournament.title}"
