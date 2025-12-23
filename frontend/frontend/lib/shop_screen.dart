import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shop_provider.dart';
import 'providers/home_provider.dart';
import 'widgets/footer_widget.dart';
import 'config/api_config.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  String sortOption = 'Popular';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget _buildSearchAndSort(int total) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
      color: Color(0xFFFFFFFF),
      child: Row(
        children: [
          // Search
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE8EFF7)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF707781)),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search chess goods (sets, boards, clocks, books...)',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() => searchQuery = val),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          // Sort dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE8EFF7)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortOption,
                items: [
                  'Popular',
                  'Price: Low to High',
                  'Price: High to Low',
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => sortOption = val ?? 'Popular'),
              ),
            ),
          ),
          SizedBox(width: 20),
          Text('$total items', style: TextStyle(color: Color(0xFF707781))),
        ],
      ),
    );
  }
  void _loadData() {
    Future.microtask(() {
      context.read<ShopProvider>().loadProducts();
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ShopProvider, HomeProvider>(
      builder: (context, shopProvider, homeProvider, child) {
        if (shopProvider.isLoading || homeProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF5886BF)),
          );
        }

        final products = shopProvider.products;
        final homeData = homeProvider.homeData;
        
        if (homeData == null) {
          return Center(child: Text('No data available'));
        }

        // Filter products by category, search, and sort
        var filteredProducts = selectedCategory == 'All'
            ? products
            : products.where((p) => p.categoryName == selectedCategory).toList();
        if (searchQuery.isNotEmpty) {
          filteredProducts = filteredProducts
              .where((p) => (p.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
        }
        if (sortOption == 'Price: Low to High') {
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        } else if (sortOption == 'Price: High to Low') {
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildPageHeader(),
              _buildSearchAndSort(products.length),
              _buildCategoryFilter(products),
              _buildProductsGrid(filteredProducts),
              FooterWidget(settings: homeData.siteSettings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5886BF),
            Color(0xFF283D57),
          ],
        ),
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('CHESS EQUIPMENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Text('Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text('Quality chess sets, books, and accessories',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _buildCategoryFilter(List products) {
    // Extract unique categories
    final categories = ['All', ...products.map((p) => p.categoryName ?? 'Other').toSet()];
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 80),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
      ),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductsGrid(List products) {
    if (products.isEmpty) {
      return Container(
        padding: EdgeInsets.all(80),
        child: Center(
          child: Text(
            'No products available in this category',
            style: TextStyle(fontSize: 18, color: Color(0xFF707781)),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    final isAvailable = product.isAvailable && product.stockQuantity > 0;
    
    return Container(
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
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  color: Color(0xFFF8FAFC),
                  image: product.image != null
                      ? DecorationImage(
                          image: NetworkImage('${ApiConfig.baseUrl}${product.image}'),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.image == null
                    ? Center(
                        child: Icon(Icons.shopping_bag, size: 60, color: Color(0xFF5886BF).withOpacity(0.3)),
                      )
                    : null,
              ),
              if (product.isFeatured)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFF5886BF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Featured',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              if (!isAvailable)
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      'Out of Stock',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.categoryName != null)
                    Text(
                      product.categoryName,
                      style: TextStyle(
                        color: Color(0xFF5886BF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: 5),
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Color(0xFF0B131E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      product.description,
                      style: TextStyle(
                        color: Color(0xFF707781),
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KES ${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Color(0xFF0B131E),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          if (isAvailable)
                            Icon(Icons.shopping_cart_outlined, size: 20, color: Color(0xFF5886BF)),
                          SizedBox(width: 12),
                          Icon(Icons.favorite_border, size: 20, color: Color(0xFF707781)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
