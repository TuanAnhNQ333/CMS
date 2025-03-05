
class UnreadPosts {

  UnreadPosts({
    required this.postId,
    required this.clubId,
  });

  final String postId;
  final String clubId;

  factory UnreadPosts.fromJson(Map<String, dynamic> json) {
    return UnreadPosts(
      postId: json['postId'],
      clubId: json['ClubId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "ClubId": clubId,
  };

}
