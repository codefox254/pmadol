# Pmadol Chess Academy - Backend

Professional chess coaching platform backend built with Django REST Framework.

## 🎯 Project Overview

A complete RESTful API backend for pmadol.com - a professional chess coaching website featuring:

- User authentication & authorization (JWT)
- Coach profile management
- Service packages (coaching offerings)
- E-commerce (products & orders)
- Blog & CMS
- Media gallery
- Contact form management
- Site settings & testimonials

## 🛠️ Tech Stack

- **Framework:** Django 5.0
- **API:** Django REST Framework 3.14
- **Database:** PostgreSQL 15+
- **Authentication:** JWT (djangorestframework-simplejwt)
- **Image Processing:** Pillow
- **CORS:** django-cors-headers
- **Static Files:** WhiteNoise

## 📋 Prerequisites

- Python 3.11+
- PostgreSQL 15+
- pip & virtualenv

## 🚀 Quick Start

### 1. Clone & Setup

```bash
# Navigate to backend directory
cd pmadol_backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Database Setup

```bash
# Create PostgreSQL database
createdb pmadol_db

# Or using psql:
psql -U postgres
CREATE DATABASE pmadol_db;
\q
```

### 3. Environment Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your settings
nano .env
```

Required environment variables:
```env
SECRET_KEY=your-secret-key
DEBUG=True
DB_NAME=pmadol_db
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

### 4. Run Migrations

```bash
# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Load initial data
python manage.py setup_initial_data
```

### 5. Start Development Server

```bash
python manage.py runserver
```

Server will be available at: `http://127.0.0.1:8000/`

## 🔑 Default Credentials

**Admin Panel:** `http://127.0.0.1:8000/admin/`

```
Email: admin@pmadol.com
Password: admin123
```

⚠️ **IMPORTANT:** Change the password immediately after first login!

## 📁 Project Structure

```
pmadol_backend/
├── apps/
│   ├── accounts/      # User authentication & coach profile
│   ├── services/      # Coaching service packages
│   ├── shop/          # Products, orders, e-commerce
│   ├── blog/          # Blog posts & CMS
│   ├── gallery/       # Media gallery
│   ├── contact/       # Contact form submissions
│   └── core/          # Site settings & testimonials
├── pmadol_backend/    # Project configuration
├── static/            # Static files
├── media/             # Uploaded files
└── requirements.txt
```

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/register/` - Register user
- `POST /api/auth/login/` - Login
- `POST /api/auth/logout/` - Logout
- `GET /api/auth/me/` - Get current user
- `GET /api/auth/coach/profile/` - Coach profile

### Services
- `GET /api/services/` - List services
- `GET /api/services/{slug}/` - Service detail

### Shop
- `GET /api/shop/products/` - List products
- `POST /api/shop/orders/` - Create order
- `GET /api/shop/orders/` - User orders

### Blog
- `GET /api/blog/posts/` - List posts
- `GET /api/blog/posts/{slug}/` - Post detail
- `POST /api/blog/posts/{slug}/increment_view/` - Track views

### Gallery
- `GET /api/gallery/` - List gallery items

### Contact
- `POST /api/contact/submissions/` - Submit form

### Core
- `GET /api/core/all-settings/` - Site settings
- `GET /api/core/testimonials/` - Testimonials

Full API documentation: See `BACKEND_QUICK_REFERENCE.md`

## 🧪 Testing

### Run Test Script

```bash
python test_api.py
```

### Manual Testing with cURL

```bash
# Login
curl -X POST http://127.0.0.1:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@pmadol.com","password":"admin123"}'

# Get coach profile
curl http://127.0.0.1:8000/api/auth/coach/profile/

# List services
curl http://127.0.0.1:8000/api/services/
```

### Import Postman Collection

Import `Pmadol_API_Collection.postman.json` for complete API testing.

## 📦 Key Features

### 1. User Management
- JWT authentication
- User registration & login
- Profile management
- Password change

### 2. Coach Profile
- Bio, credentials, rating
- Achievements
- Social media links
- Profile & cover images

### 3. Services
- Multiple service types (online/offline/hybrid)
- Pricing & duration
- Feature lists
- Display ordering

### 4. E-commerce
- Product catalog (courses, books, merchandise)
- Digital & physical products
- Order management
- Stock tracking

### 5. Blog & CMS
- Rich text content
- Categories & tags
- SEO optimization
- View tracking
- Featured posts

### 6. Gallery
- Images & videos
- Multiple categories
- Featured items

### 7. Contact Management
- Form submissions
- Admin notifications
- Read/unread tracking

### 8. Site Settings
- Configurable settings
- Testimonials
- Social media links

## 🔒 Security Features

- JWT token authentication
- Password hashing (bcrypt)
- CSRF protection
- SQL injection prevention (ORM)
- XSS protection
- Rate limiting support
- CORS configuration

## 📊 Database Schema

10 models across 7 apps:

1. **User** - Custom user model
2. **CoachProfile** - Coach information
3. **Service** - Coaching packages
4. **Product** - Shop items
5. **Order** - Customer orders
6. **OrderItem** - Order line items
7. **BlogPost** - Blog articles
8. **GalleryItem** - Media gallery
9. **ContactSubmission** - Contact forms
10. **SiteSettings** - Site configuration
11. **Testimonial** - Student reviews

## 🚢 Deployment

### Recommended Platforms

**Backend:**
- Railway.app (recommended)
- Render.com
- Heroku
- DigitalOcean

**Database:**
- Railway PostgreSQL
- ElephantSQL
- AWS RDS
- Supabase

**Media Storage:**
- Cloudinary (recommended)
- AWS S3
- DigitalOcean Spaces

### Environment Variables for Production

```env
DEBUG=False
ALLOWED_HOSTS=your-domain.com,www.your-domain.com
SECRET_KEY=generate-new-secret-key
DATABASE_URL=your-production-database-url
CORS_ALLOWED_ORIGINS=https://pmadol.com
```

### Deployment Checklist

- [ ] Set DEBUG=False
- [ ] Generate new SECRET_KEY
- [ ] Configure production database
- [ ] Set ALLOWED_HOSTS
- [ ] Configure CORS origins
- [ ] Set up media storage (Cloudinary/S3)
- [ ] Configure email backend
- [ ] Enable HTTPS
- [ ] Set up backups
- [ ] Configure logging

## 🐛 Troubleshooting

### Database Connection Error
```bash
# Check PostgreSQL is running
sudo service postgresql status

# Verify credentials in .env
```

### Migration Issues
```bash
# Reset migrations
python manage.py migrate appname zero
python manage.py migrate appname

# Or reset entire database
python manage.py flush
python manage.py migrate
python manage.py setup_initial_data
```

### Module Not Found
```bash
# Reinstall dependencies
pip install -r requirements.txt
```

## 📚 Documentation

- `BACKEND_SETUP_AND_TEST.md` - Detailed setup guide
- `BACKEND_QUICK_REFERENCE.md` - API endpoints reference
- `Pmadol_API_Collection.postman.json` - Postman collection

## 🤝 Development Workflow

1. Create feature branch
2. Make changes
3. Test locally
4. Run migrations
5. Test API endpoints
6. Commit & push
7. Create pull request

## 📝 Adding New Features

### Create New App

```bash
python manage.py startapp newapp
```

### Add to settings.py

```python
INSTALLED_APPS = [
    # ...
    'apps.newapp',
]
```

### Create Models → Migrations → Serializers → Views → URLs → Admin

## 🔧 Maintenance

### Database Backup

```bash
pg_dump pmadol_db > backup_$(date +%Y%m%d).sql
```

### Clear Cache

```bash
python manage.py clear_cache
```

### Update Dependencies

```bash
pip install --upgrade -r requirements.txt
pip freeze > requirements.txt
```

## 📈 Performance

- Database indexing on key fields
- Query optimization with select_related
- Pagination on list endpoints
- Static file compression (WhiteNoise)
- Image optimization

## 🎓 Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [DRF Documentation](https://www.django-rest-framework.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [JWT Authentication](https://django-rest-framework-simplejwt.readthedocs.io/)

## 📄 License

Proprietary - © 2025 Pmadol Chess Academy

## 👨‍💻 Support

For technical support:
- Check documentation files
- Review error logs
- Test with `test_api.py`
- Check admin panel for data

---

**Status:** ✅ Backend Complete & Tested

**Version:** 1.0.0

**Last Updated:** December 2025

## 🎯 Next Steps

1. ✅ Backend setup complete
2. ✅ Database configured
3. ✅ All models created
4. ✅ API endpoints implemented
5. ⏭️ **Ready for frontend development**

Run `python test_api.py` to verify everything works!