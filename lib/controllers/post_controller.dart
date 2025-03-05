
import 'package:club_app/secrets.dart';
import 'package:club_app/utils/repositories/image_repository.dart';
import 'package:club_app/utils/repositories/post_repository.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import 'package:aws_client/s3_2006_03_01.dart';

import 'image_picker_controller.dart';
import 'package:intl/intl.dart';

import 'network_controller.dart';

class PostController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    final networkController = Get.find<NetworkController>();
    networkController.isOnline.value ?
    fetchPosts() : fetchPostsFromSharedPrefs();
  }

  final imagePickerController = Get.put(ImagePickerController());
  var postList = <Post>[].obs;

  Future<void> fetchPosts() async {
    postList.value = await PostRepository().fetchPosts();
    await SharedPrefs.savePost(postList);
    update();
  }

  void fetchPostsFromSharedPrefs() async {
    postList.value = await SharedPrefs.getPost();
    update();
  }

  Future<Map<String, dynamic>> createPost(context, content, createdBy, club) async {
    final dateTime = DateTime.now();
    final formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm').format(dateTime);
    var imageUrl = '';
    if (imagePickerController.image != null) {
      imageUrl = await ImageRepository().uploadImage(imagePickerController.image!);
    }
    try{
      postList.add(await PostRepository().createPost(content, imageUrl, createdBy, formattedDateTime, club));
      update();
      return {'status': 'ok', 'message': 'Post created successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePost(context, postId, content) async {

    try{
      postList.value = await PostRepository().updatePost(postId, content);
      update();
      return {'status': 'ok', 'message': 'Post updated successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }

  }

  Future<Map<String, dynamic>> deletePost(context, postId) async {
    try{
      postList.value = await PostRepository().deletePost( postId);
      update();
      return {'status': 'ok', 'message': 'Post deleted successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }

  }


  Future<void> checkAwsCredentials() async {
    final credentials = AwsClientCredentials(accessKey: AWS_ACCESS_KEY, secretKey: AWS_SECRET_KEY);
    final s3 = S3(region: 'ap-south-1', credentials: credentials); // e.g., 'us-west-2'

    try {
      final response = await s3.listBuckets();
      Bucket bucket = response.buckets!.first;
      print('AWS credentials are valid. Buckets: ${bucket.name}');
    } catch (e) {
      print('Failed to list buckets: $e');
    }
  }

}