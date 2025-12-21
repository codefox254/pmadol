
# ============================================
# contact/views.py
# ============================================
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from .models import ContactMessage, ConsultationRequest, NewsletterSubscriber, ContactInfo
from .serializers import *


class ContactMessageViewSet(viewsets.ModelViewSet):
    queryset = ContactMessage.objects.all()
    serializer_class = ContactMessageSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_permissions(self):
        if self.action == 'create':
            return [IsAuthenticatedOrReadOnly()]
        return [IsAuthenticated()]


class ConsultationRequestViewSet(viewsets.ModelViewSet):
    queryset = ConsultationRequest.objects.all()
    serializer_class = ConsultationRequestSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_permissions(self):
        if self.action == 'create':
            return [IsAuthenticatedOrReadOnly()]
        return [IsAuthenticated()]


class NewsletterSubscriberViewSet(viewsets.ModelViewSet):
    queryset = NewsletterSubscriber.objects.all()
    serializer_class = NewsletterSubscriberSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_permissions(self):
        if self.action == 'create':
            return [IsAuthenticatedOrReadOnly()]
        return [IsAuthenticated()]
    
    @action(detail=False, methods=['post'])
    def subscribe(self, request):
        email = request.data.get('email')
        if not email:
            return Response({'error': 'Email required'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        subscriber, created = NewsletterSubscriber.objects.get_or_create(
            email=email,
            defaults={'is_active': True}
        )
        
        if not created and not subscriber.is_active:
            subscriber.is_active = True
            subscriber.save()
        
        message = 'Subscribed successfully' if created else 'Already subscribed'
        return Response({'message': message})
    
    @action(detail=False, methods=['post'])
    def unsubscribe(self, request):
        email = request.data.get('email')
        try:
            subscriber = NewsletterSubscriber.objects.get(email=email)
            subscriber.is_active = False
            subscriber.save()
            return Response({'message': 'Unsubscribed successfully'})
        except NewsletterSubscriber.DoesNotExist:
            return Response({'error': 'Email not found'}, 
                          status=status.HTTP_404_NOT_FOUND)


class ContactInfoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = ContactInfo.objects.all()
    serializer_class = ContactInfoSerializer
    
    @action(detail=False, methods=['get'])
    def current(self, request):
        info = ContactInfo.get_info()
        serializer = self.get_serializer(info)
        return Response(serializer.data)



