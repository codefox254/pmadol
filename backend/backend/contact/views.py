# apps/contact/views.py
from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django.core.mail import send_mail
from django.conf import settings
from apps.contact.models import ContactSubmission
from apps.contact.serializers import (
    ContactSubmissionSerializer,
    ContactSubmissionCreateSerializer
)

class ContactSubmissionViewSet(viewsets.ModelViewSet):
    """ViewSet for contact submissions"""
    queryset = ContactSubmission.objects.all()
    
    def get_serializer_class(self):
        if self.action == 'create':
            return ContactSubmissionCreateSerializer
        return ContactSubmissionSerializer
    
    def get_permissions(self):
        if self.action == 'create':
            return [permissions.AllowAny()]
        return [permissions.IsAdminUser()]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        submission = serializer.save()
        
        # Send email notification (optional)
        try:
            send_mail(
                subject=f"New Contact Submission: {submission.subject}",
                message=f"From: {submission.name} ({submission.email})\n\n{submission.message}",
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[settings.EMAIL_HOST_USER],
                fail_silently=True,
            )
        except Exception:
            pass  # Don't fail if email sending fails
        
        return Response(
            {
                'id': submission.id,
                'message': 'Thank you for contacting us! We will get back to you within 24 hours.'
            },
            status=status.HTTP_201_CREATED
        )
    
    @action(detail=True, methods=['patch'], permission_classes=[permissions.IsAdminUser])
    def mark_read(self, request, pk=None):
        """Mark submission as read"""
        submission = self.get_object()
        submission.is_read = True
        submission.save()
        return Response({'status': 'marked as read'})
