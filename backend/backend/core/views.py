# apps/core/views.py
from rest_framework import viewsets, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from apps.core.models import SiteSettings, Testimonial
from apps.core.serializers import SiteSettingsSerializer, TestimonialSerializer

class SiteSettingsViewSet(viewsets.ModelViewSet):
    """ViewSet for site settings"""
    queryset = SiteSettings.objects.all()
    serializer_class = SiteSettingsSerializer
    lookup_field = 'key'
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.AllowAny()]

@api_view(['GET'])
@permission_classes([permissions.AllowAny])
def get_all_settings(request):
    """Get all site settings as a single object"""
    settings = SiteSettings.objects.all()
    data = {setting.key: setting.value for setting in settings}
    return Response(data)

class TestimonialViewSet(viewsets.ModelViewSet):
    """ViewSet for testimonials"""
    queryset = Testimonial.objects.all()
    serializer_class = TestimonialSerializer
    ordering = ['display_order', '-created_at']
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.AllowAny()]
