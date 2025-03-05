class FeedbackModel {
  final String id;
  final String eventId;
  final String eventName;
  final String clubId;
  final String clubName;
  final List<String> comments;
  final List<Question> questions;

  FeedbackModel(
      {required this.id,
      required this.eventId,
        required this.eventName,
      required this.clubId,
        required this.clubName,
      required this.comments,
      required this.questions});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      eventId: json['event']['id'],
      eventName: json['event']['name'],
      clubId: json['club']['id'],
      clubName: json['club']['name'],
      comments: List<String>.from(json['comments']),
      questions: List<Question>.from(json['questions'].map((x) => Question.fromJson(x))),
    );
  }

}

class Question {
  final String question;
  final List<int> rating;

  Question({required this.question, required this.rating});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      rating: List<int>.from(json['rating']),
    );
  }

}
