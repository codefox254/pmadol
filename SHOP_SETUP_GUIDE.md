# E-Commerce Shop Implementation Guide

## Step-by-Step Setup Instructions

### Phase 1: Backend Setup

#### 1.1 Update Django Models
1. Open `backend/backend/shop/models.py`
2. The models have already been enhanced with:
   - Discount system
   - Enhanced order tracking
   - Multiple image support
   - Order status history
   - Verified purchase reviews

**Action Required:**
```bash
cd backend/backend
python manage.py makemigrations shop
python manage.py migrate shop
```

#### 1.2 Update Serializers
The serializers in `backend/backend/shop/serializers.py` have been updated to:
- Include discount pricing
- Add order status tracking
- Include verified purchase information
- Provide complete order details

**No action needed** - serializers are auto-discovered by Django.

#### 1.3 Update Views
The views in `backend/backend/shop/views.py` now include:
- Enhanced security with input validation
- Transaction-safe order creation
- Complete order tracking
- Product review system with verification

**No action needed** - views are auto-registered via router.

#### 1.4 Verify URLs
The `backend/backend/shop/urls.py` uses DefaultRouter which auto-registers:
```
/api/shop/products/
/api/shop/categories/
/api/shop/cart/
/api/shop/orders/
/api/shop/reviews/
```

---

### Phase 2: Frontend Setup

#### 2.1 Update Models
All enhanced models are in place:
- `lib/models/shop_models.dart` - Complete product/order models

#### 2.2 Create/Update Providers

**Files already created:**
1. `lib/providers/auth_provider.dart` - Enhanced with registration
2. `lib/providers/shop_provider.dart` - Search, filter, sorting
3. `lib/providers/cart_provider.dart` - Full cart management
4. `lib/providers/order_provider.dart` - Order creation and tracking

#### 2.3 Create/Update Widgets

**Files already created:**
1. `lib/widgets/product_card.dart` - Product display with add to cart
2. `lib/widgets/checkout_form.dart` - Complete checkout form
3. `lib/widgets/order_tracking.dart` - Order status tracking

#### 2.4 Update main.dart

Add providers to your MultiProvider in `lib/main.dart`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ShopProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    // ... other providers
  ],
  child: const MyApp(),
)
```

---

### Phase 3: Screen Implementation

Create these screens using the provided components:

#### 3.1 Authentication Screens

**Login Screen** (`lib/login_screen.dart`)
```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _usernameController.text,
      _passwordController.text,
    );
    
    if (success) {
      // Navigate to shop
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          // Implementation with login form
        );
      },
    );
  }
}
```

**Registration Screen** (`lib/register_screen.dart`)
```dart
class RegisterScreen extends StatefulWidget {
  // Similar to LoginScreen but uses authProvider.register()
}
```

#### 3.2 Shop Screens

**Updated Shop Screen** - Update `lib/shop_screen.dart`
Replace product loading with:
```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    context.read<ShopProvider>().loadProducts();
    context.read<ShopProvider>().loadCategories();
    context.read<ShopProvider>().loadFeaturedProducts();
  });
}

// Use ProductCard widget for displaying products
```

**Product Detail Screen** (`lib/product_detail_screen.dart`)
```dart
class ProductDetailScreen extends StatefulWidget {
  final String productSlug;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShopProvider>().loadProductDetails(widget.productSlug);
    // Load reviews after product loads
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, _) {
        final product = shopProvider.selectedProduct;
        if (product == null) return LoadingWidget();
        
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Product images gallery
                // Product details (name, description, price)
                // Rating and reviews
                // Add to cart button
              ],
            ),
          ),
        );
      },
    );
  }
}
```

**Cart Screen** (`lib/cart_screen.dart`)
```dart
class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        if (cartProvider.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Shopping Cart')),
            body: const Center(child: Text('Cart is empty')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Shopping Cart')),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: Text('Rs. ${item.discountedSubtotal}'),
                      // Add update/remove buttons
                    );
                  },
                ),
              ),
              // Summary section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text('Rs. ${cartProvider.totalAmount}'),
                      ],
                    ),
                    if (cartProvider.totalDiscount > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Discount:'),
                          Text('-Rs. ${cartProvider.totalDiscount}'),
                        ],
                      ),
                    ],
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:'),
                        Text('Rs. ${cartProvider.discountedAmount}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to checkout
                        },
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

**Checkout Screen** (`lib/checkout_screen.dart`)
```dart
class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final cart = cartProvider.cart;
        if (cart == null) return LoadingWidget();

        return Scaffold(
          appBar: AppBar(title: const Text('Checkout')),
          body: CheckoutForm(
            cart: cart,
            onOrderCreated: () {
              // Navigate to order confirmation
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OrderConfirmationScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
```

**Order Tracking Screen** (`lib/order_tracking_screen.dart`)
```dart
class OrderTrackingScreen extends StatefulWidget {
  final int orderId;

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderProvider>().trackOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        final order = orderProvider.selectedOrder;
        if (order == null) return LoadingWidget();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Track Order'),
            actions: [
              if (order.canBeCancelled)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _showCancelDialog(context, order.id);
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OrderTrackingWidget(order: order),
            ),
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              context.read<OrderProvider>().cancelOrder(orderId);
              Navigator.pop(context);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
```

**Orders List Screen** (`lib/orders_list_screen.dart`)
```dart
class OrdersListScreen extends StatefulWidget {
  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderProvider>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        if (orderProvider.orders.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No orders yet')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('My Orders')),
          body: ListView.builder(
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return ListTile(
                title: Text(order.orderNumber),
                subtitle: Text(order.statusDisplay),
                trailing: Text('Rs. ${order.finalAmount}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderTrackingScreen(orderId: order.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
```

---

### Phase 4: Testing & Deployment

#### 4.1 Backend Testing

```bash
# Run migrations
python manage.py migrate

# Test API endpoints
pytest backend/tests/

# Or use Django test
python manage.py test shop
```

#### 4.2 Frontend Testing

```bash
cd frontend/frontend

# Run tests
flutter test

# Build APK for testing
flutter build apk --release
```

#### 4.3 Test Scenarios

**User Flow:**
1. Register new account
2. Browse products
3. Search for specific items
4. View product details
5. Add items to cart
6. Update cart quantities
7. Proceed to checkout
8. Fill delivery information
9. Select payment method
10. Place order
11. Track order status
12. Leave product review

---

### Phase 5: Database & Admin Setup

#### 5.1 Add to Django Admin (`backend/backend/shop/admin.py`)

```python
from django.contrib import admin
from .models import *

@admin.register(ProductCategory)
class ProductCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active', 'created_at']
    search_fields = ['name']
    prepopulated_fields = {'slug': ('name',)}

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'price', 'stock', 'is_active']
    search_fields = ['name', 'sku']
    list_filter = ['category', 'is_active', 'is_featured']
    prepopulated_fields = {'slug': ('name',)}
    fieldsets = (
        ('Basic', {'fields': ('name', 'slug', 'description', 'short_description')}),
        ('Pricing', {'fields': ('price', 'discount_percentage')}),
        ('Inventory', {'fields': ('stock', 'sku')}),
        ('Images', {'fields': ('image', 'gallery_images')}),
        ('Status', {'fields': ('is_featured', 'is_active')}),
    )

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['order_number', 'user', 'status', 'payment_status', 'created_at']
    list_filter = ['status', 'payment_status', 'created_at']
    search_fields = ['order_number', 'user__username']
    readonly_fields = ['order_number', 'created_at', 'updated_at']

@admin.register(ProductReview)
class ProductReviewAdmin(admin.ModelAdmin):
    list_display = ['product', 'user', 'rating', 'is_verified_purchase']
    list_filter = ['rating', 'is_verified_purchase', 'created_at']
    search_fields = ['product__name', 'user__username']
    readonly_fields = ['created_at', 'updated_at']
```

---

### Phase 6: Environment Configuration

#### 6.1 Backend Settings (`backend/backend/backend/settings.py`)

Ensure these are configured:

```python
# CORS for Flutter app
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8080",  # For local testing
    "http://YOUR_IP:PORT",    # For Flutter app
]

# Media files
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# DRF Pagination
REST_FRAMEWORK = {
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 12,
    'DEFAULT_FILTER_BACKENDS': [
        'rest_framework.filters.SearchFilter',
        'rest_framework.filters.OrderingFilter',
    ],
}
```

#### 6.2 API Configuration (`lib/config/api_config.dart`)

```dart
class ApiConfig {
  // Change to your backend URL
  static const String baseUrl = 'http://YOUR_BACKEND_URL:8000';
  static const String apiBase = '$baseUrl/api';
  
  static const String shopBase = '$apiBase/shop';
  static const String accountsBase = '$apiBase/accounts';
}
```

---

### Phase 7: Data Population

#### 7.1 Add Sample Data

Use Django shell or admin panel:

```bash
python manage.py shell
```

```python
from shop.models import ProductCategory, Product

# Create categories
category = ProductCategory.objects.create(
    name="Chess Sets",
    slug="chess-sets",
    description="Premium chess sets"
)

# Create products
Product.objects.create(
    name="Professional Chess Set",
    slug="pro-chess-set",
    category=category,
    description="High quality chess set",
    price=5000.00,
    discount_percentage=10,
    stock=50,
    sku="CHESS001",
    image="products/chess_set.jpg"
)
```

---

### Phase 8: Common Issues & Solutions

#### Issue: CORS errors in Flutter
**Solution:** Configure CORS in Django settings
```python
CORS_ALLOWED_ORIGINS = [
    "http://10.0.2.2:8000",  # Android emulator
    "http://localhost:8000",
]
```

#### Issue: Image URLs not loading
**Solution:** Ensure MEDIA_URL is configured and serving correctly
```python
# In urls.py
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    # ... your patterns
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

#### Issue: Token not persisting
**Solution:** Implement secure token storage
```dart
// Use flutter_secure_storage
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

---

## Quick Reference Commands

```bash
# Backend
cd backend/backend
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver 0.0.0.0:8000

# Frontend
cd frontend/frontend
flutter pub get
flutter run

# Create admin user
python manage.py shell
>>> from django.contrib.auth import get_user_model
>>> User = get_user_model()
>>> User.objects.create_superuser('admin', 'admin@example.com', 'password')
```

---

## Deployment Checklist

- [ ] Run all migrations
- [ ] Collect static files (`python manage.py collectstatic`)
- [ ] Configure allowed hosts
- [ ] Set DEBUG = False
- [ ] Configure CORS properly
- [ ] Test all payment methods (COD, Pickup)
- [ ] Test order creation and tracking
- [ ] Test product reviews
- [ ] Set up email notifications
- [ ] Configure logging
- [ ] Set up backups
- [ ] Test with real devices

---

## Support & Documentation

- Django REST Framework: https://www.django-rest-framework.org/
- Flutter Provider: https://pub.dev/packages/provider
- Django Models: https://docs.djangoproject.com/en/stable/topics/db/models/
- Flutter Widgets: https://flutter.dev/docs/development/ui/widgets

---

**Implementation complete! Your e-commerce shop is ready for customization and deployment.**
