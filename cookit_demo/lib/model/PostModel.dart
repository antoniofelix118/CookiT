import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imageUrl;
  final String description;
  final String username;
  final String email;

  Post({
    this.id,
    this.imageUrl,
    this.description,
    this.username,
    this.email,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      description: doc['description'],
      username: doc['username'],
      email: doc['email'],

    );
  }
}
