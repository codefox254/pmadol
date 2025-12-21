# ============================================
# contact/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r'messages', ContactMessageViewSet, basename='messages')
router.register(r'consultations', ConsultationRequestViewSet, basename='consultations')
router.register(r'newsletter', NewsletterSubscriberViewSet, basename='newsletter')
router.register(r'info', ContactInfoViewSet, basename='info')

urlpatterns = router.urls


