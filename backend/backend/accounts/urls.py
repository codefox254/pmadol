# ============================================
# accounts/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import *

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='users')
router.register(r'students', StudentProfileViewSet, basename='students')
router.register(r'instructors', InstructorProfileViewSet, basename='instructors')

urlpatterns = [
    path('', include(router.urls)),
    path('auth/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]

