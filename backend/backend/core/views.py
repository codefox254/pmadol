
# ============================================
# core/views.py
# ============================================
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAdminUser
from .models import *
from .serializers import *


class SiteSettingsViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = SiteSettings.objects.all()
    serializer_class = SiteSettingsSerializer
    
    @action(detail=False, methods=['get'])
    def current(self, request):
        settings = SiteSettings.get_settings()
        serializer = self.get_serializer(settings)
        return Response(serializer.data)


class StatisticsViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Statistics.objects.all()
    serializer_class = StatisticsSerializer
    
    @action(detail=False, methods=['get'])
    def current(self, request):
        stats = Statistics.get_stats()
        serializer = self.get_serializer(stats)
        return Response(serializer.data)


class TestimonialViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Testimonial.objects.filter(is_active=True)
    serializer_class = TestimonialSerializer
    
    @action(detail=False, methods=['get'])
    def featured(self, request):
        testimonials = self.queryset.filter(is_featured=True)[:3]
        serializer = self.get_serializer(testimonials, many=True)
        return Response(serializer.data)


class PartnerViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Partner.objects.filter(is_active=True)
    serializer_class = PartnerSerializer


class TeamMemberViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = TeamMember.objects.filter(is_active=True)
    serializer_class = TeamMemberSerializer
    
    @action(detail=False, methods=['get'])
    def coaches(self, request):
        coaches = self.queryset.filter(role__in=['head_coach', 'coach', 'assistant_coach'])
        serializer = self.get_serializer(coaches, many=True)
        return Response(serializer.data)


class FAQViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = FAQ.objects.filter(is_active=True)
    serializer_class = FAQSerializer
    
    @action(detail=False, methods=['get'])
    def by_category(self, request):
        category = request.query_params.get('category', 'general')
        faqs = self.queryset.filter(category=category)
        serializer = self.get_serializer(faqs, many=True)
        return Response(serializer.data)


class AboutContentViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = AboutContent.objects.all()
    serializer_class = AboutContentSerializer
    
    @action(detail=False, methods=['get'])
    def current(self, request):
        content = AboutContent.get_content()
        serializer = self.get_serializer(content)
        return Response(serializer.data)


class CoreValueViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CoreValue.objects.filter(is_active=True)
    serializer_class = CoreValueSerializer


class HomePageViewSet(viewsets.ViewSet):
    """Combined endpoint for homepage - aggregates data from multiple models"""
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def list(self, request):
        """Get all homepage data in one request"""
        try:
            data = {
                'site_settings': SiteSettings.get_settings(),
                'statistics': Statistics.get_stats(),
                'testimonials': Testimonial.objects.filter(is_active=True, is_featured=True)[:3],
                'partners': Partner.objects.filter(is_active=True),
                'hero_slides': HeroSlide.objects.filter(is_active=True),
            }
            serializer = HomePageDataSerializer(data)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {'error': f'Failed to load homepage data: {str(e)}'}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )



