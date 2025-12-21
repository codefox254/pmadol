# ============================================
# core/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r'site-settings', SiteSettingsViewSet, basename='site-settings')
router.register(r'statistics', StatisticsViewSet, basename='statistics')
router.register(r'testimonials', TestimonialViewSet, basename='testimonials')
router.register(r'partners', PartnerViewSet, basename='partners')
router.register(r'team-members', TeamMemberViewSet, basename='team-members')
router.register(r'faqs', FAQViewSet, basename='faqs')
router.register(r'about', AboutContentViewSet, basename='about')
router.register(r'core-values', CoreValueViewSet, basename='core-values')
router.register(r'homepage', HomePageViewSet, basename='homepage')

urlpatterns = router.urls
