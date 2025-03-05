class UserModel{
  final String id;
  final String email;
  final String name;
  final String role;
  final String photoUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.photoUrl
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      photoUrl: json['photoUrl']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
    'photoUrl': photoUrl
  };

}