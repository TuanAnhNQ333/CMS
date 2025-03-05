import 'dart:convert';
import 'package:club_app/config/constants.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class ClubService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Map<String, dynamic>> fetchClubs() async {

    print("Fetching clubs...");
    const url = '$endPoint/graphql';

    const query = '''
      query {
        getClubs {
          id
          name
          description
          imageUrl
          createdBy {
            id
            name
            email
            role
            photoUrl
          }
          members {
            id
            name
            email
            role
            photoUrl
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
      return Future.error('Failed to fetch clubs');

    }
  }

  Future<Map<String, dynamic>> addMembersToClub(clubId, userEmail) async {

    print("Adding to club...");
    print("clubId: $clubId, userEmail: $userEmail");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        addToClub(clubId: "$clubId", userEmail: "$userEmail") {
          id
          name
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
      return Future.error('Failed to add members to club');
    }
  }

  Future<Map<String, dynamic>> removeMembersFromClub(clubId, userEmail) async {

    print("Removing from club...");
    print("clubId: $clubId, userEmail: $userEmail");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        removeFromClub(clubId: "$clubId", userEmail: "$userEmail") {
          id
          name
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
      return Future.error('Failed to remove members from club');
    }
  }

  Future<Map<String, dynamic>> updateClubInfo(id, name, description, imageUrl) async {

    print("Creating posts...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        updateClub(id: "$id", name: "$name", description: "$description", imageUrl: "$imageUrl") {
          id
          name
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
      return Future.error('Failed to update club');
    }
  }

  Future<Map<String, dynamic>> createNewClub(name, description, imageUrl, createdBy) async {

    print("Creating posts...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        createClub(name: "$name", description: "$description", imageUrl: "$imageUrl", createdBy: "$createdBy") {
          id
          name
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
      return Future.error('Failed to create new club');
    }
  }

  Future<Map<String, dynamic>> deleteClub(id) async {

    print("Creating posts...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        deleteClub(id: "$id")
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
      return Future.error('Failed to delete club');
    }
  }



}