
# ============================================
# services/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r'services', ServiceViewSet, basename='services')
router.register(r'membership-plans', MembershipPlanViewSet, basename='membership-plans')
router.register(r'memberships', ClubMembershipViewSet, basename='memberships')
router.register(r'enrollments', ServiceEnrollmentViewSet, basename='enrollments')
router.register(r'team-members', TeamMemberViewSet, basename='team-members')

urlpatterns = router.urls
