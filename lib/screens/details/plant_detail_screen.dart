import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/app_state.dart';
import '../../models/models.dart';
import 'buy_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final PlantProduct product;
  const PlantDetailScreen({super.key, required this.product});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  // Reads AppState so wishlist syncs across Wishlist tab and here
  bool get _wishlisted => AppState.instance.isWishlisted(widget.product.id);

  void _toggleWishlist() {
    AppState.instance.toggleWishlist(widget.product);
    setState(() {});
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_wishlisted ? 'Added to wishlist' : 'Removed from wishlist'),
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(product.image, fit: BoxFit.cover),
            ),
            actions: [
              // ── Heart icon — fully functional, changes colour on tap ──
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    _wishlisted ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(_wishlisted),
                    // Red when wishlisted, white when not
                    color: _wishlisted ? Colors.red : Colors.white,
                    size: 26,
                  ),
                ),
                onPressed: _toggleWishlist,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(product.category,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600)),
                      ),
                      Row(children: [
                        const Icon(Icons.star, size: 14, color: AppColors.starColor),
                        const SizedBox(width: 3),
                        Text(
                          '${product.rating}  (${product.reviewCount} reviews)',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const SizedBox(height: 8),

                  // Price
                  if (product.hasDiscount) ...[
                    Text(
                      'RM ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textStrike,
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      'RM ${product.discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryMed),
                    ),
                  ] else
                    Text(
                      'RM ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryMed),
                    ),

                  const SizedBox(height: 20),

                  // Wishlist shortcut row inside body
                  GestureDetector(
                    onTap: _toggleWishlist,
                    child: Row(children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          _wishlisted ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(_wishlisted),
                          color: _wishlisted ? Colors.red : AppColors.textGrey,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _wishlisted ? 'Saved to Wishlist' : 'Add to Wishlist',
                        style: TextStyle(
                          fontSize: 12,
                          color: _wishlisted ? Colors.red : AppColors.textGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text('About this plant',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMed, height: 1.6)),
                  const SizedBox(height: 28),

                  // Action buttons
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart!'),
                              backgroundColor: AppColors.primaryDark,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          side: const BorderSide(color: AppColors.primaryDark),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Add to Cart',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuyScreen(
                              productName: product.name,
                              price: product.activePrice,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Buy Now',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
