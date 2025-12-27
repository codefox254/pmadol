# ============================================
# tournaments/serializers.py
# ============================================
from rest_framework import serializers
from .models import Tournament, TournamentRegistration


class TournamentSerializer(serializers.ModelSerializer):
    registration_count = serializers.IntegerField(read_only=True)
    is_full = serializers.BooleanField(read_only=True)
    
    class Meta:
        model = Tournament
        fields = [
            'id', 'title', 'description', 'start_date', 'end_date',
            'location', 'venue_details', 'format', 'time_control',
            'entry_fee', 'max_participants', 'image', 'lichess_link',
            'results_link', 'is_active', 'requires_registration',
            'registration_count', 'is_full', 'created_at'
        ]


class TournamentRegistrationSerializer(serializers.ModelSerializer):
    tournament_title = serializers.CharField(source='tournament.title', read_only=True)
    
    class Meta:
        model = TournamentRegistration
        fields = [
            'id', 'tournament', 'tournament_title', 'full_name', 'email',
            'phone_number', 'lichess_username', 'rating', 'message',
            'is_confirmed', 'registered_at'
        ]
        read_only_fields = ['id', 'tournament_title', 'is_confirmed', 'registered_at']
    
    def validate(self, data):
        tournament = data.get('tournament')
        
        # Check if tournament is full
        if tournament.is_full:
            raise serializers.ValidationError("This tournament is full.")
        
        # Check if tournament requires registration
        if not tournament.requires_registration:
            raise serializers.ValidationError("This tournament does not require registration. Please use the Lichess link to join.")
        
        return data
