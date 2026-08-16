import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/product_card.dart';
import '../details/plant_detail_screen.dart';
import '../details/discover_detail_screen.dart';
import 'cart_checkout_screen.dart';

class SavedFavouritesScreen extends StatelessWidget {
  const SavedFavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Saved / Favourites',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            tabs: [
              Tab(text: 'Wishlist'),
              Tab(text: 'Cart'),
              Tab(text: 'Favourites'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _WishlistTab(),
            _CartTab(),
            _FavouritesTab(),
          ],
        ),
      ),
    );
  }
}

// ── Tab 0: Wishlist ────────────────────────────────────────────
// Reads AppState.wishlistItems so it syncs with heart in Plant Detail
class _WishlistTab extends StatefulWidget {
  const _WishlistTab();
  @override
  State<_WishlistTab> createState() => _WishlistTabState();
}

class _WishlistTabState extends State<_WishlistTab> {
  @override
  Widget build(BuildContext context) {
    final items = AppState.instance.wishlistItems;

    if (items.isEmpty) {
      return _emptyState(
        Icons.favorite_border,
        'Your wishlist is empty',
        'Tap the heart on any plant to save it here.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10,
          mainAxisSpacing: 10, childAspectRatio: 0.56),
      itemCount: items.length,
      itemBuilder: (_, i) => ProductCard(
        product: items[i],
        onTap: () async {
          await Navigator.push(context,
              MaterialPageRoute(
                  builder: (_) => PlantDetailScreen(product: items[i])));
          // Rebuild after returning in case wishlist changed
          if (mounted) setState(() {});
        },
      ),
    );
  }
}

// ── Tab 1: Shopping Cart ───────────────────────────────────────
// Reads AppState.cartItems so it syncs with Add to Cart
class _CartTab extends StatefulWidget {
  const _CartTab();
  @override
  State<_CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<_CartTab> {
  @override
  Widget build(BuildContext context) {
    final cart = AppState.instance.cartItems;

    if (cart.isEmpty) {
      return _emptyState(
        Icons.shopping_cart_outlined,
        'Your cart is empty',
        'Add plants from the shop to see them here.',
      );
    }

    return Column(children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: cart.length,
          itemBuilder: (_, i) {
            final item = cart[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider)),
              child: Row(children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.local_florist_outlined,
                      color: AppColors.primaryDark, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(item.name,
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(item.category,
                        style: const TextStyle(fontSize: 11,
                            color: AppColors.textGrey)),
                    const SizedBox(height: 6),
                    Text('RM ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryMed)),
                  ]),
                ),
                // Qty stepper
                Row(children: [
                  _qtyBtn(Icons.remove, () {
                    setState(() => AppState.instance.decrementCart(item.id));
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${item.qty}',
                        style: const TextStyle(fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                  ),
                  _qtyBtn(Icons.add, () {
                    setState(() => AppState.instance.incrementCart(item.id));
                  }),
                ]),
              ]),
            );
          },
        ),
      ),

      // ── Checkout footer ───────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.divider))),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Total',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
              Text(
                'RM ${AppState.instance.cartTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark),
              ),
            ]),
          ),
          // Checkout button → goes to CartCheckoutScreen
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const CartCheckoutScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Checkout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ]),
      ),
    ]);
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.primaryLight,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 16, color: AppColors.primaryDark),
        ),
      ),
    );
  }
}

// ── Tab 2: Favourites (Discover items) ───────────────────────
// Reads AppState.favouriteDiscoverItems so it syncs with Discover screen
class _FavouritesTab extends StatefulWidget {
  const _FavouritesTab();
  @override
  State<_FavouritesTab> createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<_FavouritesTab> {
  @override
  Widget build(BuildContext context) {
    final favs = AppState.instance.favouriteDiscoverItems;

    if (favs.isEmpty) {
      return _emptyState(
        Icons.explore_outlined,
        'No favourites yet',
        'Tap the heart on any Discover item to save it here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favs.length,
      itemBuilder: (_, i) {
        final item = favs[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider)),
          child: Row(children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12)),
              child: Image.asset(item.image,
                  width: 90, height: 90, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(item.category,
                        style: const TextStyle(fontSize: 9,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text(item.title,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: AppColors.starColor),
                    const SizedBox(width: 3),
                    Text('${item.rating}',
                        style: const TextStyle(fontSize: 11,
                            color: AppColors.textGrey)),
                  ]),
                ]),
              ),
            ),
            // Remove from favourites
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Material(
                color: Colors.red.shade50,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: Colors.red.withOpacity(0.15),
                  onTap: () {
                    setState(() => AppState.instance.toggleFavDiscover(item));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Removed from favourites'),
                      backgroundColor: AppColors.primaryDark,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(milliseconds: 800),
                    ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.favorite, size: 18, color: Colors.red),
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

Widget _emptyState(IconData icon, String title, String subtitle) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80, height: 80,
          decoration: const BoxDecoration(
              color: AppColors.primaryLight, shape: BoxShape.circle),
          child: Icon(icon, size: 36, color: AppColors.primaryDark),
        ),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        const SizedBox(height: 8),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.textGrey,
                height: 1.5)),
      ]),
    ),
  );
}
