// lib/data/models/user_profile_model.dart

class UserProfileModel {
  final int? id;
  final int userId;
  final String? email;
  final String? nickname;
  final String? description;
  final String? profileImageUrl;
  final String? role; // 'store_owner' or 'restocker'
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    this.id,
    required this.userId,
    this.email,
    this.nickname,
    this.description,
    this.profileImageUrl,
    this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id_user'] as int?,
      userId: json['id_user'] as int,
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      description: json['description'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      role: json['role'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_user': id,
      'id_user': userId,
      if (email != null) 'email': email,
      'nickname': nickname,
      if (description != null) 'description': description,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (role != null) 'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    int? id,
    int? userId,
    String? email,
    String? nickname,
    String? description,
    String? profileImageUrl,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      description: description ?? this.description,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
