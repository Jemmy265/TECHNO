import 'package:cloud_firestore/cloud_firestore.dart';

class MyComment {
  String id;
  String content;
  String imagePath;
  String name;

  MyComment({
    required this.id,
    required this.content,
    required this.name,
    this.imagePath = '',
  });

  factory MyComment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return MyComment(
      id: doc.id,
      content: data['content'] as String,
      name: data['name'] as String,
      imagePath: data['imagePath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'name': name,
      'imagePath': imagePath,
    };
  }
}
