# API Endpoints Reference

## Core App Endpoints

### Homepage Data (All-in-One)
```
GET /api/core/homepage/
```
**Description**: Returns all data needed for the home page in a single request

**Response**:
```json
{
  "site_settings": {
    "id": 1,
    "site_name": "PMadol Chess Club",
    "tagline": "Building and Nurturing Champions",
    "logo": "http://localhost:8000/media/site/logo.png",
    "primary_color": "#5886BF",
    "phone": "+254 714 272 082",
    "email": "info@pmadol.com",
    "address": "Nairobi - Kenya",
    "facebook_url": "https://facebook.com/pmadol",
    "instagram_url": "https://instagram.com/pmadol",
    "twitter_url": "https://twitter.com/pmadol"
  },
  "statistics": {
    "id": 1,
    "awards_count": 23,
    "years_experience": 9,
    "students_count": 771,
    "trainers_count": 12
  },
  "testimonials": [
    {
      "id": 1,
      "author": "Jane Doe",
      "role": "parent",
      "role_display": "Parent",
      "content": "Excellent coaching!",
      "rating": 5,
      "photo": "http://localhost:8000/media/testimonials/jane.jpg",
      "is_featured": true
    }
  ],
  "partners": [
    {
      "id": 1,
      "name": "Chess Federation",
      "logo": "http://localhost:8000/media/partners/logo.png",
      "website": "https://chessfederation.com"
    }
  ],
  "hero_slides": [
    {
      "id": 1,
      "title": "Welcome to PMadol",
      "subtitle": "Professional Chess Training",
      "image": "http://localhost:8000/media/hero/slide1.jpg",
      "is_active": true,
      "display_order": 0
    }
  ],
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

---

### News & Updates

#### List All News Updates
```
GET /api/core/news-updates/
```
**Description**: Get all active news updates

**Response**:
```json
[
  {
    "id": 1,
    "title": "Regional Tournament Victory",
    "content": "Our students dominated the regional chess championship...",
    "update_type": "tournament",
    "update_type_display": "Tournament Results",
    "image": "http://localhost:8000/media/news/tournament.jpg",
    "is_active": true,
    "is_featured": true,
    "display_order": 0,
    "published_date": "2025-12-27T10:30:00Z",
    "updated_at": "2025-12-27T10:35:00Z"
  },
  {
    "id": 2,
    "title": "Opening Strategy Tips",
    "content": "Learn the Sicilian Defense with our expert coaches...",
    "update_type": "training",
    "update_type_display": "Training Tips",
    "image": null,
    "is_active": true,
    "is_featured": true,
    "display_order": 1,
    "published_date": "2025-12-26T14:20:00Z",
    "updated_at": "2025-12-26T14:20:00Z"
  }
]
```

#### Get Featured News
```
GET /api/core/news-updates/featured/
```
**Description**: Get only featured news updates (for carousel)

**Response**: Same as above, but filtered to `is_featured=true`, limited to 5 items

#### Filter by Type
```
GET /api/core/news-updates/by_type/?type=tournament
GET /api/core/news-updates/by_type/?type=training
GET /api/core/news-updates/by_type/?type=announcement
GET /api/core/news-updates/by_type/?type=event
GET /api/core/news-updates/by_type/?type=achievement
```
**Description**: Filter news by type

**Response**: Filtered list of news updates

#### Get Single News Update
```
GET /api/core/news-updates/{id}/
```
**Description**: Get details of a specific news update

---

### Home Gallery

#### List All Gallery Images
```
GET /api/core/home-gallery/
```
**Description**: Get all active gallery images

**Response**:
```json
[
  {
    "id": 1,
    "title": "Training Session",
    "image": "http://localhost:8000/media/gallery/home/session.jpg",
    "caption": "Students learning advanced tactics",
    "is_active": true,
    "display_order": 0,
    "created_at": "2025-12-27T09:15:00Z"
  },
  {
    "id": 2,
    "title": "Tournament Day",
    "image": "http://localhost:8000/media/gallery/home/tournament.jpg",
    "caption": "Regional chess championship",
    "is_active": true,
    "display_order": 1,
    "created_at": "2025-12-26T11:30:00Z"
  }
]
```

#### Get Single Gallery Image
```
GET /api/core/home-gallery/{id}/
```
**Description**: Get details of a specific gallery image

---

### Other Core Endpoints (Already Existing)

#### Site Settings
```
GET /api/core/site-settings/
GET /api/core/site-settings/current/
```

#### Statistics
```
GET /api/core/statistics/
GET /api/core/statistics/current/
```

#### Testimonials
```
GET /api/core/testimonials/
GET /api/core/testimonials/featured/
```

#### Partners
```
GET /api/core/partners/
```

#### Team Members
```
GET /api/core/team-members/
GET /api/core/team-members/coaches/
```

#### FAQs
```
GET /api/core/faqs/
GET /api/core/faqs/by_category/?category=general
```

#### About Content
```
GET /api/core/about/
GET /api/core/about/current/
```

#### Core Values
```
GET /api/core/core-values/
```

---

## Testing Endpoints

### Using cURL

**Get all homepage data:**
```bash
curl http://localhost:8000/api/core/homepage/
```

**Get news updates:**
```bash
curl http://localhost:8000/api/core/news-updates/
```

**Get featured news:**
```bash
curl http://localhost:8000/api/core/news-updates/featured/
```

**Get gallery images:**
```bash
curl http://localhost:8000/api/core/home-gallery/
```

**Filter by type:**
```bash
curl http://localhost:8000/api/core/news-updates/by_type/?type=tournament
```

### Using Browser
Simply visit:
- http://localhost:8000/api/core/homepage/
- http://localhost:8000/api/core/news-updates/
- http://localhost:8000/api/core/home-gallery/

### Using Postman/Insomnia
1. Create GET request
2. URL: `http://localhost:8000/api/core/homepage/`
3. Send request
4. View JSON response

---

## API Response Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Request successful |
| 201 | Created | Resource created |
| 400 | Bad Request | Invalid request data |
| 404 | Not Found | Resource not found |
| 500 | Server Error | Internal server error |

---

## CORS Configuration

If frontend is on different domain, ensure CORS is configured in `settings.py`:

```python
INSTALLED_APPS = [
    ...
    'corsheaders',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    ...
]

CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
```

---

## Data Ordering

All endpoints return data in the following order:

**News Updates**:
1. Published date (newest first)
2. Display order (ascending)

**Gallery Images**:
1. Display order (ascending)
2. Created at (newest first)

**Partners, Testimonials, Team Members**:
1. Display order (ascending)
2. Name/Created date

---

## Pagination

Currently, endpoints return all items. To add pagination:

```python
# In views.py
from rest_framework.pagination import PageNumberPagination

class NewsUpdateViewSet(viewsets.ReadOnlyModelViewSet):
    pagination_class = PageNumberPagination
    page_size = 10
```

**Then access:**
```
GET /api/core/news-updates/?page=1
GET /api/core/news-updates/?page=2
```

---

## Authentication

Current endpoints are read-only and don't require authentication.

For admin operations (create/update/delete), authentication would be required:

```python
from rest_framework.permissions import IsAdminUser

class NewsUpdateViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAdminUser]
```

---

## Media Files

Ensure media files are served correctly:

**settings.py:**
```python
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
```

**urls.py:**
```python
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    ...
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

---

## Quick Reference

| Endpoint | Purpose | Featured Items |
|----------|---------|----------------|
| `/api/core/homepage/` | All home page data | Includes everything |
| `/api/core/news-updates/` | All news | All active items |
| `/api/core/news-updates/featured/` | Featured news | Max 5 items |
| `/api/core/home-gallery/` | Gallery images | Max 12 items |

**Note**: The `/homepage/` endpoint is optimized for single-request loading, while individual endpoints allow for more granular control.
