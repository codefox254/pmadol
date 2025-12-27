# Tournament Management Admin Guide

## Overview
The tournament system supports two types of tournaments:
1. **Lichess Tournaments** - External tournaments on Lichess (no registration needed, users just click to join)
2. **Internal Tournaments** - Tournaments requiring registration through the website

## Creating Tournaments

### Access Django Admin
1. Go to `http://localhost:8000/admin/`
2. Login with your superuser credentials
3. Navigate to **Tournaments** → **Tournaments**

### Tournament Types

#### 1. Lichess Tournament (Daily/Weekly)
For tournaments hosted on Lichess that users join directly:

**Required Fields:**
- **Title**: e.g., "Weekly Blitz Tournament"
- **Description**: Brief description of the tournament
- **Start Date**: When the tournament starts
- **Location**: "Lichess" or "Online"
- **Format**: Choose from dropdown (Blitz, Bullet, Rapid, etc.)
- **Time Control**: e.g., "3+2" or "5+0"
- **Lichess Link**: **IMPORTANT** - Paste the Lichess tournament URL here
- **Requires Registration**: **Set to False** ✗

**Optional Fields:**
- End Date: When tournament ends (if different from start)
- Venue Details: Additional info
- Entry Fee: Leave blank for free tournaments
- Max Participants: Leave blank for unlimited
- Image: Upload a tournament image

**Result:**
- Users will see a "Join on Lichess" button
- Clicking opens the Lichess tournament directly
- No registration form appears

#### 2. Internal Tournament (Requires Registration)
For tournaments where you want to track participants:

**Required Fields:**
- **Title**: e.g., "PMadol Chess Club Championship"
- **Description**: Tournament details
- **Start Date**: Tournament start time
- **Location**: Physical location or "Online"
- **Format**: Tournament format
- **Time Control**: Game time control
- **Requires Registration**: **Set to True** ✓

**Optional Fields:**
- Lichess Link: Can still provide if tournament will be on Lichess
- Entry Fee: Fee amount in KES
- Max Participants: Limit registrations
- Image: Tournament poster

**Result:**
- Users see "Register" button
- Registration form collects participant details
- You can view all registrants in admin panel
- Confirmation emails sent automatically

## Managing Registrations

### View Tournament Entrants
1. Go to **Tournament registrations** in admin
2. Filter by specific tournament
3. See all registered participants with:
   - Full name
   - Email
   - Phone number
   - Lichess username
   - Rating
   - Registration status

### Bulk Actions
Select multiple registrations and use actions:
- **Confirm registrations**: Mark participants as confirmed
- **Mark as attended**: Track who actually participated

### Export Entrants
You can see the list includes:
- Lichess username (for pairing)
- Contact info (for notifications)
- Rating (for seeding)

## WhatsApp Integration Workflow

### For Daily Lichess Tournaments:
1. Create tournament in admin with Lichess link
2. Tournament appears on website automatically
3. Share website link in WhatsApp group
4. Members visit site and click "Join on Lichess"

### For Weekly Tournaments:
1. Create as internal tournament (requires_registration = True)
2. Post registration link in WhatsApp
3. Members register through website
4. View all registrants in admin
5. Use data for pairings and organization

## Email Notifications

When someone registers for an internal tournament, they automatically receive:
- Confirmation email
- Tournament details (date, time, format)
- Contact info for questions

**Email Configuration:**
Check `backend/settings.py` for email settings (currently using console backend for development)

## API Endpoints (for reference)

- **List Tournaments**: `GET /api/tournaments/tournaments/`
  - Filter by status: `?status=upcoming` or `?status=past`
- **Tournament Details**: `GET /api/tournaments/tournaments/{id}/`
- **Register**: `POST /api/tournaments/registrations/`
- **List Registrations**: `GET /api/tournaments/registrations/`

## Quick Checklist

### Creating Lichess Tournament:
- [ ] Add title and description
- [ ] Set start date/time
- [ ] Add Lichess tournament link
- [ ] Set "Requires Registration" to **False**
- [ ] Set format and time control
- [ ] Save

### Creating Internal Tournament:
- [ ] Add title and description
- [ ] Set start date/time
- [ ] Set "Requires Registration" to **True**
- [ ] Set format and time control
- [ ] Set max participants (optional)
- [ ] Set entry fee (optional)
- [ ] Save

### After Tournament:
- [ ] Mark attendees in admin
- [ ] Add results link (optional)
- [ ] Tournament automatically moves to "Past" section

## Tips

1. **Test First**: Create a test tournament to see how it appears on the website
2. **Timing**: Set exact start times so users know when to join
3. **Descriptions**: Include any special rules or prizes in description
4. **Images**: Use clear, professional images for better engagement
5. **Lichess Links**: Copy full URL from Lichess (e.g., `https://lichess.org/tournament/abc123`)

## Common Issues

**Q: Users can't register**
- Check "Requires Registration" is set to True
- Verify max participants isn't reached
- Check tournament is still marked as active

**Q: Lichess link doesn't work**
- Ensure full URL is copied (including https://)
- Verify link is to a real Lichess tournament

**Q: Emails not sending**
- Check email configuration in settings.py
- For production, configure SMTP settings

## Support

For technical issues with the tournament system, contact your developer or check the Django admin logs.
