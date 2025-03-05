
import 'package:intl/intl.dart';

class EventModel{
  final String id;
  final String name;
  final String description;
  final String date;
  final String bannerUrl;
  final String location;
  final String clubId;
  final String clubName;
  final String clubImageUrl;

  DateTime get dateTime {
    final timestamp = int.parse(date);
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  String get formattedDate {
    final timestamp = int.parse(date);
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM').format(dateTime);
  }

  String get formattedTime {
    final timestamp = int.parse(date);
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.jm().format(dateTime);
  }

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.bannerUrl,
    required this.location,
    required this.clubId,
    required this.clubName,
    required this.clubImageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'],
      bannerUrl: json['bannerUrl'],
      location: json['location'],
      clubId: json['club']['id'],
      clubName: json['club']['name'],
      clubImageUrl: json['club']['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
      'bannerUrl': bannerUrl,
      'location': location,
      'club': {
        'id': clubId,
        'name': clubName,
        'imageUrl': clubImageUrl,
      },
    };
  }


}