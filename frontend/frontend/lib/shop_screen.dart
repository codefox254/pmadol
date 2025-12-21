import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Chess Sets', 'Chess Clocks', 'Books', 'Accessories', 'Apparel'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPageHeader(),
          _buildCategoryFilter(),
          _buildProductsGrid(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/shop_header.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.6)),
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
                Text('Our Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text('Quality chess equipment for players of all levels',
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

  Widget _buildCategoryFilter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return FilterChip(
            label: Text(category,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF404957),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedCategory = category;
              });
            },
            backgroundColor: Colors.white,
            selectedColor: Color(0xFF5886BF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Color(0xFF5886BF)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductsGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 0.7,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          return _buildProductCard(index);
        },
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final List<String> productNames = [
      'Tournament Chess Set',
      'Wooden Chess Board',
      'Digital Chess Clock',
      'Chess Strategy Book',
      'Leather Chess Board',
      'Chess Pieces Set',
      'Analog Chess Clock',
      'Chess Opening Manual',
      'Travel Chess Set',
      'Premium Chess Board',
      'Competition Clock',
      'Endgame Techniques',
      'Magnetic Chess Set',
      'Chess Score Sheets',
      'Silicone Chess Mat',
      'Chess Tactics Book',
    ];

    final List<String> prices = [
      '3,500 KES',
      '5,000 KES',
      '2,800 KES',
      '1,200 KES',
      '8,000 KES',
      '4,500 KES',
      '2,000 KES',
      '1,500 KES',
      '2,500 KES',
      '12,000 KES',
      '3,200 KES',
      '1,800 KES',
      '1,500 KES',
      '500 KES',
      '1,800 KES',
      '1,400 KES',
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/product_${index + 1}.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (index % 5 == 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productNames[index],
                    style: TextStyle(
                      color: Color(0xFF0B131E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < 4 ? Icons.star : Icons.star_border,
                        color: Color(0xFFFFA500),
                        size: 16,
                      );
                    }),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(prices[index],
                        style: TextStyle(
                          color: Color(0xFF5886BF),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showProductDetails(context, index);
                        },
                        icon: Icon(Icons.shopping_cart_outlined),
                        color: Color(0xFF5886BF),
                        style: IconButton.styleFrom(
                          backgroundColor: Color(0xFFF5F9FF),
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
    );
  }

  void _showProductDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage('assets/images/product_${index + 1}.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tournament Chess Set',
                            style: TextStyle(
                              color: Color(0xFF0B131E),
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < 4 ? Icons.star : Icons.star_border,
                                color: Color(0xFFFFA500),
                                size: 20,
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                          Text('3,500 KES',
                            style: TextStyle(
                              color: Color(0xFF5886BF),
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Professional tournament-standard chess set with weighted pieces and roll-up vinyl board. Perfect for competitive play and practice sessions.',
                            style: TextStyle(
                              color: Color(0xFF404957),
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Text('Quantity:',
                                style: TextStyle(
                                  color: Color(0xFF0B131E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 15),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF5886BF)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {},
                                      color: Color(0xFF5886BF),
                                    ),
                                    Text('1',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {},
                                      color: Color(0xFF5886BF),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.shopping_cart),
                                  label: Text('Add to Cart'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF5886BF),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border),
                                color: Color(0xFF5886BF),
                                style: IconButton.styleFrom(
                                  backgroundColor: Color(0xFFF5F9FF),
                                  padding: EdgeInsets.all(15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close',
                      style: TextStyle(
                        color: Color(0xFF5886BF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Color(0xFF0B131E),
      padding: EdgeInsets.all(80),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterFeature(Icons.local_shipping, 'Fast Delivery', 'Across Nairobi'),
              _buildFooterFeature(Icons.verified_user, 'Quality Guaranteed', '100% Authentic'),
              _buildFooterFeature(Icons.support_agent, '24/7 Support', 'We\'re here to help'),
              _buildFooterFeature(Icons.credit_card, 'Secure Payment', 'Safe & protected'),
            ],
          ),
          SizedBox(height: 50),
          Divider(color: Colors.white24),
          SizedBox(height: 20),
          Text('© 2025 PMadol Chess Club. All rights reserved.',
            style: TextStyle(color: Color(0xFFF4F6F7), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFooterFeature(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF5886BF), size: 50),
        SizedBox(height: 15),
        Text(title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(subtitle,
          style: TextStyle(
            color: Color(0xFFF4F6F7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}