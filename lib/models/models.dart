class PlantProduct {
  final String id;
  final String category;
  final String name;
  final double price;
  final bool hasDiscount;
  final double rating;
  final int reviewCount;
  final String image;
  final String description;
  bool isWishlisted;

  PlantProduct({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    this.hasDiscount = false,
    this.rating = 4.5,
    this.reviewCount = 120,
    required this.image,
    this.description = '',
    this.isWishlisted = false,
  });

  double get discountedPrice => price * 0.5;
  double get activePrice => hasDiscount ? discountedPrice : price;
}

class PlantService {
  final String id;
  final String name;
  final String description;
  final double price;
  final String duration;
  final double rating;
  final String image;

  const PlantService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
    this.rating = 4.7,
  });
}

class PlantPost {
  final String id;
  final String author;
  final String avatar;
  String title;    // mutable — user can edit their own posts
  String body;     // mutable — user can edit their own posts
  final String timeAgo;
  int likes;
  int comments;
  bool isLiked;
  List<PostComment> commentList;

  PlantPost({
    required this.id,
    required this.author,
    required this.avatar,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    this.isLiked = false,
    List<PostComment>? commentList,
  }) : commentList = commentList ?? [];
}

class PostComment {
  final String id;
  final String author;
  final String avatar;
  String text;
  final String timeAgo;

  PostComment({
    required this.id,
    required this.author,
    required this.avatar,
    required this.text,
    required this.timeAgo,
  });
}

class InboxMessage {
  final String id;
  final String sender;
  final String avatarInitials;
  final String subject;
  final String preview;
  final String timeAgo;
  final bool isNotification;
  bool isRead;
  List<ChatMessage> thread;

  InboxMessage({
    required this.id,
    required this.sender,
    required this.avatarInitials,
    required this.subject,
    required this.preview,
    required this.timeAgo,
    this.isNotification = false,
    this.isRead = false,
    List<ChatMessage>? thread,
  }) : thread = thread ?? [];
}

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class DiscoverItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final double rating;
  final String image;
  bool isFavourite;

  DiscoverItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.rating,
    required this.image,
    this.isFavourite = false,
  });
}

class BookingFormData {
  String name;
  String phone;
  String date;
  String time;
  String address;
  String notes;

  BookingFormData({
    this.name = '',
    this.phone = '',
    this.date = '',
    this.time = '',
    this.address = '',
    this.notes = '',
  });
}
