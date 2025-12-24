import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shop_provider.dart';
import 'providers/home_provider.dart';
import 'providers/cart_provider.dart';
import 'widgets/footer_widget.dart';
import 'widgets/checkout_form.dart';
import 'config/api_config.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = '';
  String sortOption = 'newest';

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${ApiConfig.baseUrl}$path';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    Future.microtask(() {
      context.read<ShopProvider>().loadProducts();
      context.read<ShopProvider>().loadCategories();
      context.read<HomeProvider>().loadHomeData();
      context.read<CartProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Consumer3<ShopProvider, HomeProvider, CartProvider>(
      builder: (context, shopProvider, homeProvider, cartProvider, child) {
        final homeData = homeProvider.homeData;
        
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              _buildSearchBar(isMobile, shopProvider),
              _buildCategoryFilter(isMobile, shopProvider),
              _buildCartBar(isMobile, cartProvider),
              _buildProductGrid(isMobile, shopProvider, cartProvider),
              if (homeData != null) FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5886BF), Color(0xFF283D57)],
        ),
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.2)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CHESS EQUIPMENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Quality chess sets, books, and accessories',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile, ShopProvider shopProvider) {
    final horizontalPadding = isMobile ? 16.0 : 80.0;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE8EFF7)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.search, color: Color(0xFF707781), size: 20),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(color: Color(0xFFB0B8C1)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (query) {
                        if (query.length >= 2) {
                          shopProvider.searchProducts(query);
                        } else if (query.isEmpty) {
                          shopProvider.loadProducts();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE8EFF7)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortOption,
                icon: Icon(Icons.expand_more, color: Color(0xFF707781)),
                items: [
                  DropdownMenuItem(value: 'newest', child: Text('Newest')),
                  DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                  DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                  DropdownMenuItem(value: 'popular', child: Text('Popular')),
                  DropdownMenuItem(value: 'rating', child: Text('Top Rated')),
                ].toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => sortOption = value);
                    shopProvider.sortProducts(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(bool isMobile, ShopProvider shopProvider) {
    return Consumer<ShopProvider>(
      builder: (context, provider, child) {
        if (provider.categories.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 20 : 30,
              horizontal: isMobile ? 16 : 80,
            ),
            child: Center(
              child: Text(
                'No categories available yet',
                style: TextStyle(color: Color(0xFF707781)),
              ),
            ),
          );
        }

        final categories = ['All', ...provider.categories.map((c) => c.name).toList()];
        
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 20 : 30,
            horizontal: isMobile ? 16 : 80,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: isMobile ? 10 : 15,
              children: categories.map((category) {
                final isSelected = selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedCategory = category);
                    if (category == 'All') {
                      provider.loadProducts();
                    } else {
                      final categoryObj = provider.categories.firstWhere(
                        (c) => c.name == category,
                      );
                      provider.filterByCategory(categoryObj.slug);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF5886BF) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? Color(0xFF5886BF) : Color(0xFFE8EFF7),
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF404957),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartBar(bool isMobile, CartProvider cartProvider) {
    final totalItems = cartProvider.totalItems;
    final totalAmount = cartProvider.discountedAmount > 0
        ? cartProvider.discountedAmount
        : cartProvider.totalAmount;

    return Container
    (
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: isMobile ? 10 : 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(color: Color(0xFFE8EFF7)),
          bottom: BorderSide(color: Color(0xFFE8EFF7)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE8EFF7)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart_outlined, color: Color(0xFF5886BF)),
                if (totalItems > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFFE74C3C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$totalItems',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cart & Checkout',
                  style: TextStyle(
                    color: Color(0xFF0B131E),
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  totalItems > 0
                      ? '$totalItems items · KES ${totalAmount.toStringAsFixed(0)}'
                      : 'No items yet. Add products to checkout.',
                  style: TextStyle(
                    color: Color(0xFF707781),
                    fontSize: isMobile ? 12 : 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _openCartSheet(cartProvider),
            icon: Icon(Icons.shopping_bag_outlined, size: isMobile ? 16 : 18),
            label: Text('View Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5886BF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 10 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(bool isMobile, ShopProvider shopProvider, CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 40,
      ),
      child: Consumer<ShopProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF5886BF)),
            );
          }

          if (provider.error != null && provider.error!.isNotEmpty) {
            return Center(
              child: Text(
                'Error loading products: ${provider.error}',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final products = provider.products;
          if (products.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'No products available in this category',
                  style: TextStyle(fontSize: 18, color: Color(0xFF707781)),
                ),
              ),
            );
          }

          final gridColumns = isMobile ? 2 : (MediaQuery.of(context).size.width > 1200 ? 4 : 3);

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridColumns,
              crossAxisSpacing: isMobile ? 12 : 25,
              mainAxisSpacing: isMobile ? 12 : 25,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index], isMobile, cartProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(dynamic product, bool isMobile, CartProvider cartProvider) {
    final inStock = product.inStock;
    final hasDiscount = product.discountPercentage > 0;
    
    return GestureDetector(
      onTap: () {
        // Navigate to product details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to: ${product.name}')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: isMobile ? 120 : 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    color: Color(0xFFF8FAFC),
                    image: product.image != null
                        ? DecorationImage(
                            image: NetworkImage(_resolveImageUrl(product.image)!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: product.image == null
                      ? Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 40, color: Color(0xFF707781).withOpacity(0.3)),
                        )
                      : null,
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFE74C3C),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${product.discountPercentage}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (!inStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: Center(
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.categoryName != null)
                      Text(
                        product.categoryName,
                        style: TextStyle(
                          color: Color(0xFF5886BF),
                          fontSize: isMobile ? 10 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          color: Color(0xFF0B131E),
                          fontSize: isMobile ? 13 : 15,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasDiscount)
                              Text(
                                'KES ${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Color(0xFF707781),
                                  fontSize: isMobile ? 10 : 11,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              'KES ${product.discountedPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Color(0xFF0B131E),
                                fontSize: isMobile ? 13 : 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: inStock
                              ? () async {
                                  try {
                                    final added = await cartProvider.addToCart(product.id, quantity: 1);
                                    if (added) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Added to cart'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      final message = cartProvider.error?.contains('401') == true
                                          ? 'Please log in to use the cart'
                                          : (cartProvider.error ?? 'Unable to add to cart');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 6 : 8),
                            decoration: BoxDecoration(
                              color: inStock ? Color(0xFF5886BF) : Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: isMobile ? 14 : 18,
                              color: inStock ? Colors.white : Color(0xFF999999),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCartSheet(CartProvider cartProvider) async {
    await cartProvider.loadCart();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        if (cartProvider.isLoading) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator(color: Color(0xFF5886BF))),
          );
        }

        final cart = cartProvider.cart;

        if (cart == null || cart.items.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 48, color: Color(0xFF707781)),
                SizedBox(height: 12),
                Text('Your cart is empty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text('Add some items to start checkout.', style: TextStyle(color: Color(0xFF707781))),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5886BF)),
                  child: Text('Browse Products'),
                ),
              ],
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12),
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E6EE),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 12),
                TabBar(
                  indicatorColor: Color(0xFF5886BF),
                  labelColor: Color(0xFF0B131E),
                  unselectedLabelColor: Color(0xFF707781),
                  tabs: [
                    Tab(text: 'Cart (${cart.totalItems})'),
                    Tab(text: 'Checkout'),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: TabBarView(
                    children: [
                      _buildCartList(cartProvider),
                      CheckoutForm(
                        cart: cart,
                        onOrderCreated: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartList(CartProvider cartProvider) {
    final cart = cartProvider.cart;
    if (cart == null) {
      return Center(child: Text('Cart unavailable'));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => Divider(color: Color(0xFFE8EFF7)),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        image: item.product.image != null
                            ? DecorationImage(
                                image: NetworkImage(_resolveImageUrl(item.product.image)!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: item.product.image == null
                          ? Icon(Icons.image_not_supported_outlined, color: Color(0xFFB0B8C1))
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text('Qty: ${item.quantity}', style: TextStyle(color: Color(0xFF707781))),
                        ],
                      ),
                    ),
                    Text(
                      'KES ${item.discountedSubtotal.toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 12),
          _cartSummaryRow('Subtotal', cart.totalAmount),
          if (cart.totalDiscount > 0) _cartSummaryRow('Discount', -cart.totalDiscount),
          _cartSummaryRow('Total', cart.discountedAmount > 0 ? cart.discountedAmount : cart.totalAmount,
              isEmphasis: true),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => DefaultTabController.of(context)?.animateTo(1),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5886BF)),
              child: Text('Continue to Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartSummaryRow(String label, double amount, {bool isEmphasis = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF404957),
              fontWeight: isEmphasis ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            'KES ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: Color(0xFF0B131E),
              fontWeight: isEmphasis ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
