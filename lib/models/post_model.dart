
import 'package:club_app/models/user_model.dart';
import 'package:intl/intl.dart';

class Post {

  final String id;
  final String content;
  final String dateCreated;
  final String imageUrl;
  final String clubId;
  final String clubName;
  final UserModel createdBy;

  String get formattedDateTime {
    final timestamp = int.parse(dateCreated);
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM |').add_jm().format(dateTime);
  }

  Post({
    required this.id,
    required this.content,
    required this.dateCreated,
    required this.imageUrl,
    required this.clubId,
    required this.clubName,
    required this.createdBy,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      dateCreated: json['dateCreated'],
      imageUrl: json['imageUrl'],
      clubId: json['club']['id'],
      clubName: json['club']['name'],
      createdBy: UserModel.fromJson(json['createdBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'dateCreated': dateCreated,
      'imageUrl': imageUrl,
      'club': {
        'id': clubId,
        'name': clubName,
      },
      'createdBy': createdBy.toJson(),
    };
  }

}


