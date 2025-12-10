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
      profilePic: data['profilepic'] as String?, // Memetakan kolom 'profilepic'
    );
  }

  // Metode untuk mengubah objek menjadi Map (digunakan saat Update/Insert)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'nickname': nickname,
      'description': description,
      'profilepic': profilePic, // Gunakan nama kolom DB 'profilepic'
    };
  }
}