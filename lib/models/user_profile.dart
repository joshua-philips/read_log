import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  String userName;
  String email;
  String uid;
  String profilePhoto;

  UserProfile({
    required this.userName,
    required this.email,
    required this.uid,
    required this.profilePhoto,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['userName'],
      email: json['email'],
      uid: json['uid'],
      profilePhoto: json['profilePhoto'],
    );
  }

  factory UserProfile.noValues() {
    return UserProfile(
      email: '',
      profilePhoto: '',
      uid: '',
      userName: '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['uid'] = this.uid;
    data['profilePhoto'] = this.profilePhoto;
    return data;
  }

  void updateEntireProfile(Map<String, dynamic> data) {
    this.userName = data['userName'];
    this.email = data['email'];
    this.uid = data['uid'];
    this.profilePhoto = data['profilePhoto'];
    notifyListeners();
  }
}
