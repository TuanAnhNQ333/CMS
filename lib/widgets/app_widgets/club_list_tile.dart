import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/unread_post_controller.dart';
import '../../models/club_model.dart';
import '../../models/post_model.dart';
import '../../screens/club_page.dart';
import '../../utils/shared_prefs.dart';

class ClubListTile extends StatefulWidget {
  const ClubListTile({
    super.key,
    required this.club,
  });

  final Club club;

  @override
  State<ClubListTile> createState() => _ClubListTileState();
}

class _ClubListTileState extends State<ClubListTile>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unreadPostController.getUnreadPosts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final unreadPosts = await SharedPrefs.getUnreadPosts();
      await unreadPostController.getUnreadPosts();
    }
  }

  final postController = Get.put(PostController());
  final unreadPostController = Get.find<
      UnreadPostController>(); // Use Get.find to get the existing instance


  Post get lastPost {
    var posts = postController.postList.where((post) =>
    post.clubId == widget.club.id);
    if (posts.isNotEmpty) {
      return posts.last;
    } else {
      return Post(
          id: '',
          content: '',
          dateCreated: '',
          imageUrl: '',
          clubId: '',
          clubName: '',
          createdBy: UserModel(
              id: '',
              email: '',
              name: '',
              role: '',
              photoUrl: '')); // return a default Post
    }
  }

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;
    // getUnreadPosts();

    return InkWell(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ClubPage(
                  clubName: widget.club.name,
                  clubId: widget.club.id,
                )));

        await unreadPostController.removeUnreadPost(widget.club.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: CachedNetworkImage(
                imageUrl: widget.club.imageUrl,
                fit: BoxFit.cover,
                width: 47,
                height: 47,
              )),
          title: Row(
            children: [
              Expanded(
                  child:
                  Text(
                      widget.club.name,
                      // style: TextStyle(color: Colors.black)
                  )
              ),

              Obx(() {
                return SizedBox(
                  child: unreadPostController.unreadPostList
                      .where((post) => post.clubId == widget.club.id).isEmpty ? Container() :

                  Container(
                      padding: const EdgeInsets.all(2),
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50)),

                      child:
                      Align(
                        alignment: Alignment.center,
                        child: Obx(() {
                          return Text(
                              unreadPostController.unreadPostList
                                  .where((post) =>
                              post.clubId == widget.club.id)
                                  .length
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor));
                        }),
                      )
                  ),
                );
              }),
            ],
          ),
          subtitle: Text(lastPost.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: currentColors.tertiaryTextColor
              )),
        ),
      ),
    );
  }
}
