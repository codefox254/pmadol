from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    """
    Custom user model
    """
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.username


class CoachProfile(models.Model):
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="coach_profile"
    )
    bio = models.TextField(blank=True)
    experience_years = models.PositiveIntegerField(default=0)
    is_verified = models.BooleanField(default=False)

    def __str__(self):
        return f"CoachProfile({self.user.username})"
