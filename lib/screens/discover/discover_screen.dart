import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import '../../data/mock_data.dart';
import '../../data/app_state.dart';
import '../../models/models.dart';
import '../details/discover_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _items = MockData.discoverItems;
  int _chipIdx = 0;
  String _query = '';
  static const _chips = ['All', 'Indoor', 'Outdoor', 'DIY', 'Edible', 'Aquatic'];

  List<DiscoverItem> get _filtered {
    var list = _chipIdx == 0
        ? _items
        : _items.where((i) => i.category == _chips[_chipIdx]).toList();
    if (_query.isNotEmpty) {
      list = list.where((i) =>
          i.title.toLowerCase().contains(_query.toLowerCase()) ||
          i.category.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    return list;
  }

  // Navigate to detail and rebuild on return so heart syncs
  Future<void> _openDetail(DiscoverItem item) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (_) => DiscoverDetailScreen(item: item)));
    // Rebuild after returning so the grid heart reflects any change made in detail
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: CustomScrollView(slivers: [

        // ── Header ────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.primaryDark,
            padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Discover',
                  style: TextStyle(color: Colors.white, fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              const Text('Explore plant ideas & inspirations',
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 12),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  onChanged: (q) => setState(() => _query = q),
                  decoration: InputDecoration(
                    hintText: 'Search inspirations…',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(A.iconSearch,
                          width: 16, height: 16, color: Colors.white70)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
            ]),
          ),
        ),

        // ── Trending section label (above image) ──────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text('TRENDING DISCOVERIES',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                      color: AppColors.textDark, letterSpacing: 0.3)),
            ]),
          ),
        ),

        // ── Trending image — no text overlay ─────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: GestureDetector(
              onTap: () => _openDetail(_items[0]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(A.trending,
                    width: double.infinity, height: 170, fit: BoxFit.cover),
              ),
            ),
          ),
        ),

        // ── Category chips ─────────────────────────────────────
        SliverToBoxAdapter(
          child: SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              itemCount: _chips.length,
              itemBuilder: (_, i) {
                final sel = _chipIdx == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: sel ? AppColors.primaryDark : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => _chipIdx = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: sel ? AppColors.primaryDark : AppColors.divider)),
                        child: Text(_chips[i],
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : AppColors.textMed)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // ── Grid or empty state ───────────────────────────────
        _filtered.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(children: [
                    const Icon(Icons.search_off, size: 48, color: AppColors.textGrey),
                    const SizedBox(height: 12),
                    Text(_query.isEmpty
                            ? 'Nothing in this category.'
                            : 'No results for "$_query".',
                        style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
                  ]),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final item = _filtered[i];
                      return Material(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          splashColor: AppColors.primaryDark.withOpacity(0.08),
                          // Use async push → setState on return for sync
                          onTap: () => _openDetail(item),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.divider, width: 0.5),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    child: Image.asset(item.image,
                                        width: double.infinity,
                                        height: 110, fit: BoxFit.cover),
                                  ),
                                  // Category badge
                                  Positioned(top: 6, left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryDark,
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Text(item.category,
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 9,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  // Heart — uses AppState so it syncs with detail
                                  Positioned(top: 6, right: 6,
                                    child: _FavButton(item: item,
                                        onToggle: () => setState(() {})),
                                  ),
                                ]),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title,
                                          style: const TextStyle(fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 3),
                                      Text(item.subtitle,
                                          style: const TextStyle(fontSize: 9,
                                              color: AppColors.textGrey,
                                              height: 1.3),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        const Icon(Icons.star,
                                            size: 11, color: AppColors.starColor),
                                        const SizedBox(width: 2),
                                        Text('${item.rating}',
                                            style: const TextStyle(
                                                fontSize: 9,
                                                color: AppColors.textGrey)),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _filtered.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 10,
                      mainAxisSpacing: 10, childAspectRatio: 0.72),
                ),
              ),
      ]),
    );
  }
}

// ── Heart button on grid card — uses AppState for sync ─────────
class _FavButton extends StatelessWidget {
  final DiscoverItem item;
  final VoidCallback onToggle;
  const _FavButton({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final fav = AppState.instance.isFavDiscover(item.id);
    return Material(
      color: Colors.black26,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: Colors.red.withOpacity(0.2),
        onTap: () {
          AppState.instance.toggleFavDiscover(item);
          onToggle(); // rebuild parent grid
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // TEXT ONLY — no emoji
              content: Text(AppState.instance.isFavDiscover(item.id)
                  ? 'Added to favourites'
                  : 'Removed from favourites'),
              backgroundColor: AppColors.primaryDark,
              duration: const Duration(milliseconds: 900),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              fav ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(fav),
              size: 16,
              color: fav ? Colors.red : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
