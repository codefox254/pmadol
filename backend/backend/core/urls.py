# apps/core/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import SiteSettingsViewSet, TestimonialViewSet, get_all_settings

app_name = 'core'

router = DefaultRouter()
router.register(r'settings', SiteSettingsViewSet, basename='sitesettings')
router.register(r'testimonials', TestimonialViewSet, basename='testimonial')

urlpatterns = [
    path('', include(router.urls)),
    path('all-settings/', get_all_settings, name='all-settings'),
]
