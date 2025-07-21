import 'package:cloud_firestore/cloud_firestore.dart';

class RentalRequest {
  final String id;
  final String userid;
  final String userName;
  final String bookTitle;
  final bool isAccepted;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;

  RentalRequest({
    required this.id,
    required this.userid,
    required this.userName,
    required this.bookTitle,
    required this.isAccepted,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
  });

  factory RentalRequest.fromfirestore(String id, Map<String, dynamic> map) {
    return RentalRequest(
      id: id,
      userid: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      isAccepted: map['isAccepted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'userId': userid,
      'bookTitle': bookTitle,
      'isAccepted': isAccepted,
      'createdAt': Timestamp.fromDate(createdAt),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
    };
  }
}
