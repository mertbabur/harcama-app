import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  getLatestReview(String email) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }
}
