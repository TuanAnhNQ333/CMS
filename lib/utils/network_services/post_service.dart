import 'dart:convert';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';

class PostService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Map<String, dynamic>> fetchPosts() async {

    print("Fetching posts...");
    const url = '$endPoint/graphql';

    const query = fetchPostQuery;

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
      return Future.error('Failed to fetch posts');
    }
  }

  Future<Map<String, dynamic>> createPost(content, imageUrl, createdBy, dateCreated, club) async {

    print("Creating posts...");
    const url = '$endPoint/graphql';

    final query = createPostQuery(content, imageUrl, createdBy, dateCreated, club);

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
      return Future.error('Failed to create post');
    }
  }

  Future<Map<String, dynamic>> updatePost(id, content) async {

    print("Creating posts...");
    const url = '$endPoint/graphql';

    final query = updatePostQuery(id, content);

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
      return Future.error('Failed to update post');
    }
  }

  Future<Map<String, dynamic>> deletePost(id) async {

    print("Creating posts...");
    const url = '$endPoint/graphql';

    print('Postid: $id');

    final query = deletePostQuery(id);

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
      return Future.error('Failed to delete post');
    }
  }
}