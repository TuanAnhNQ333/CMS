
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../config/constants.dart';
import '../shared_prefs.dart';
import 'package:http/http.dart' as http;

class FeedbackService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }


  Future<Map<String, dynamic>> fetchFeedbackForms(List<String> userClubs) async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    final query = '''
      query {
        getFeedbacks (userClubs: [${userClubs.map((e) => '"$e"').join(',')}]) {
          id
          questions {
            question
            rating
          }
          event {
            id
            name
          }
          comments
          club {
            id
            name
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      if(kDebugMode) {
        print("POST request successful");
        print('Response: ${response.body}');
      }
      return jsonDecode(response.body);

    } else {
      if (kDebugMode) {
        print("POST request failed");
        print('Response: ${response.body}');
      }
      return Future.error('Failed to fetch feedbacks');
    }
  }

  Future<Map<String, dynamic>> uploadFeedback(id, ratingList, suggestion) async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        uploadFeedback(id: "$id", ratingList: $ratingList, comment: "$suggestion") {
          id
          questions {
            question
            rating
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      if(kDebugMode) {
        print("POST request successful");
        print('Response: ${response.body}');
      }
      return jsonDecode(response.body);

    } else {
      if (kDebugMode) {
        print("POST request failed");
        print('Response: ${response.body}');
      }
      return Future.error('Failed to upload feedback');
    }
  }

  Future<Map<String, dynamic>> createFeedbackForm(eventId, clubId, List<String> questionList) async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        createFeedbackForm(event: "$eventId", club: "$clubId", questions: [${questionList.map((e) => '"$e"').join(',')}]) {
          id
          event {
            id
            name
          }
          club {
            id
            name
          }
          questions {
            question
            rating
          }
          comments
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      if(kDebugMode) {
        print("POST request successful");
        print('Response: ${response.body}');
      }
      return jsonDecode(response.body);

    } else {
      if (kDebugMode) {
        print("POST request failed");
        print('Response: ${response.body}');
      }
      return Future.error('Failed to upload feedback');
    }
  }

  Future<Map<String, dynamic>> deleteFeedbackForm(id) async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        deleteFeedback(id: "$id") 
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      if(kDebugMode) {
        print("POST request successful");
        print('Response: ${response.body}');
      }
      return jsonDecode(response.body);

    } else {
      if (kDebugMode) {
        print("POST request failed");
        print('Response: ${response.body}');
      }
      return Future.error('Failed to delete feedback');
    }
  }


}