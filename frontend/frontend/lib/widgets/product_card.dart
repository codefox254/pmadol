// ============================================
// lib/widgets/product_card.dart
// Robust Product Card Widget
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';
import '../models/shop_models.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    color: const Color(0xFFF8FAFC),
                    image: widget.product.image != null
                        ? DecorationImage(
                            image: NetworkImage(
                                '${ApiConfig.baseUrl}${widget.product.image}'),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: widget.product.image == null
                      ? const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xFFCED5E0),
                            size: 40,
                          ),
                        )
                      : null,
                ),
                // Discount badge
                if (widget.product.discountPercentage > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${widget.product.discountPercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Stock status
                if (!widget.product.inStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Center(
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Category
                    if (widget.product.categoryName != null)
                      Text(
                        widget.product.categoryName!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF707781),
                        ),
                      ),
                    const SizedBox(height: 6),
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.product.averageRating.toStringAsFixed(1)} '
                          '(${widget.product.reviewCount})',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF707781),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.product.discountPercentage > 0)
                          Text(
                            'Rs. ${widget.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF707781),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          'Rs. ${widget.product.discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5886BF),
                          ),
                        ),
                        if (widget.product.discountPercentage > 0)
                          Text(
                            'Save Rs. ${widget.product.savings.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Add to cart button
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: widget.product.inStock
                            ? () => _handleAddToCart(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5886BF),
                          disabledBackgroundColor: const Color(0xFFCED5E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isAddingToCart
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
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

  Future<void> _handleAddToCart(BuildContext context) async {
    setState(() => _isAddingToCart = true);

    try {
      final cartProvider = context.read<CartProvider>();
      final success = await cartProvider.addToCart(widget.product.id);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.product.name} added to cart'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          if (widget.onAddToCart != null) {
            widget.onAddToCart!();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cartProvider.error ?? 'Failed to add to cart'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }
}
