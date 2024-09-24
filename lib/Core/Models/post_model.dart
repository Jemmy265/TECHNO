import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String content;
  String imagePath;
  String name;
  int likesCount;
  List<dynamic> likes;

  Post({
    required this.id,
    required this.content,
    required this.name,
    this.imagePath = '',
    this.likesCount = 0,
    this.likes = const [],
  });

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Post(
      id: doc.id,
      content: data['content'] as String,
      name: data['name'] as String,
      imagePath: data['imagePath'] as String? ?? '',
      likesCount: data['likes_count'],
      likes: data['likes'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'name': name,
      'imagePath': imagePath,
      'likes_count': likesCount,
      'likes': likes,
    };
  }
}
