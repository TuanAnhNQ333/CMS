import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/screens/club_info_page.dart';
import 'package:club_app/widgets/app_widgets/bottom_message_bar.dart';
import 'package:club_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/image_picker_controller.dart';
import '../controllers/loading_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/profile_controller.dart';

import '../widgets/app_widgets/post_widget.dart';

class ClubPage extends StatelessWidget {
  ClubPage({super.key, required this.clubName, required this.clubId});

  final postController = Get.put(PostController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final imagePickerController = Get.put(ImagePickerController());
  final loadingController = Get.put(LoadingController());


  final String clubName;
  final String clubId;

  final contentText = TextEditingController();

  // Future<void> createPost(context) async {
  //   await postController.createPost(context, contentText.text,
  //       profileController.currentUser.value.id, clubId);
  //   contentText.text = '';
  //   imagePickerController.resetImage();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(clubName),
        // backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // loadingController.toggleLoading();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ClubInfoPage(
                        clubId: clubId,
                      )));
            },
            icon: const Icon(
                Icons.info),
          )
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            List<Widget> postWidgets = postController.postList
                .where((post) => post.clubId == clubId)
                .toList()
                .map((post) =>
                Column(
                  children: [
                    const Divider(),
                    PostWidget(post: post)
                  ],
                ))
                .toList();
            postWidgets.add(const Column(
              children: [
                SizedBox(height: 100),
              ],
            ));

              var club = clubsController.clubList.where((club) => club.id == clubId);
              if(club.isEmpty) {
                return const SizedBox();
              }

            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                        children: postWidgets
                    ),
                  ),
                ),
                clubsController.clubList
                    .where((club) => club.id == clubId)
                    .first
                    .members
                    .any((member) =>
                member.id ==
                    profileController.currentUser.value.id) ||
                    profileController.currentUser.value.role == 'admin'
                    ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomMessageBar(clubId: clubId),
                )
                    : const Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox())

              ],
            );
          }),
          Obx(() {
            return Container(
              child:
              loadingController.isLoading.value
                  ?
              LoadingWidget() : null,
            );
          }),
        ],
      ),
    );
  }
}
