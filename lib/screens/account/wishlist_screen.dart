import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/mock_data.dart';
import '../../screens/details/plant_detail_screen.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late final wishlisted = MockData.products.where((p) => p.isWishlisted || p.id == 'p2' || p.id == 'p4').toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, elevation: 0,
        title: const Text('Wishlist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: wishlisted.isEmpty
        ? const Center(child: Text('Your wishlist is empty.', style: TextStyle(color: AppColors.textGrey)))
        : GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.56),
            itemCount: wishlisted.length,
            itemBuilder: (_, i) => ProductCard(
              product: wishlisted[i],
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => PlantDetailScreen(product: wishlisted[i])))),
          ),
    );
  }
}
