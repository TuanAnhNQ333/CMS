
import 'package:club_app/models/post_model.dart';
import '../network_services/post_service.dart';
import '/controllers/network_controller.dart';
import 'package:get/get.dart';

class PostRepository {
  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<List<Post>> fetchPosts() async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data = await PostService().fetchPosts();
      final posts = (data['data'])['getPosts'];
      final postList = posts.map<Post>((post) => Post.fromJson(post)).toList();
      return postList;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Post> createPost(
      content, imageUrl, createdBy, dateCreated, club) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data = await PostService()
          .createPost(content, imageUrl, createdBy, dateCreated, club);

      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }

      final post = (data['data'])['createPost'];
      return Post.fromJson(post);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Post>> updatePost(id, content) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
          await PostService().updatePost(id, content);

      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }

      return fetchPosts();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Post>> deletePost(id) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data = await PostService().deletePost(id);

      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }

      return fetchPosts();
    } catch (e) {
      return Future.error(e);
    }
  }
}
