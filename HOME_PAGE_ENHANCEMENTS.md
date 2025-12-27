# Home Page Enhancements - Documentation

## Overview
Enhanced the PMadol Chess Club home page with admin-editable content, animated carousels for news/updates and gallery images, and functional navigation buttons.

## Backend Changes

### 1. New Models (core/models.py)

#### NewsUpdate Model
Admin can create and manage news, updates, and announcements with the following features:
- **Types**: Tournament Results, Training Tips, Announcements, Events, Achievements
- **Fields**:
  - `title`: Headline of the news/update
  - `content`: Detailed description
  - `update_type`: Category (tournament, training, announcement, event, achievement)
  - `image`: Optional image for visual appeal
  - `is_active`: Show/hide from frontend
  - `is_featured`: Display in carousel on home page
  - `display_order`: Control ordering
  - `published_date`: Auto-generated timestamp

#### HomeGalleryImage Model
Admin can manage gallery images for the home page carousel:
- **Fields**:
  - `title`: Image title
  - `image`: Image file
  - `caption`: Image description
  - `is_active`: Show/hide from frontend
  - `display_order`: Control ordering
  - `created_at`: Auto-generated timestamp

### 2. Admin Interface (core/admin.py)
Both models are fully integrated into Django admin with:
- List display with editable fields
- Filtering by status, type, and date
- Search functionality
- Easy management of display order

### 3. API Endpoints (core/views.py & core/urls.py)

#### New ViewSets:
- **NewsUpdateViewSet**: `/api/core/news-updates/`
  - List all news updates
  - `/featured/` - Get featured news for carousel
  - `/by_type/?type=tournament` - Filter by type

- **HomeGalleryImageViewSet**: `/api/core/home-gallery/`
  - List all gallery images
  
#### Updated Endpoints:
- **HomePageViewSet**: `/api/core/homepage/`
  - Now includes `news_updates` and `gallery_images` in response
  - Single endpoint for all home page data

### 4. Serializers (core/serializers.py)
- `NewsUpdateSerializer`: Includes type display name
- `HomeGalleryImageSerializer`: Complete image data
- `HomePageDataSerializer`: Updated to include new data

## Frontend Changes

### 1. Models (lib/models/home_models.dart)

#### Updated HomePageData
Now includes:
- `List<NewsUpdate> newsUpdates`
- `List<HomeGalleryImage> galleryImages`

#### New Model Classes:
- **NewsUpdate**: Represents news/updates with all fields
- **HomeGalleryImage**: Represents gallery images with metadata

### 2. Carousel Widgets (lib/widgets/carousel_widget.dart)

#### NewsCarousel
Beautiful animated carousel for displaying news and updates:
- **Features**:
  - Auto-play with 5-second intervals
  - Navigation arrows for manual control
  - Dot indicators showing current position
  - Gradient overlay for text readability
  - Category badges (Tournament Results, Training Tips, etc.)
  - Responsive design with image backgrounds

#### GalleryCarousel
Elegant carousel for displaying gallery images:
- **Features**:
  - Auto-play with 4-second intervals
  - 3D scaling effect (viewport fraction)
  - Smooth animations
  - Caption overlays with gradients
  - Dot indicators
  - Responsive image handling

### 3. Updated Home Screen (lib/home_screen.dart)

#### Functional Navigation:
- **"Learn More" button**: Now navigates to `/about` page
- **"Contact Us" button**: Now navigates to `/contact` page

#### Dynamic Content Sections:
- **News Section**: Replaced static cards with dynamic `NewsCarousel`
  - Loads admin-created news updates
  - Auto-hides if no content available
  
- **Gallery Section**: Replaced placeholder with dynamic `GalleryCarousel`
  - Loads admin-uploaded gallery images
  - Auto-hides if no content available

## How to Use (Admin Guide)

### Adding News & Updates

1. **Login to Django Admin**: `http://localhost:8000/admin`

2. **Navigate to Core → News & Updates**

3. **Click "Add News & Update"**

4. **Fill in the form**:
   - Title: Enter a catchy headline
   - Content: Add detailed description
   - Update Type: Choose from dropdown (Tournament Results, Training Tips, etc.)
   - Image: Upload an optional image (recommended size: 1200x400px)
   - Is Featured: ✓ Check to display in home page carousel
   - Is Active: ✓ Check to make it visible
   - Display Order: Lower numbers appear first

5. **Save** and view on home page

### Adding Gallery Images

1. **Login to Django Admin**: `http://localhost:8000/admin`

2. **Navigate to Core → Home Gallery Images**

3. **Click "Add Home Gallery Image"**

4. **Fill in the form**:
   - Title: Image title
   - Image: Upload image (recommended size: 800x600px or 4:3 ratio)
   - Caption: Add a description
   - Is Active: ✓ Check to make it visible
   - Display Order: Lower numbers appear first

5. **Save** and view on home page

### Managing Existing Content

- **Edit**: Click on any item to modify
- **Delete**: Select items and use bulk actions
- **Reorder**: Change the "Display Order" field
- **Hide/Show**: Toggle "Is Active" checkbox
- **Feature/Unfeature**: Toggle "Is Featured" for news items

## Testing

### Backend Testing
```bash
# Test API endpoints
curl http://localhost:8000/api/core/news-updates/
curl http://localhost:8000/api/core/home-gallery/
curl http://localhost:8000/api/core/homepage/
```

### Frontend Testing
1. Ensure backend server is running
2. Navigate to home page
3. Verify:
   - News carousel displays and auto-plays
   - Gallery carousel displays and auto-plays
   - "Contact Us" button navigates to contact page
   - "Learn More" button navigates to about page
   - Carousels are hidden if no content exists

## Technical Details

### API Response Structure
```json
{
  "site_settings": {...},
  "statistics": {...},
  "testimonials": [...],
  "partners": [...],
  "hero_slides": [...],
  "news_updates": [
    {
      "id": 1,
      "title": "Regional Tournament Victory",
      "content": "Our students won first place...",
      "update_type": "tournament",
      "update_type_display": "Tournament Results",
      "image": "http://localhost:8000/media/news/tournament.jpg",
      "is_active": true,
      "is_featured": true,
      "display_order": 0,
      "published_date": "2025-12-27T10:30:00Z"
    }
  ],
  "gallery_images": [
    {
      "id": 1,
      "title": "Training Session",
      "image": "http://localhost:8000/media/gallery/home/session.jpg",
      "caption": "Students learning advanced tactics",
      "is_active": true,
      "display_order": 0,
      "created_at": "2025-12-27T10:30:00Z"
    }
  ]
}
```

### Carousel Auto-play Timings
- **News Carousel**: 5 seconds per slide
- **Gallery Carousel**: 4 seconds per slide
- Both support manual navigation via arrows

### Responsive Design
- Desktop: Full-width carousels with padding
- Mobile: Adapts to screen size (handled by Flutter's responsive widgets)

## File Structure

### Backend
```
backend/backend/core/
├── models.py          # Added NewsUpdate & HomeGalleryImage
├── admin.py           # Added admin interfaces
├── serializers.py     # Added serializers
├── views.py           # Added viewsets
└── urls.py            # Registered new endpoints
```

### Frontend
```
frontend/frontend/lib/
├── models/
│   └── home_models.dart      # Added NewsUpdate & HomeGalleryImage models
├── widgets/
│   └── carousel_widget.dart  # NEW: NewsCarousel & GalleryCarousel
├── home_screen.dart          # Updated with carousels & functional buttons
└── contact_screen.dart       # Already exists and functional
```

## Next Steps (Optional Enhancements)

1. **Add Click Actions**: Make carousel items clickable to view full details
2. **Add Filters**: Filter news by type (show only tournaments, tips, etc.)
3. **Add Pagination**: For large numbers of news items
4. **Add Video Support**: Include video in gallery carousel
5. **Add Social Sharing**: Share news updates on social media
6. **Add Search**: Search functionality for news and updates

## Troubleshooting

### News/Gallery Not Showing
- ✓ Check if items are marked as "Active" in admin
- ✓ Verify backend server is running
- ✓ Check API endpoint returns data
- ✓ Clear Flutter cache: `flutter clean && flutter pub get`

### Images Not Loading
- ✓ Verify `MEDIA_URL` and `MEDIA_ROOT` in settings.py
- ✓ Check image URLs in API response
- ✓ Ensure media files are accessible
- ✓ Check CORS settings if frontend is on different domain

### Carousel Not Auto-playing
- ✓ Check console for errors
- ✓ Verify Timer is initialized in initState
- ✓ Ensure dispose() is called to prevent memory leaks

## Support

For questions or issues:
1. Check Django admin logs
2. Review browser console for frontend errors
3. Test API endpoints directly
4. Verify migrations are applied: `python manage.py migrate`
