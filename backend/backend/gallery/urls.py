
# ============================================
# gallery/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r'categories', GalleryCategoryViewSet, basename='categories')
router.register(r'photos', GalleryPhotoViewSet, basename='photos')
router.register(r'videos', GalleryVideoViewSet, basename='videos')

urlpatterns = router.urls
