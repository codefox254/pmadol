
# ============================================
# services/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r'services', ServiceViewSet, basename='services')
router.register(r'pricing-plans', PricingPlanViewSet, basename='pricing-plans')
router.register(r'bookings', ServiceBookingViewSet, basename='bookings')
router.register(r'inquiries', ServiceInquiryViewSet, basename='inquiries')

urlpatterns = router.urls

