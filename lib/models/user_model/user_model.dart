class UserModel {
  const UserModel({
    this.name,
    this.email,
    this.photoUrl,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        uid: json['uid']);
  }

  final String? name;
  final String? email;
  final String? photoUrl;
  final String uid;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'uid': uid,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
    );
  }
}
