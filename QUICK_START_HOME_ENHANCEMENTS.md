# Quick Start Guide - Home Page Enhancements

## ✅ What's Been Done

### Backend (Django)
1. ✓ Created `NewsUpdate` model for admin-editable news (Tournament Results, Training Tips, Announcements)
2. ✓ Created `HomeGalleryImage` model for admin-managed gallery carousel
3. ✓ Added admin interfaces for easy content management
4. ✓ Created API endpoints: `/api/core/news-updates/` and `/api/core/home-gallery/`
5. ✓ Updated homepage API to include new content
6. ✓ Applied database migrations

### Frontend (Flutter)
1. ✓ Added `NewsUpdate` and `HomeGalleryImage` models
2. ✓ Created beautiful animated carousels:
   - `NewsCarousel` - Auto-playing news carousel with navigation
   - `GalleryCarousel` - 3D effect gallery carousel
3. ✓ Updated home screen with dynamic carousels
4. ✓ Made "Contact Us" button navigate to contact page
5. ✓ Made "Learn More" button navigate to about page
6. ✓ Removed static content, replaced with API-driven content

## 🚀 Next Steps to Test

### 1. Start Backend Server
```bash
cd /home/darkhacker/Desktop/Projects/pmadol/pmadol/backend/backend
python manage.py runserver
```

### 2. Add Sample Content (Django Admin)

**Access Admin Panel:**
- URL: `http://localhost:8000/admin`
- Create a superuser if needed:
  ```bash
  python manage.py createsuperuser
  ```

**Add News & Updates:**
1. Go to `Core → News & Updates`
2. Click "Add News & Update"
3. Create 3-5 news items with:
   - Title: "Regional Tournament Victory", "New Training Tips", "Academy Announcement"
   - Content: Add descriptive text
   - Type: Mix of Tournament Results, Training Tips, Announcements
   - ✓ Check "Is Featured" (to show in carousel)
   - ✓ Check "Is Active"
   - Optionally upload images

**Add Gallery Images:**
1. Go to `Core → Home Gallery Images`
2. Click "Add Home Gallery Image"
3. Create 5-8 gallery items with:
   - Title: "Training Session", "Tournament Day", "Chess Champions"
   - Upload images
   - Caption: Add descriptions
   - ✓ Check "Is Active"

### 3. Run Flutter App
```bash
cd /home/darkhacker/Desktop/Projects/pmadol/pmadol/frontend/frontend

# For web (if flutter web is configured)
flutter run -d chrome

# For Linux desktop
flutter run -d linux

# For connected device
flutter run
```

## 📋 Features to Test

### News Carousel
- [ ] Auto-plays every 5 seconds
- [ ] Left/Right arrows work
- [ ] Dot indicators update
- [ ] Images display correctly
- [ ] Category badges show correct type
- [ ] Text is readable over images

### Gallery Carousel  
- [ ] Auto-plays every 4 seconds
- [ ] 3D scaling effect works
- [ ] Images zoom smoothly
- [ ] Captions display at bottom
- [ ] Dot indicators update

### Navigation
- [ ] "Contact Us" button goes to contact page
- [ ] "Learn More" button goes to about page
- [ ] Navigation works from both home sections

### Dynamic Content
- [ ] If no news items exist, section is hidden
- [ ] If no gallery images exist, section is hidden
- [ ] Content updates when admin adds/removes items

## 📁 Modified Files Reference

### Backend Files
```
backend/backend/core/
├── models.py           # Added NewsUpdate & HomeGalleryImage
├── admin.py            # Added admin configurations
├── serializers.py      # Added new serializers
├── views.py            # Added new viewsets
└── urls.py             # Registered new routes
```

### Frontend Files
```
frontend/frontend/lib/
├── models/home_models.dart        # Added new model classes
├── widgets/carousel_widget.dart   # NEW FILE - Carousels
└── home_screen.dart               # Updated with carousels
```

## 🎨 Customization Options

### Carousel Timing
Edit in `lib/widgets/carousel_widget.dart`:
```dart
// News carousel - line ~32
Timer.periodic(const Duration(seconds: 5), (timer) {

// Gallery carousel - line ~265  
Timer.periodic(const Duration(seconds: 4), (timer) {
```

### Image Sizes
**Recommended:**
- News images: 1200x400px (3:1 ratio)
- Gallery images: 800x600px (4:3 ratio)

### Colors
Current theme colors in home_screen.dart:
- Primary: `#5886BF`
- Secondary: `#283D57`
- Gradient overlays for text readability

## 🐛 Troubleshooting

### "No data available" on home page
1. Check backend server is running
2. Verify API endpoint: `http://localhost:8000/api/core/homepage/`
3. Check browser console for errors
4. Ensure items are marked "Is Active" in admin

### Images not loading
1. Check `MEDIA_URL` in `backend/settings.py`
2. Verify image URLs in API response
3. Ensure uploaded images are in `backend/media/` folder

### Carousel not animating
1. Check Flutter console for errors
2. Verify data is loading from API
3. Try hot reload: Press 'r' in terminal

### Can't access admin
Create superuser:
```bash
cd backend/backend
python manage.py createsuperuser
```

## 📊 Sample Data Script (Optional)

You can create sample data via Django shell:

```bash
python manage.py shell
```

```python
from core.models import NewsUpdate, HomeGalleryImage

# Create news updates
NewsUpdate.objects.create(
    title="Regional Tournament Victory",
    content="Our students dominated the regional chess championship...",
    update_type="tournament",
    is_active=True,
    is_featured=True,
    display_order=1
)

NewsUpdate.objects.create(
    title="Opening Strategy Tips",
    content="Learn the Sicilian Defense with our expert coaches...",
    update_type="training",
    is_active=True,
    is_featured=True,
    display_order=2
)

# Create gallery images (you'll need to add actual image files)
HomeGalleryImage.objects.create(
    title="Training Session",
    caption="Students learning advanced tactics",
    is_active=True,
    display_order=1
)
```

## 🎯 Success Criteria

You'll know everything works when:
1. Home page loads without errors
2. News carousel auto-plays with your admin content
3. Gallery carousel shows uploaded images
4. Navigation buttons work correctly
5. Content updates when you add/edit in admin
6. Carousels hide gracefully when no content exists

## 📞 Need Help?

Check these resources:
1. `HOME_PAGE_ENHANCEMENTS.md` - Detailed technical documentation
2. Django admin at `http://localhost:8000/admin`
3. API documentation at `http://localhost:8000/api/core/`
4. Flutter logs in terminal for frontend issues

---

**Happy Testing! 🎉**
