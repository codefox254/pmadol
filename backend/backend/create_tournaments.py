#!/usr/bin/env python
import os
import django
from datetime import datetime, timedelta
import pytz

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from tournaments.models import Tournament

tz = pytz.timezone('UTC')

# Delete existing tournaments
Tournament.objects.all().delete()

# Create an upcoming tournament
upcoming = Tournament.objects.create(
    title="Weekly Blitz Championship",
    description="Join our fast-paced blitz tournament on Lichess. Open to players of all levels.",
    start_date=datetime.now(tz) + timedelta(days=7, hours=18),
    location="Lichess Online",
    format="Arena",
    time_control="3+2",
    lichess_link="https://lichess.org/tournament/abc123example",
    requires_registration=False,
    is_active=True,
)

# Create an ongoing tournament
ongoing = Tournament.objects.create(
    title="PMadol Club Championship",
    description="Monthly championship tournament for club members. Register to participate and compete for the title!",
    start_date=datetime.now(tz) - timedelta(hours=1),
    end_date=datetime.now(tz) + timedelta(days=1),
    location="PMadol Chess Club",
    format="Swiss",
    time_control="15+10",
    entry_fee=500.00,
    max_participants=32,
    requires_registration=True,
    is_active=True,
)

# Create a completed tournament
completed = Tournament.objects.create(
    title="Last Month Rapid Tournament",
    description="Completed tournament from last month.",
    start_date=datetime.now(tz) - timedelta(days=30),
    end_date=datetime.now(tz) - timedelta(days=29),
    location="Online",
    format="Round Robin",
    time_control="10+0",
    results_link="https://lichess.org/api/tournament/results?id=completed123",
    requires_registration=True,
    is_active=False,
)

print(f"✅ Created upcoming tournament: {upcoming.id} - {upcoming.title}")
print(f"✅ Created ongoing tournament: {ongoing.id} - {ongoing.title}")
print(f"✅ Created completed tournament: {completed.id} - {completed.title}")
print(f"\nTotal tournaments: {Tournament.objects.count()}")
