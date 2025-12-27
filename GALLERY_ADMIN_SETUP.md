# Gallery Setup & Admin Guide

## Quick Setup for Admin

### Step 1: Create Default Gallery Categories

Go to Django admin panel at `http://localhost:8000/admin/` and create these 4 categories:

#### Category 1: Tournaments
- **Name**: Tournaments
- **Type**: photo (or mixed - choose based on your needs)
- **Slug**: tournaments
- **Active**: ✓ Checked

#### Category 2: Training Sessions
- **Name**: Training Sessions
- **Type**: video (or mixed)
- **Slug**: training-sessions
- **Active**: ✓ Checked

#### Category 3: Members
- **Name**: Members
- **Type**: photo
- **Slug**: members
- **Active**: ✓ Checked

#### Category 4: Events
- **Name**: Events
- **Type**: photo or video
- **Slug**: events
- **Active**: ✓ Checked

### Step 2: Add Gallery Items (Photos & Videos)

Once categories are created:

1. **Go to Gallery > Photos** to add tournament and member photos
2. **Go to Gallery > Videos** to add training and event videos

### Example Photo Upload:
```
Title: "Chess Tournament 2024"
Image: [Upload file]
Caption: "Final round of the tournament"
Category: Tournaments
Display Order: 1
Date Taken: 2024-01-15
Active: ✓
```

### Example Video Upload:
```
Title: "Opening Strategy Training"
Video URL: https://www.youtube.com/watch?v=...
Thumbnail: [Upload or auto-fetch from YouTube]
Description: "Learn basic opening strategies"
Category: Training Sessions
Display Order: 1
Active: ✓
```

## Frontend Access

Once items are created, they will automatically appear in the Gallery screen:

1. Navigate to `/gallery` route or click Gallery in main menu
2. View "All" content or click specific category
3. Click photos for full-screen view
4. Click videos to open in external player

## API Endpoints Used

The frontend automatically fetches from these endpoints:

```
GET /api/gallery/categories/
  Returns: List of all categories

GET /api/gallery/photos/
  Returns: List of all photos

GET /api/gallery/photos/by_category/?category=<slug>
  Returns: Photos filtered by category slug

GET /api/gallery/videos/
  Returns: List of all videos

GET /api/gallery/videos/by_category/?category=<slug>
  Returns: Videos filtered by category slug
```

## Important Notes

1. **Images must be uploaded**: Photos won't display without image files
2. **Videos can be external links**: Use YouTube URLs or direct MP4 links
3. **Slugs are important**: Used for filtering, should be lowercase with hyphens
4. **Display Order**: Lower numbers appear first
5. **Active flag**: Only active items show in frontend

## Customizing Categories

You can create additional categories at any time:

1. Go to Django admin → Gallery → Categories
2. Click "Add Category"
3. Fill details and save
4. Items will appear in gallery with category filter

## Managing Content

### Reordering Items
In Django admin, set the `display_order` field for each photo/video. Lower numbers appear first.

### Hiding Items
Uncheck the "Active" checkbox to temporarily hide items without deleting them.

### Updating Items
Simply edit the item in Django admin - changes appear immediately on frontend.

### Deleting Items
Click the item and scroll to bottom of form to delete. Images are not automatically deleted from storage.

## Troubleshooting

### Photos not showing
- ✓ Check category is marked "Active"
- ✓ Verify image file is uploaded
- ✓ Ensure photo is marked "Active"
- ✓ Check display_order is set

### Videos not playing
- ✓ Verify video URL is valid
- ✓ Check it's a YouTube URL or direct link
- ✓ Verify video is marked "Active"

### Category not appearing
- ✓ Ensure category is marked "Active"
- ✓ Verify at least one photo/video exists in category
- ✓ Check category type (photo/video) matches content

## Frontend Navigation

Gallery can be accessed via:
- **Route**: `/gallery`
- **Navigation Menu**: Look for "Gallery" link in main menu
- **Direct URL**: `http://localhost:PORT/#/gallery`

## Display Rules

- **Photos show in**: Photo Gallery grid
- **Videos show in**: Video Gallery grid
- **Filtering**: Category selection shows only that category's type content
- **"All" view**: Shows both photos and videos if available
