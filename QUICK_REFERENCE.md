# Quick Reference Guide

## Files Modified

### Backend
- ✏️ `backend/backend/shop/models.py` - Enhanced with discounts, status history, verified reviews
- ✏️ `backend/backend/shop/serializers.py` - Added fields for discounts, status history, ratings
- ✏️ `backend/backend/shop/views.py` - Added security, validation, transaction safety, order tracking

### Frontend
- ✏️ `frontend/frontend/lib/models/shop_models.dart` - Complete model classes for all entities
- ✏️ `frontend/frontend/lib/providers/auth_provider.dart` - Enhanced with registration, validation
- ✨ `frontend/frontend/lib/providers/cart_provider.dart` - NEW - Cart management
- ✨ `frontend/frontend/lib/providers/order_provider.dart` - NEW - Order creation & tracking
- ✏️ `frontend/frontend/lib/providers/shop_provider.dart` - Enhanced search, filter, sort
- ✨ `frontend/frontend/lib/widgets/product_card.dart` - NEW - Professional product display
- ✨ `frontend/frontend/lib/widgets/checkout_form.dart` - NEW - Complete checkout form
- ✨ `frontend/frontend/lib/widgets/order_tracking.dart` - NEW - Order status tracking

### Documentation
- ✨ `ECOMMERCE_IMPLEMENTATION.md` - Complete technical documentation
- ✨ `SHOP_SETUP_GUIDE.md` - Step-by-step setup and implementation
- ✨ `SECURITY_GUIDE.md` - Security best practices and checklist
- ✨ `IMPLEMENTATION_SUMMARY.md` - Project overview and summary

---

## Key Classes & Models

### Backend Models
```python
Product
  - id, name, slug, description, short_description
  - price, discount_percentage, discounted_price, savings
  - stock, sku, image, gallery_images
  - category, is_featured, is_active
  - average_rating, review_count (properties)

Order
  - order_number, user, items
  - total_amount, discount_applied, final_amount
  - status, payment_status, payment_method
  - delivery_name/phone/email/address/city/state/zip
  - estimated_delivery, status_history
  - can_be_cancelled() method

OrderStatusHistory
  - order, status, timestamp, note

ProductReview
  - product, user, rating, title, comment
  - is_verified_purchase, helpful_count
```

### Frontend Models
```dart
Product
Cart, CartItem
Order, OrderItem
OrderStatusHistory
ProductReview
ProductCategory
User (in AuthProvider)
```

### Backend Viewsets
```python
ProductViewSet - featured(), by_category(), search(), reviews()
CartViewSet - retrieve_cart(), add_item(), update_item(), remove_item(), clear()
OrderViewSet - create(), track(), cancel()
ProductReviewViewSet - by_product(), mark_helpful()
ProductCategoryViewSet - list, retrieve
```

### Frontend Providers
```dart
AuthProvider - login(), register(), logout(), updateProfile()
ShopProvider - loadProducts(), searchProducts(), filterByCategory(), sortProducts()
CartProvider - loadCart(), addToCart(), updateCartItem(), removeFromCart(), clearCart()
OrderProvider - loadOrders(), createOrder(), trackOrder(), cancelOrder()
```

---

## Security Features Implemented

### Input Validation
- Email regex: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
- Phone: 10+ digits
- Password: 8+ characters
- Discount: 0-100%
- Price: Non-negative
- Stock: Positive integer

### Authorization
- User isolation (see only own data)
- Review ownership validation
- Order cancellation eligibility
- Permission classes on all endpoints
- Token-based authentication

### Data Protection
- Passwords hashed (Django)
- Write-only serializer fields
- SQL injection prevention (ORM)
- CSRF protection ready
- Transaction atomicity
- Secure token storage (Flutter)

---

## API Response Examples

### Create Order (200 OK)
```json
{
  "id": 1,
  "order_number": "ORD-20251223-ABC123",
  "user": 1,
  "items": [...],
  "total_amount": "5000.00",
  "discount_applied": "500.00",
  "final_amount": "4500.00",
  "status": "pending",
  "status_display": "Pending",
  "payment_status": "pending",
  "payment_status_display": "Pending",
  "payment_method": "cod",
  "payment_method_display": "Cash on Delivery",
  "delivery_name": "John Doe",
  "delivery_phone": "9876543210",
  "delivery_email": "john@example.com",
  "delivery_address": "123 Main St",
  "delivery_city": "City",
  "delivery_state": "State",
  "delivery_zip": "12345",
  "estimated_delivery": "2025-12-26T...",
  "status_history": [...],
  "created_at": "2025-12-23T...",
  "updated_at": "2025-12-23T..."
}
```

### Track Order (200 OK)
```json
{
  "order": {...},
  "status_history": [
    {
      "id": 1,
      "order": 1,
      "status": "pending",
      "status_display": "Pending",
      "timestamp": "2025-12-23T...",
      "note": "Order placed"
    }
  ],
  "current_status": "pending",
  "estimated_delivery": "2025-12-26T...",
  "payment_status": "pending"
}
```

---

## Error Responses

### Validation Error (400 Bad Request)
```json
{
  "delivery_name": ["Name is required"],
  "delivery_phone": ["Enter a valid phone number"]
}
```

### Authentication Error (401 Unauthorized)
```json
{
  "detail": "Invalid token"
}
```

### Permission Error (403 Forbidden)
```json
{
  "detail": "You do not have permission to perform this action."
}
```

### Not Found (404 Not Found)
```json
{
  "detail": "Not found."
}
```

---

## Provider Usage Examples

### Auth
```dart
// Login
final success = await context.read<AuthProvider>().login(username, password);

// Register
final success = await context.read<AuthProvider>().register(
  username: username,
  email: email,
  password: password,
  password2: password2,
  firstName: firstName,
  lastName: lastName,
);

// Check auth status
context.read<AuthProvider>().checkAuth();

// Logout
await context.read<AuthProvider>().logout();
```

### Shop
```dart
// Load products
context.read<ShopProvider>().loadProducts();

// Search
context.read<ShopProvider>().searchProducts('chess');

// Filter
context.read<ShopProvider>().filterByCategory('chess-sets');

// Sort
context.read<ShopProvider>().sortProducts('price_low');

// Get product details
context.read<ShopProvider>().loadProductDetails(productSlug);
```

### Cart
```dart
// Load cart
context.read<CartProvider>().loadCart();

// Add item
await context.read<CartProvider>().addToCart(productId, quantity: 2);

// Update quantity
await context.read<CartProvider>().updateCartItem(itemId, 3);

// Remove item
await context.read<CartProvider>().removeFromCart(itemId);

// Clear cart
await context.read<CartProvider>().clearCart();

// Get totals
final total = context.read<CartProvider>().totalAmount;
final discount = context.read<CartProvider>().totalDiscount;
```

### Order
```dart
// Create order
await context.read<OrderProvider>().createOrder(
  deliveryName: 'John Doe',
  deliveryPhone: '9876543210',
  deliveryEmail: 'john@example.com',
  deliveryAddress: '123 Main St',
  deliveryCity: 'City',
  deliveryState: 'State',
  deliveryZip: '12345',
  paymentMethod: 'cod',
);

// Load orders
context.read<OrderProvider>().loadOrders();

// Track order
context.read<OrderProvider>().trackOrder(orderId);

// Cancel order
await context.read<OrderProvider>().cancelOrder(orderId);
```

---

## Widget Usage

### ProductCard
```dart
ProductCard(
  product: product,
  onTap: () => Navigator.push(...),  // Navigate to details
  onAddToCart: () => print('Added!'),  // Callback after add
)
```

### CheckoutForm
```dart
CheckoutForm(
  cart: cart,
  onOrderCreated: () {
    // Navigate to confirmation
  },
)
```

### OrderTrackingWidget
```dart
OrderTrackingWidget(order: order)
```

---

## Common Development Tasks

### Add a new field to Product
1. Add field to `Product` model in `models.py`
2. Add field to `ProductSerializer`
3. Run migrations: `python manage.py makemigrations && migrate`
4. Update `ProductCard` widget to display it

### Add validation to a form
```dart
String? validateField(String? value) {
  if (value?.isEmpty ?? true) return 'Field required';
  if (value!.length < 3) return 'Too short';
  return null;
}

// In TextFormField
validator: validateField,
```

### Add new product status
1. Add to `STATUS_CHOICES` in Order model
2. Update `OrderStatusHistory`
3. Update views to handle new status
4. Update frontend OrderTrackingWidget

---

## Testing Commands

### Backend
```bash
cd backend/backend

# Migrations
python manage.py makemigrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run server
python manage.py runserver 0.0.0.0:8000

# Run tests
python manage.py test shop

# Django shell
python manage.py shell
```

### Frontend
```bash
cd frontend/frontend

# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk --release

# Tests
flutter test
```

---

## Troubleshooting

### Problem: "Module not found" in frontend
**Solution:** Run `flutter pub get`

### Problem: CORS error
**Solution:** Configure CORS in `settings.py`
```python
CORS_ALLOWED_ORIGINS = ["http://10.0.2.2:8000"]
```

### Problem: Images not loading
**Solution:** Ensure `MEDIA_URL` and `MEDIA_ROOT` configured, media serving enabled

### Problem: Token not working
**Solution:** Use secure token storage, verify token format

### Problem: Form validation not showing
**Solution:** Ensure `FormState` key is present, trigger validation before submit

---

## Performance Tips

### Backend
- Use `select_related()` for foreign keys
- Use `prefetch_related()` for reverse relations
- Add database indexes for common queries
- Cache product lists
- Paginate large result sets

### Frontend
- Cache API responses
- Use `const` widgets
- Implement lazy loading for lists
- Cancel pending requests on dispose
- Use `RepaintBoundary` for optimization

---

## Deployment Checklist

### Backend
- [ ] Set `DEBUG = False`
- [ ] Configure `ALLOWED_HOSTS`
- [ ] Set strong `SECRET_KEY`
- [ ] Enable `HTTPS` redirect
- [ ] Configure CORS properly
- [ ] Set up database backups
- [ ] Configure email backend
- [ ] Set up static files
- [ ] Configure logging
- [ ] Enable security headers

### Frontend
- [ ] Update API URLs to production
- [ ] Remove debug logging
- [ ] Test app thoroughly
- [ ] Build release APK/IPA
- [ ] Configure Firebase (if using)
- [ ] Set up crash reporting
- [ ] Test on real devices
- [ ] Submit to app stores

---

## Essential Links

- API Documentation: `http://localhost:8000/api/schema/` (DRF Spectacular)
- Django Admin: `http://localhost:8000/admin/`
- GitHub (if using): Your repository
- Documentation: `ECOMMERCE_IMPLEMENTATION.md`, `SHOP_SETUP_GUIDE.md`

---

## Support & Debugging

### Enable Debug Mode
```dart
// In api_service.dart
Dio(BaseOptions(
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
))..interceptors.add(
  LoggingInterceptor(),  // Add this
);
```

### Check Backend Logs
```bash
python manage.py runserver --verbosity 2
```

### Monitor Network Traffic
- Use Network tab in browser DevTools
- Use Flutter's Network profiling
- Use Charles/Fiddler for request inspection

---

**Last Updated: December 23, 2025**
**All components ready for implementation and deployment**
