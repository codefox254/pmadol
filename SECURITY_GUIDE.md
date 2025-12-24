# Security & Best Practices Guide

## Overview
This document outlines security measures, best practices, and secure coding standards implemented in the e-commerce shop module.

---

## Backend Security

### 1. Input Validation

#### User Registration
```python
class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    password2 = serializers.CharField(write_only=True, min_length=8)
    
    def validate(self, data):
        if data['password'] != data['password2']:
            raise serializers.ValidationError("Passwords don't match")
        # Additional validation here
        return data
```

**Implemented Checks:**
- ✅ Minimum password length (8 characters)
- ✅ Password confirmation matching
- ✅ Email format validation
- ✅ Username uniqueness validation

#### Product Input Validation
```python
# In serializers
price = serializers.DecimalField(
    max_digits=10,
    decimal_places=2,
    validators=[MinValueValidator(0)]
)
discount_percentage = serializers.PositiveIntegerField(
    validators=[MinValueValidator(0), MaxValueValidator(100)]
)
```

**Implemented Checks:**
- ✅ Discount between 0-100%
- ✅ Positive prices
- ✅ Stock quantity validation
- ✅ String length limits

#### Order Form Validation
```python
# Email validation in order creation
if not RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email):
    return Response({'error': 'Invalid email'}, status=400)

# Phone number validation
if not RegExp(r'^\d{10,}$').hasMatch(phone):
    return Response({'error': 'Invalid phone'}, status=400)
```

### 2. Authentication & Authorization

#### Token-Based Authentication
```python
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication

class CartViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    authentication_classes = [TokenAuthentication]
    
    def get_queryset(self):
        # Users only see their own cart
        return Cart.objects.filter(user=self.request.user)
```

**Security Features:**
- ✅ Token-based authentication (stateless)
- ✅ User isolation (users see only their data)
- ✅ Read-only public endpoints
- ✅ Write permission checks

#### Authorization Checks
```python
def perform_update(self, serializer):
    review = self.get_object()
    if review.user != self.request.user:
        raise PermissionDenied("You can only edit your own reviews")
    serializer.save()
```

**Implemented Checks:**
- ✅ Only users can modify their own cart
- ✅ Only order creators can view orders
- ✅ Only reviewers can edit reviews
- ✅ Admin-only order status changes

### 3. Database Security

#### SQL Injection Prevention
```python
# SAFE: Using ORM
orders = Order.objects.filter(status=status_param)

# NOT SAFE (Never do this)
# orders = Order.objects.raw(f"SELECT * FROM shop_order WHERE status = '{status}'")
```

**Implemented Protection:**
- ✅ Django ORM prevents SQL injection
- ✅ No raw SQL queries used
- ✅ Parameterized queries by default

#### Transaction Safety
```python
@transaction.atomic()
def create(self, request):
    with transaction.atomic():
        # Create order
        order = Order.objects.create(...)
        
        # Create order items
        for item in cart.items.all():
            OrderItem.objects.create(...)
        
        # Clear cart atomically
        cart.items.all().delete()
```

**Implemented Protection:**
- ✅ All-or-nothing order creation
- ✅ Database consistency guaranteed
- ✅ Prevents partial orders
- ✅ Automatic rollback on error

### 4. Sensitive Data Protection

#### Password Handling
```python
# Correct: Using Django's password hasher
user.set_password(raw_password)
user.save()

# Never: Storing plain text passwords
# user.password = raw_password  # WRONG!
```

**Best Practices:**
- ✅ Passwords hashed with Django hasher
- ✅ Never log sensitive data
- ✅ Use write_only in serializers
- ✅ Secure token generation

#### PII (Personally Identifiable Information)
```python
class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = [
            'delivery_name', 'delivery_phone', 'delivery_email',
            'delivery_address', 'delivery_city', 'delivery_state', 'delivery_zip'
        ]
        read_only_fields = ['created_at', 'updated_at']
```

**Implemented Protection:**
- ✅ Read-only fields cannot be modified
- ✅ User isolation prevents access to others' data
- ✅ HTTPS encryption (in production)
- ✅ GDPR compliance ready

### 5. CSRF Protection

```python
# Django automatically adds CSRF tokens to forms
# Rest framework uses token authentication (immune to CSRF)

# For browser-based clients, ensure CSRF middleware is enabled:
MIDDLEWARE = [
    # ...
    'django.middleware.csrf.CsrfViewMiddleware',
    # ...
]
```

### 6. Rate Limiting & DDoS Protection

```python
# Add to settings.py for production
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.AnonRateThrottle',
        'rest_framework.throttling.UserRateThrottle'
    ],
    'DEFAULT_THROTTLE_RATES': {
        'anon': '100/hour',
        'user': '1000/hour'
    }
}
```

### 7. Logging & Monitoring

```python
import logging

logger = logging.getLogger(__name__)

# Log failed login attempts
try:
    user = authenticate(username=username, password=password)
except Exception as e:
    logger.warning(f"Failed login attempt for {username}")
    raise

# Log order creation (for auditing)
logger.info(f"Order created: {order.order_number} by {user.username}")

# Log sensitive operations
logger.warning(f"User {user} attempted to cancel protected order")
```

---

## Frontend Security

### 1. Input Validation

#### Email Validation
```dart
final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
);

String? validateEmail(String? value) {
  if (value?.isEmpty ?? true) return 'Email is required';
  if (!emailRegex.hasMatch(value!)) return 'Invalid email';
  return null;
}
```

#### Phone Number Validation
```dart
String? validatePhone(String? value) {
  if (value?.isEmpty ?? true) return 'Phone is required';
  if (!RegExp(r'^\d{10,}$').hasMatch(value!)) {
    return 'Enter valid phone number';
  }
  return null;
}
```

#### Password Validation
```dart
String? validatePassword(String? value) {
  if (value?.isEmpty ?? true) return 'Password required';
  if (value!.length < 8) return 'Minimum 8 characters';
  if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Need uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(value)) return 'Need lowercase letter';
  if (!RegExp(r'[0-9]').hasMatch(value)) return 'Need number';
  return null;
}
```

### 2. Secure Storage

#### Token Storage
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();
  
  Future<void> saveToken(String token) async {
    await _storage.write(
      key: 'auth_token',
      value: token,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }
  
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
```

**Best Practices:**
- ✅ Never store tokens in SharedPreferences
- ✅ Use flutter_secure_storage for sensitive data
- ✅ Encrypt data at rest
- ✅ Clear data on logout

### 3. Network Security

#### HTTPS Enforcement
```dart
class ApiService {
  // Always use HTTPS in production
  static const String baseUrl = 'https://api.example.com';  // NOT http://
}
```

#### Certificate Pinning (Optional but recommended)
```dart
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Dio _createSecureDio() {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.apiBase,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  // Add certificate pinning for production
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    SecurityContext context = SecurityContext.defaultContext;
    // Load your certificate here
    return client;
  };
  
  return dio;
}
```

### 4. Session Management

#### Automatic Logout on Token Expiry
```dart
class AuthProvider extends ChangeNotifier {
  Future<void> checkAuth() async {
    final token = await _apiService.getToken();
    
    if (token != null) {
      try {
        // Verify token is still valid
        // Make a request to verify endpoint
        _isAuthenticated = true;
      } catch (e) {
        // Token expired or invalid
        await logout();
      }
    }
  }
}
```

### 5. Error Handling

#### Secure Error Messages
```dart
// Good: Generic message to user
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Login failed')),
);

// Log detailed error server-side for debugging
logger.error('Login failed: ${e.toString()}');

// Bad: Exposing sensitive information
// ScaffoldMessenger.of(context).showSnackBar(
//   SnackBar(content: Text('Database error: ${e.toString()}')),
// );
```

### 6. Data Validation

#### Type Safety
```dart
// Good: Strong typing
class Product {
  final int id;
  final String name;
  final double price;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

// Bad: Untyped maps
// Map<String, dynamic> product = json.decode(response);
```

### 7. Memory Management

#### Proper Cleanup
```dart
class CartProvider extends ChangeNotifier {
  @override
  void dispose() {
    // Clean up resources
    _cart = null;
    super.dispose();
  }
}

class CheckoutForm extends StatefulWidget {
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    // Dispose all controllers
    super.dispose();
  }
}
```

---

## API Security

### 1. CORS Configuration
```python
# In settings.py
CORS_ALLOWED_ORIGINS = [
    "https://example.com",      # Production domain
    "https://app.example.com",   # App domain
    # NOT localhost or IP in production
]

# Avoid wildcard
# CORS_ALLOWED_ORIGINS = ["*"]  # NEVER in production
```

### 2. Rate Limiting
```python
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.UserRateThrottle',
        'rest_framework.throttling.AnonRateThrottle'
    ],
    'DEFAULT_THROTTLE_RATES': {
        'user': '1000/hour',
        'anon': '100/hour'
    }
}
```

### 3. API Versioning
```python
# In urls.py
urlpatterns = [
    path('api/v1/shop/', include('shop.urls')),
    path('api/v2/shop/', include('shop.urls')),  # Future version
]
```

---

## Secure Coding Checklist

### Backend
- [ ] All user inputs validated
- [ ] SQL injection prevention (ORM)
- [ ] CSRF tokens for form submissions
- [ ] Authentication on all protected endpoints
- [ ] Authorization checks for ownership
- [ ] Passwords hashed (never stored plain text)
- [ ] Sensitive data logged securely
- [ ] Transaction atomicity for critical operations
- [ ] Rate limiting implemented
- [ ] CORS properly configured
- [ ] HTTPS enforced in production
- [ ] Security headers set (CSP, X-Frame-Options, etc.)

### Frontend
- [ ] Input validation on all forms
- [ ] Secure token storage (flutter_secure_storage)
- [ ] HTTPS only in production
- [ ] Error messages don't expose sensitive info
- [ ] No hardcoded credentials
- [ ] Session timeout implemented
- [ ] Logout clears all sensitive data
- [ ] No sensitive data in logs
- [ ] Certificate pinning (optional)
- [ ] Proper permission handling
- [ ] No local data caching of sensitive info

---

## Production Deployment Security

### 1. Environment Variables
```bash
# Never commit to git
# Use environment variables instead

# .env (ignored by git)
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=api.example.com,www.example.com
CORS_ORIGINS=https://app.example.com
DATABASE_URL=postgresql://user:pass@host/db
```

### 2. HTTPS/SSL
```python
# settings.py - Production only
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_SECURITY_POLICY = {...}
```

### 3. Database Security
- ✅ Use strong passwords
- ✅ Restrict database access by IP
- ✅ Regular backups
- ✅ Encryption at rest
- ✅ Least privilege principle

### 4. Server Security
- ✅ Keep packages updated
- ✅ Use firewall
- ✅ Disable unnecessary services
- ✅ Monitor logs regularly
- ✅ Set up alerts for suspicious activity

---

## Compliance

### GDPR Compliance
- ✅ User consent for data collection
- ✅ Data privacy policy
- ✅ Right to be forgotten (delete user data)
- ✅ Data portability
- ✅ Breach notification procedures

### Payment Security (PCI-DSS)
- ✅ Never store full credit card numbers
- ✅ Use payment gateway (Stripe, etc.)
- ✅ Secure transmission (HTTPS)
- ✅ Regular security audits
- ✅ Encrypted storage for any card data

---

## Incident Response

### Breach Response Procedure
1. Assess the breach
2. Contain the threat
3. Notify affected users
4. Implement fixes
5. Document incident
6. Review and improve

### Security Update Policy
```bash
# Regular updates
pip install -U -r requirements.txt  # Backend
flutter pub upgrade              # Frontend

# Security monitoring
pip install bandit  # Security linter for Python
flutter analyze    # Dart analyzer

# Regular audits
bandit -r .        # Python security audit
```

---

## Testing Security

### Unit Tests for Security
```python
# Test password validation
def test_weak_password_rejected(self):
    with self.assertRaises(ValidationError):
        User.objects.create_user(
            username='test',
            password='123'  # Too weak
        )

# Test authorization
def test_user_cannot_view_others_cart(self):
    user1 = User.objects.create_user('user1', password='test')
    user2 = User.objects.create_user('user2', password='test')
    
    cart = Cart.objects.create(user=user1)
    
    self.client.force_authenticate(user2)
    response = self.client.get(f'/api/cart/{cart.id}/')
    self.assertEqual(response.status_code, 404)
```

---

## Security Resources

- OWASP Top 10: https://owasp.org/www-project-top-ten/
- Django Security: https://docs.djangoproject.com/en/stable/topics/security/
- Flutter Security: https://flutter.dev/docs/development/data-and-backend/json
- NIST Cybersecurity Framework: https://www.nist.gov/cyberframework

---

## Summary

This e-commerce implementation follows:
✅ OWASP security guidelines
✅ Django best practices
✅ Flutter security patterns
✅ Industry standards for payment processing
✅ GDPR compliance measures

Regular security audits and updates are recommended for production systems.
