import 'package:flutter/material.dart';
import 'mock_data.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────
// AppState — single source of truth for:
//   • Profile (name, email, phone)
//   • Posts
//   • Inbox messages (DMs from Posts sync here)
//   • Wishlist
//   • Cart
//   • Favourites (Discover)
// Every screen reads from here → all screens stay in sync.
// ─────────────────────────────────────────────────────────────

class CartLine {
  final String id;
  final String name;
  final String category;
  final double price;
  int qty;
  CartLine({required this.id, required this.name,
    required this.category, required this.price, required this.qty});
}

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  // ── Profile ────────────────────────────────────────────────
  String profileName  = 'Ema';
  String profileEmail = 'ftmhazzhraa3011@email.com';
  String profilePhone = '+60 12-345 6789';

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    profileName  = name;
    profileEmail = email;
    profilePhone = phone;
    notifyListeners();
  }

  // ── Posts ──────────────────────────────────────────────────
  // All screens that show posts read from this list
  final List<PlantPost> posts = List.from(MockData.posts);

  void addPost(PlantPost p) {
    posts.insert(0, p);
    notifyListeners();
  }

  void updatePost(PlantPost p, String title, String body) {
    p.title = title;
    p.body  = body;
    notifyListeners();
  }

  void deletePost(PlantPost p) {
    posts.remove(p);
    notifyListeners();
  }

  void togglePostLike(PlantPost p) {
    p.isLiked = !p.isLiked;
    p.isLiked ? p.likes++ : p.likes--;
    notifyListeners();
  }

  // ── Inbox messages ─────────────────────────────────────────
  // This is the authoritative list; InboxScreen reads from here.
  final List<InboxMessage> inboxMessages = MockData.messages;

  int get unreadCount =>
      inboxMessages.where((m) => !m.isRead && !m.isNotification).length;

  // Called by _DirectMessageScreen when user sends the first message
  // to a post author — creates a new thread in Inbox automatically.
  void addOrUpdateDirectMessage({
    required String authorName,
    required String authorAvatar,
    required String firstMessage,
  }) {
    // Check if a thread with this person already exists
    final existing = inboxMessages
        .where((m) =>
            !m.isNotification && m.sender == authorName)
        .toList();

    if (existing.isNotEmpty) {
      // Update preview text and mark unread
      final thread = existing.first;
      thread.thread.add(ChatMessage(
        id: 'dm${DateTime.now().millisecondsSinceEpoch}',
        text: firstMessage,
        isMe: true,
        time: 'Just now',
      ));
      notifyListeners();
    } else {
      // Create brand-new inbox thread
      final newMsg = InboxMessage(
        id: 'dm${DateTime.now().millisecondsSinceEpoch}',
        sender: authorName,
        avatarInitials: authorAvatar,
        subject: 'New conversation',
        preview: firstMessage,
        timeAgo: 'Just now',
        isRead: false,
        isNotification: false,
        thread: [
          // Seed reply from them
          ChatMessage(
            id: 'seed${DateTime.now().millisecondsSinceEpoch}',
            text: 'Hi! Thanks for reaching out. Happy to chat about plants!',
            isMe: false,
            time: 'Just now',
          ),
          // First message from user
          ChatMessage(
            id: 'dm${DateTime.now().millisecondsSinceEpoch}',
            text: firstMessage,
            isMe: true,
            time: 'Just now',
          ),
        ],
      );
      inboxMessages.insert(0, newMsg);
      notifyListeners();
    }
  }

  // ── Wishlist ───────────────────────────────────────────────
  final Set<String> _wishlisted = {'p2', 'p4'};

  bool isWishlisted(String id) => _wishlisted.contains(id);

  void toggleWishlist(PlantProduct product) {
    if (_wishlisted.contains(product.id)) {
      _wishlisted.remove(product.id);
      product.isWishlisted = false;
    } else {
      _wishlisted.add(product.id);
      product.isWishlisted = true;
    }
    notifyListeners();
  }

  List<PlantProduct> get wishlistItems =>
      MockData.products.where((p) => _wishlisted.contains(p.id)).toList();

  // ── Cart ───────────────────────────────────────────────────
  final List<CartLine> _cart = [
    CartLine(id:'p1', name:'Monstera Deliciosa',
        category:'Indoor Plants', price:100.00, qty:1),
    CartLine(id:'p3', name:'Bird of Paradise',
        category:'Outdoor Plants', price:100.00, qty:2),
  ];

  List<CartLine> get cartItems => List.unmodifiable(_cart);

  double get cartTotal =>
      _cart.fold(0, (sum, i) => sum + i.price * i.qty);

  bool inCart(String id) => _cart.any((c) => c.id == id);

  void addToCart(PlantProduct p) {
    final existing = _cart.where((c) => c.id == p.id).toList();
    if (existing.isNotEmpty) {
      existing.first.qty++;
    } else {
      _cart.add(CartLine(id: p.id, name: p.name,
          category: p.category, price: p.activePrice, qty: 1));
    }
    notifyListeners();
  }

  void incrementCart(String id) {
    final line = _cart.firstWhere((c) => c.id == id, orElse: () => _cart[0]);
    line.qty++;
    notifyListeners();
  }

  void decrementCart(String id) {
    final idx = _cart.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    if (_cart[idx].qty > 1) {
      _cart[idx].qty--;
    } else {
      _cart.removeAt(idx);
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // ── Favourites (Discover) ──────────────────────────────────
  final Set<String> _favDiscover = {};

  bool isFavDiscover(String id) => _favDiscover.contains(id);

  void toggleFavDiscover(DiscoverItem item) {
    if (_favDiscover.contains(item.id)) {
      _favDiscover.remove(item.id);
      item.isFavourite = false;
    } else {
      _favDiscover.add(item.id);
      item.isFavourite = true;
    }
    notifyListeners();
  }

  List<DiscoverItem> get favouriteDiscoverItems =>
      MockData.discoverItems.where((d) => _favDiscover.contains(d.id)).toList();
}
