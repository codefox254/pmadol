# ============================================
# shop/urls.py
# ============================================
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r'categories', ProductCategoryViewSet, basename='categories')
router.register(r'products', ProductViewSet, basename='products')
router.register(r'cart', CartViewSet, basename='cart')
router.register(r'orders', OrderViewSet, basename='orders')
router.register(r'reviews', ProductReviewViewSet, basename='reviews')

urlpatterns = router.urls
