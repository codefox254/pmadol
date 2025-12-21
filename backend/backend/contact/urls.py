# apps/contact/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ContactSubmissionViewSet

app_name = 'contact'

router = DefaultRouter()
router.register(r'submissions', ContactSubmissionViewSet, basename='contactsubmission')

urlpatterns = [
    path('', include(router.urls)),
]