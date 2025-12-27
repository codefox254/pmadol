# ============================================
# tournaments/views.py
# ============================================
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.core.mail import send_mail
from django.conf import settings
from .models import Tournament, TournamentRegistration
from .serializers import TournamentSerializer, TournamentRegistrationSerializer


class TournamentViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API endpoint for tournaments.
    Supports filtering by status (upcoming, ongoing, past).
    """
    queryset = Tournament.objects.filter(is_active=True)
    serializer_class = TournamentSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = super().get_queryset()
        status_filter = self.request.query_params.get('status', None)
        
        if status_filter == 'upcoming':
            from django.utils import timezone
            queryset = queryset.filter(start_date__gt=timezone.now())
        elif status_filter == 'past':
            from django.utils import timezone
            queryset = queryset.filter(start_date__lt=timezone.now())
        
        return queryset


class TournamentRegistrationViewSet(viewsets.ModelViewSet):
    """
    API endpoint for tournament registrations.
    Allows users to register for tournaments.
    """
    queryset = TournamentRegistration.objects.all()
    serializer_class = TournamentRegistrationSerializer
    permission_classes = [AllowAny]
    http_method_names = ['get', 'post']
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        
        # Send confirmation email
        try:
            registration = serializer.instance
            tournament_date = registration.tournament.start_date.strftime("%B %d, %Y at %I:%M %p")
            send_mail(
                subject=f'Tournament Registration Confirmation - {registration.tournament.title}',
                message=f'Dear {registration.full_name},\n\n'
                        f'Thank you for registering for {registration.tournament.title}.\n\n'
                        f'Tournament Details:\n'
                        f'Date: {tournament_date}\n'
                        f'Format: {registration.tournament.get_format_display()}\n'
                        f'Time Control: {registration.tournament.time_control}\n\n'
                        f'We will send you further details closer to the tournament date.\n\n'
                        f'Best regards,\n'
                        f'PMadol Chess Club',
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[registration.email],
                fail_silently=True,
            )
        except Exception as e:
            pass  # Don't fail registration if email fails
        
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
