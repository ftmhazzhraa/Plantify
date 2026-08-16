import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/product_card.dart';
import '../details/plant_detail_screen.dart';
import '../details/booking_screen.dart';

class MallScreen extends StatefulWidget {
  final int initialTab;
  const MallScreen({super.key, this.initialTab = 0});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  List<PlantProduct> _filtered = MockData.products;
  String _sortMode = 'All Items';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void didUpdateWidget(MallScreen old) {
    super.didUpdateWidget(old);
    if (widget.initialTab != old.initialTab) {
      _tabCtrl.animateTo(widget.initialTab);
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    setState(() {
      var base = q.isEmpty
          ? MockData.products
          : MockData.products
          .where((p) =>
      p.name.toLowerCase().contains(q.toLowerCase()) ||
          p.category.toLowerCase().contains(q.toLowerCase()))
          .toList();
      _filtered = _applySort(base, _sortMode);
    });
  }

  List<PlantProduct> _applySort(List<PlantProduct> list, String mode) {
    final copy = List<PlantProduct>.from(list);
    switch (mode) {
      case 'Discounted Only':
        return copy.where((p) => p.hasDiscount).toList();
      case 'Price: Low to High':
        copy.sort((a, b) => a.activePrice.compareTo(b.activePrice));
        return copy;
      case 'Price: High to Low':
        copy.sort((a, b) => b.activePrice.compareTo(a.activePrice));
        return copy;
      case 'Highest Rated':
        copy.sort((a, b) => b.rating.compareTo(a.rating));
        return copy;
      default:
        return copy;
    }
  }

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => _FilterSheet(
        current: _sortMode,
        onApply: (f) {
          Navigator.pop(context);
          setState(() {
            _sortMode = f;
            _filtered = _applySort(
              _searchCtrl.text.isEmpty
                  ? MockData.products
                  : MockData.products
                  .where((p) => p.name
                  .toLowerCase()
                  .contains(_searchCtrl.text.toLowerCase()))
                  .toList(),
              f,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Filter: $f applied'),
            backgroundColor: AppColors.primaryDark,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 900),
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: Column(children: [
        // ── Search + filter bar ──────────────────────────────
        Container(
          color: AppColors.white,
          padding: EdgeInsets.fromLTRB(16, top + 10, 16, 10),
          child: Row(children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.screenBg,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearch,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textDark),
                  decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                          color: AppColors.textGrey, fontSize: 13),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(A.iconSearch,
                            width: 18, height: 18, color: AppColors.textGrey),
                      ),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                          icon: const Icon(Icons.clear,
                              size: 18, color: AppColors.textGrey),
                          onPressed: () {
                            _searchCtrl.clear();
                            _onSearch('');
                          })
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _showFilter,
                splashColor: AppColors.primaryDark.withOpacity(0.12),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(A.iconFilter,
                      width: 22, height: 22, color: AppColors.textDark),
                ),
              ),
            ),
          ]),
        ),

        // ── Tab bar ──────────────────────────────────────────
        Container(
          color: AppColors.white,
          child: TabBar(
            controller: _tabCtrl,
            indicatorColor: AppColors.primaryDark,
            indicatorWeight: 2.5,
            labelColor: AppColors.primaryDark,
            unselectedLabelColor: AppColors.textGrey,
            labelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'SHOP'),
              Tab(text: 'SERVICES'),
              Tab(text: 'POSTS'),
            ],
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _ShopTab(
                products: _filtered,
                onTap: (p) => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => PlantDetailScreen(product: p))),
              ),
              _ServicesTab(
                onBook: (s) => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => BookingScreen(service: s))),
              ),
              // ── FIXED: _PostsTab now uses ListenableBuilder ──
              const _PostsTab(),
            ],
          ),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// SHOP TAB
// ════════════════════════════════════════════════════════════════
class _ShopTab extends StatelessWidget {
  final List<PlantProduct> products;
  final ValueChanged<PlantProduct> onTap;
  const _ShopTab({required this.products, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off, size: 48, color: AppColors.textGrey),
          SizedBox(height: 12),
          Text('No plants found.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
          SizedBox(height: 4),
          Text('Try a different keyword.',
              style: TextStyle(color: AppColors.navInactive, fontSize: 12)),
        ]),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.56),
      itemCount: products.length,
      itemBuilder: (_, i) =>
          ProductCard(product: products[i], onTap: () => onTap(products[i])),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// SERVICES TAB
// ════════════════════════════════════════════════════════════════
class _ServicesTab extends StatelessWidget {
  final ValueChanged<PlantService> onBook;
  const _ServicesTab({required this.onBook});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: MockData.services.length,
      itemBuilder: (_, i) {
        final s = MockData.services[i];
        return Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: AppColors.primaryDark.withOpacity(0.08),
            onTap: () => onBook(s),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider, width: 0.5),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.asset(s.image,
                      width: 90, height: 90, fit: BoxFit.cover),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 3),
                          Row(children: [
                            const Icon(Icons.star,
                                size: 11, color: AppColors.starColor),
                            const SizedBox(width: 3),
                            Text('${s.rating}',
                                style: const TextStyle(
                                    fontSize: 10, color: AppColors.textGrey)),
                          ]),
                          const SizedBox(height: 3),
                          Text(s.description,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textGrey,
                                  height: 1.4),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('RM ${s.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryMed)),
                                GestureDetector(
                                  onTap: () => onBook(s),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryDark,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: const Text('Book Now',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ]),
                        ]),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════
// POSTS TAB — FIXED: Uses ListenableBuilder to auto‑refresh
// ════════════════════════════════════════════════════════════════
class _PostsTab extends StatefulWidget {
  const _PostsTab();

  @override
  State<_PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<_PostsTab> {
  // ── Comments sheet ───────────────────────────────────────────
  void _openComments(PlantPost p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) =>
          _CommentsSheet(post: p, onUpdate: () => setState(() {})),
    );
  }

  // ── Navigate to DM with a post author ────────────────────────
  void _messageUser(PlantPost p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DirectMessageScreen(
          authorName: p.author,
          authorAvatar: p.avatar,
        ),
      ),
    );
  }

  // ── Create post ───────────────────────────────────────────────
  void _createPost() => _showPostEditor(null);

  // ── Edit post ─────────────────────────────────────────────────
  void _editPost(PlantPost p) => _showPostEditor(p);

  // ── Delete post ───────────────────────────────────────────────
  void _deletePost(PlantPost p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Post',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text(
            'Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete via AppState
              AppState.instance.deletePost(p);
              // No setState — ListenableBuilder will rebuild
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post deleted'),
                  backgroundColor: AppColors.primaryDark,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(milliseconds: 900),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Delete',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Create/Edit as a full pushed screen ──────────────────────
  // KEY FIX: NO .then(setState) — the ListenableBuilder handles updates
  void _showPostEditor(PlantPost? existing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PostEditorScreen(existing: existing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── LISTEN TO AppState DIRECTLY ──────────────────────────
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final posts = AppState.instance.posts;

        return Stack(
          children: [
            // ── Post list or empty state ─────────────────────────
            posts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.article_outlined,
                      size: 52, color: AppColors.textGrey),
                  const SizedBox(height: 14),
                  const Text('No posts yet.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  const Text('Be the first to share a plant story!',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _createPost,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Create Post',
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding:
              const EdgeInsets.fromLTRB(12, 12, 12, 90),
              itemCount: posts.length,
              itemBuilder: (_, i) {
                final p = posts[i];
                final isOwn = p.author == 'You';

                return Material(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.divider, width: 0.5),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Author row
                        Row(children: [
                          GestureDetector(
                            onTap:
                            isOwn ? null : () => _messageUser(p),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: isOwn
                                  ? AppColors.primaryMed
                                  : AppColors.primaryDark,
                              child: Text(p.avatar,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight:
                                      FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  GestureDetector(
                                    onTap: isOwn
                                        ? null
                                        : () => _messageUser(p),
                                    child: Text(
                                      p.author,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isOwn
                                            ? AppColors.primaryMed
                                            : AppColors.primaryDark,
                                        decoration: isOwn
                                            ? null
                                            : TextDecoration
                                            .underline,
                                        decorationColor:
                                        AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                  if (isOwn) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 7,
                                          vertical: 2),
                                      decoration: BoxDecoration(
                                          color:
                                          AppColors.primaryLight,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10)),
                                      child: const Text('You',
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: AppColors
                                                  .primaryDark,
                                              fontWeight:
                                              FontWeight.bold)),
                                    ),
                                  ],
                                ]),
                                Text(p.timeAgo,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textGrey)),
                              ],
                            ),
                          ),
                          // Own posts: 3-dot menu
                          if (isOwn)
                            PopupMenuButton<String>(
                              onSelected: (v) {
                                if (v == 'edit') _editPost(p);
                                if (v == 'delete') _deletePost(p);
                              },
                              icon: const Icon(Icons.more_vert,
                                  size: 18,
                                  color: AppColors.textGrey),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(children: [
                                    Icon(Icons.edit_outlined,
                                        size: 18,
                                        color:
                                        AppColors.primaryDark),
                                    SizedBox(width: 10),
                                    Text('Edit post',
                                        style:
                                        TextStyle(fontSize: 13)),
                                  ]),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(children: [
                                    Icon(Icons.delete_outline,
                                        size: 18,
                                        color: Colors.red),
                                    SizedBox(width: 10),
                                    Text('Delete post',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.red)),
                                  ]),
                                ),
                              ],
                            )
                          else
                          // Other users: mail icon
                            IconButton(
                              icon: const Icon(Icons.mail_outline,
                                  size: 18,
                                  color: AppColors.textGrey),
                              tooltip: 'Message ${p.author}',
                              splashRadius: 20,
                              onPressed: () => _messageUser(p),
                            ),
                        ]),

                        const SizedBox(height: 8),

                        // Post content
                        Text(p.title,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark)),
                        const SizedBox(height: 4),
                        Text(p.body,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMed,
                                height: 1.5),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),

                        // Like / Comment / Message row
                        Row(children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                              BorderRadius.circular(20),
                              splashColor:
                              Colors.red.withOpacity(0.15),
                              onTap: () {
                                AppState.instance.togglePostLike(p);
                                // No setState — ListenableBuilder does it
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Row(children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(
                                        milliseconds: 200),
                                    child: Icon(
                                      p.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      key: ValueKey(p.isLiked),
                                      size: 16,
                                      color: p.isLiked
                                          ? Colors.red
                                          : AppColors.textGrey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${p.likes}',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color:
                                          AppColors.textGrey)),
                                ]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _openComments(p),
                            child: Row(children: [
                              const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 16,
                                  color: AppColors.textGrey),
                              const SizedBox(width: 4),
                              Text('${p.commentList.length}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textGrey)),
                            ]),
                          ),
                          if (!isOwn) ...[
                            const Spacer(),
                            GestureDetector(
                              onTap: () => _messageUser(p),
                              child: Row(children: [
                                const Icon(Icons.send_outlined,
                                    size: 14,
                                    color: AppColors.primaryMed),
                                const SizedBox(width: 4),
                                Text(
                                    'Message ${p.author.split(' ')[0]}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primaryMed,
                                        fontWeight:
                                        FontWeight.w600)),
                              ]),
                            ),
                          ],
                        ]),
                      ],
                    ),
                  ),
                );
              },
            ),

            // ── FAB — positioned over the list ───────────────────
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                heroTag: 'posts_fab',
                onPressed: _createPost,
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('New Post',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                elevation: 3,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════
// COMMENTS SHEET
// ════════════════════════════════════════════════════════════════
class _CommentsSheet extends StatefulWidget {
  final PlantPost post;
  final VoidCallback onUpdate;
  const _CommentsSheet({required this.post, required this.onUpdate});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _ctrl = TextEditingController();
  String? _editingId;

  void _submit() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      if (_editingId != null) {
        final c = widget.post.commentList
            .firstWhere((c) => c.id == _editingId);
        c.text = _ctrl.text.trim();
        _editingId = null;
      } else {
        widget.post.commentList.add(PostComment(
          id: 'c${DateTime.now().millisecondsSinceEpoch}',
          author: 'You',
          avatar: 'E',
          text: _ctrl.text.trim(),
          timeAgo: 'Just now',
        ));
        widget.post.comments = widget.post.commentList.length;
      }
      _ctrl.clear();
    });
    widget.onUpdate();
  }

  void _delete(PostComment c) {
    setState(() {
      widget.post.commentList.remove(c);
      widget.post.comments = widget.post.commentList.length;
    });
    widget.onUpdate();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Comments (${widget.post.commentList.length})',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
          ),
          const Divider(),
          Expanded(
            child: widget.post.commentList.isEmpty
                ? const Center(
                child: Text('No comments yet. Be the first!',
                    style: TextStyle(color: AppColors.textGrey)))
                : ListView.builder(
              controller: ctrl,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.post.commentList.length,
              itemBuilder: (_, i) {
                final c = widget.post.commentList[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primaryMed,
                          child: Text(c.avatar,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(c.author,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark)),
                                  const SizedBox(width: 6),
                                  Text(c.timeAgo,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textGrey)),
                                ]),
                                const SizedBox(height: 2),
                                Text(c.text,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMed,
                                        height: 1.4)),
                                if (c.author == 'You')
                                  Row(children: [
                                    TextButton(
                                      onPressed: () => setState(() {
                                        _editingId = c.id;
                                        _ctrl.text = c.text;
                                      }),
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap),
                                      child: const Text('Edit',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color:
                                              AppColors.primaryMed)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () => _delete(c),
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap),
                                      child: const Text('Delete',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.red)),
                                    ),
                                  ]),
                              ]),
                        ),
                      ]),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.screenBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider)),
                  child: TextField(
                    controller: _ctrl,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textDark),
                    decoration: InputDecoration(
                      hintText: _editingId != null
                          ? 'Edit comment…'
                          : 'Write a comment…',
                      hintStyle: const TextStyle(
                          color: AppColors.textGrey, fontSize: 12),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.primaryDark,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _submit,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child:
                    Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// DIRECT MESSAGE SCREEN
// ════════════════════════════════════════════════════════════════
class _DirectMessageScreen extends StatefulWidget {
  final String authorName;
  final String authorAvatar;
  const _DirectMessageScreen(
      {required this.authorName, required this.authorAvatar});

  @override
  State<_DirectMessageScreen> createState() =>
      _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<_DirectMessageScreen> {
  final _ctrl = TextEditingController();
  String? _editId;
  bool _syncedToInbox = false;

  late final List<_DmBubble> _thread = [
    _DmBubble(
      id: 'seed1',
      text:
      'Hi! Thanks for checking out my post. Feel free to ask anything about plants!',
      isMe: false,
      time: 'Just now',
    ),
  ];

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      if (_editId != null) {
        final idx = _thread.indexWhere((b) => b.id == _editId);
        if (idx != -1) {
          _thread[idx] = _DmBubble(
              id: _thread[idx].id,
              text: text,
              isMe: _thread[idx].isMe,
              time: _thread[idx].time);
        }
        _editId = null;
      } else {
        _thread.add(_DmBubble(
          id: 'dm${DateTime.now().millisecondsSinceEpoch}',
          text: text,
          isMe: true,
          time: 'Just now',
        ));

        if (!_syncedToInbox) {
          _syncedToInbox = true;
          AppState.instance.addOrUpdateDirectMessage(
            authorName: widget.authorName,
            authorAvatar: widget.authorAvatar,
            firstMessage: text,
          );
        }
      }
      _ctrl.clear();
    });
  }

  void _deleteMsg(_DmBubble b) => setState(() => _thread.remove(b));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Text(widget.authorAvatar,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.authorName,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            const Text('Online',
                style: TextStyle(fontSize: 11, color: Colors.white60)),
          ]),
        ]),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _thread.length,
            itemBuilder: (_, i) {
              final b = _thread[i];
              return Align(
                alignment: b.isMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: GestureDetector(
                  onLongPress: b.isMe
                      ? () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16))),
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primaryDark),
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              _editId = b.id;
                              _ctrl.text = b.text;
                            });
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                              Icons.delete_outline,
                              color: Colors.red),
                          title: const Text('Delete',
                              style: TextStyle(
                                  color: Colors.red)),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteMsg(b);
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                        maxWidth:
                        MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: b.isMe
                          ? AppColors.primaryDark
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: b.isMe
                          ? null
                          : Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(b.text,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: b.isMe
                                      ? Colors.white
                                      : AppColors.textDark,
                                  height: 1.4)),
                          const SizedBox(height: 3),
                          Text(b.time,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: b.isMe
                                      ? Colors.white60
                                      : AppColors.textGrey)),
                        ]),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              color: AppColors.white,
              border:
              Border(top: BorderSide(color: AppColors.divider))),
          padding: EdgeInsets.fromLTRB(
              12,
              8,
              12,
              MediaQuery.of(context).padding.bottom + 10),
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.screenBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.divider)),
                child: TextField(
                  controller: _ctrl,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textDark),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: _editId != null
                        ? 'Edit message…'
                        : 'Type a message…',
                    hintStyle: const TextStyle(
                        color: AppColors.textGrey, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.primaryDark,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _send,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _DmBubble {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  const _DmBubble(
      {required this.id,
        required this.text,
        required this.isMe,
        required this.time});
}

// ════════════════════════════════════════════════════════════════
// POST EDITOR SCREEN
// ════════════════════════════════════════════════════════════════
class _PostEditorScreen extends StatefulWidget {
  final PlantPost? existing;
  const _PostEditorScreen({this.existing});

  @override
  State<_PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<_PostEditorScreen> {
  late final TextEditingController _titleCtrl =
  TextEditingController(text: widget.existing?.title ?? '');
  late final TextEditingController _bodyCtrl =
  TextEditingController(text: widget.existing?.body ?? '');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _publish() {
    final title = _titleCtrl.text.trim();
    final body  = _bodyCtrl.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Title and content cannot be empty.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    if (widget.existing == null) {
      AppState.instance.addPost(PlantPost(
        id: 'post${DateTime.now().millisecondsSinceEpoch}',
        author: 'You',
        avatar: 'E',
        title: title,
        body: body,
        timeAgo: 'Just now',
        likes: 0,
        comments: 0,
      ));
    } else {
      AppState.instance.updatePost(widget.existing!, title, body);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isCreate = widget.existing == null;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(isCreate ? 'Create Post' : 'Edit Post',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _publish,
            child: Text(isCreate ? 'Publish' : 'Save',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Title',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider)),
            child: TextField(
              controller: _titleCtrl,
              maxLength: 80,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              decoration: const InputDecoration(
                hintText: 'Give your post a title…',
                hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                counterText: '',
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Content',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider)),
            child: TextField(
              controller: _bodyCtrl,
              maxLines: 8,
              maxLength: 500,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              decoration: const InputDecoration(
                hintText: 'Share your plant story, tip, or question…',
                hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                counterText: '',
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _publish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isCreate ? 'Publish' : 'Save Changes',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// FILTER SHEET
// ════════════════════════════════════════════════════════════════
class _FilterSheet extends StatefulWidget {
  final String current;
  final ValueChanged<String> onApply;
  const _FilterSheet({required this.current, required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _sel;
  static const _opts = [
    'All Items',
    'Discounted Only',
    'Price: Low to High',
    'Price: High to Low',
    'Highest Rated',
  ];

  @override
  void initState() {
    super.initState();
    _sel = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter & Sort',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 14),
            ..._opts.map((o) => InkWell(
              onTap: () => setState(() => _sel = o),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.divider))),
                child: Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _sel == o
                                ? AppColors.primaryDark
                                : AppColors.navInactive,
                            width: 2)),
                    child: _sel == o
                        ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryDark),
                        ))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(o,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textDark)),
                ]),
              ),
            )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onApply(_sel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ]),
    );
  }
}