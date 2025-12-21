# apps/accounts/urls.py
from django.urls import path
from .views import (
    UserRegistrationView, UserLoginView, UserLogoutView,
    UserDetailView, ChangePasswordView, CoachProfileView
)

app_name = 'accounts'

urlpatterns = [
    path('register/', UserRegistrationView.as_view(), name='register'),
    path('login/', UserLoginView.as_view(), name='login'),
    path('logout/', UserLogoutView.as_view(), name='logout'),
    path('me/', UserDetailView.as_view(), name='user-detail'),
    path('change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('coach/profile/', CoachProfileView.as_view(), name='coach-profile'),
]