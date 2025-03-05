import 'package:club_app/models/unread_post_list_model.dart';
import 'package:get/get.dart';

import '../utils/shared_prefs.dart';

class UnreadPostController extends GetxController {

  final unreadCount = 0.obs;
  final unreadPostList = <UnreadPosts>[].obs;

  Future<void> addUnreadPost(String postId, String clubId) async {
    unreadPostList.add(UnreadPosts(postId: postId, clubId: clubId));
    unreadCount.value = unreadPostList.length;
    await SharedPrefs.setUnreadPosts(unreadPostList);
    update();
  }

  Future<void> getUnreadPosts() async {
    final unreadPosts = await SharedPrefs.getUnreadPosts();
    unreadPostList.assignAll(unreadPosts);
    unreadCount.value = unreadPostList.length;
    update();
  }

  Future<void> removeUnreadPost(String clubId) async {
    unreadPostList.removeWhere((element) => element.clubId == clubId);
    unreadCount.value = unreadPostList.length;
    await SharedPrefs.setUnreadPosts(unreadPostList);
    update();
  }


}