# pmadol_backend/urls.py (Main URL configuration)
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('accounts.urls')),
    path('api/services/', include('services.urls')),
    path('api/shop/', include('shop.urls')),
    path('api/blog/', include('blog.urls')),
    path('api/gallery/', include('gallery.urls')),
    path('api/contact/', include('contact.urls')),
    path('api/core/', include('core.urls')),
    path('api/tournaments/', include('tournaments.urls')),
    path('api/auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


    