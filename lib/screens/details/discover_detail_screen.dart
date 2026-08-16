import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/app_state.dart';
import '../../models/models.dart';

class DiscoverDetailScreen extends StatefulWidget {
  final DiscoverItem item;
  const DiscoverDetailScreen({super.key, required this.item});

  @override
  State<DiscoverDetailScreen> createState() => _DiscoverDetailScreenState();
}

class _DiscoverDetailScreenState extends State<DiscoverDetailScreen> {
  // Read directly from AppState so it is always in sync with the grid
  bool get _fav => AppState.instance.isFavDiscover(widget.item.id);

  void _toggle() {
    AppState.instance.toggleFavDiscover(widget.item);
    setState(() {}); // rebuild this screen
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // TEXT ONLY — no emoji
      content: Text(_fav ? 'Added to favourites' : 'Removed from favourites'),
      backgroundColor: AppColors.primaryDark,
      duration: const Duration(milliseconds: 800),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(widget.item.image, fit: BoxFit.cover),
          ),
          actions: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  _fav ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(_fav),
                  color: _fav ? Colors.red : Colors.white,
                ),
              ),
              onPressed: _toggle,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(widget.item.category,
                      style: const TextStyle(fontSize: 11,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600)),
                ),
                Row(children: [
                  const Icon(Icons.star, size: 14, color: AppColors.starColor),
                  const SizedBox(width: 3),
                  Text('${widget.item.rating}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                ]),
              ]),
              const SizedBox(height: 12),
              Text(widget.item.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 6),
              Text(widget.item.subtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
              const Divider(height: 28),
              const Text('Overview',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text(widget.item.description,
                  style: const TextStyle(fontSize: 13, color: AppColors.textMed,
                      height: 1.7)),
              const SizedBox(height: 28),
              // Save/Unsave button — reads AppState so it is always in sync
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _toggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _fav ? Colors.red.shade400 : AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        _fav ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_fav), size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(_fav ? 'Saved to Favourites' : 'Save to Favourites',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }
}
