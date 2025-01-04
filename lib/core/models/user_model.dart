import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String  userName,  userEmail;
  final Timestamp createdAt;
  
  UserModel({
    required this.userName,
    required this.userEmail,
    required this.createdAt,
  });
  
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userName: data['userName'],
      userEmail: data['userEmail'],
      createdAt: data['createdAt'],
    );
  }
}
