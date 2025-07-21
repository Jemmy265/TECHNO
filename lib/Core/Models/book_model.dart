import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String id;
  String desc;
  String imageurl;
  String title;
  String author;
  String publisher;
  num rating;

  Book({
    required this.id,
    required this.desc,
    required this.title,
    required this.author,
    required this.publisher,
    this.imageurl = '',
    required this.rating,
  });

  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Book(
      id: doc.id,
      desc: data['desc'] as String,
      title: data['title'] as String,
      author: data['author'] as String,
      publisher: data['publisher'] as String,
      imageurl: data['imageurl'] as String? ?? '',
      rating: data['rating'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'desc': desc,
      'title': title,
      'imageurl': imageurl,
      'author': author,
      'publisher': publisher,
      'rating': rating,
    };
  }
}
