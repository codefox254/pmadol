# ============================================
# tournaments/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import TournamentViewSet, TournamentRegistrationViewSet

router = DefaultRouter()
router.register(r'tournaments', TournamentViewSet, basename='tournament')
router.register(r'registrations', TournamentRegistrationViewSet, basename='registration')

urlpatterns = [
    path('', include(router.urls)),
]
