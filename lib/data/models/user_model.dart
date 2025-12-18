// lib/data/models/user_model.dart

class UserProfile {
  final String userId;
  final String email;
  final String username;
  final String nickname;
  final String description;
  final String? profilePic; // Sesuai dengan kolom DB: profilepic

  UserProfile({
    required this.userId,
    required this.email,
    required this.username,
    required this.nickname,
    required this.description,
    this.profilePic,
  });

  // Factory constructor untuk membuat objek UserProfile dari Map (respons database)
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      // Pastikan nama key sesuai dengan skema DB Anda
      userId: data['id_user'].toString(), // id_user adalah int8, ubah ke String
      email: data['email'] as String,
      username: data['username'] as String,
      nickname: data['nickname'] ?? 'User', // Fallback jika null
      description: data['description'] ?? 'No Description', // Fallback jika null
      profilePic: data['profile_image_url'] as String?, // Memetakan kolom 'profilepic'
    );
  }

  // Metode untuk mengubah objek menjadi Map (digunakan saat Update/Insert)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'nickname': nickname,
      'description': description,
      'profile_image_url': profilePic, // Gunakan nama kolom DB 'profilepic'
    };
  }
}

class UserModel {
  final int idUser;
  final String email;
  final String username;
  final String password;
  final String nickname;
  final String description;
  final String profilePic;

  UserModel({
    required this.idUser,
    required this.email,
    required this.username,
    required this.password,
    required this.nickname,
    required this.description,
    required this.profilePic,
  });

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['idUser'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      nickname: json['nickname'] ?? '',
      description: json['description'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'email': email,
      'username': username,
      'password': password,
      'nickname': nickname,
      'description': description,
      'profilePic': profilePic,
    };
  }

  // Create a copy with modified fields
  UserModel copyWith({
    int? idUser,
    String? email,
    String? username,
    String? password,
    String? nickname,
    String? description,
    String? profilePic,
  }) {
    return UserModel(
      idUser: idUser ?? this.idUser,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      description: description ?? this.description,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  String toString() {
    return 'UserModel(idUser: $idUser, email: $email, username: $username, nickname: $nickname)';
  }
}