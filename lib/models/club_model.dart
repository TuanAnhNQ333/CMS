import 'package:club_app/models/user_model.dart';

class Club{
  final String id;
  final String name;
  final String description;
  final UserModel createdBy;
  final String imageUrl;
  final List<UserModel> members;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.imageUrl,
    required this.members,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: UserModel.fromJson(json['createdBy']),
      imageUrl: json['imageUrl'],
      members: json['members'].map<UserModel>((member) => UserModel.fromJson(member)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy.toJson(),
      'imageUrl': imageUrl,
      'members': members.map((member) => member.toJson()).toList(),
    };
  }

}