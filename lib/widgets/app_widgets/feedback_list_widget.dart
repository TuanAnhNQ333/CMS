
import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/screens/feedback_response_page.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/feedback_controller.dart';
import '../../controllers/loading_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../screens/feedback_page.dart';
import '../custom_popup_menu_item.dart';
import '../custom_snackbar.dart';
import '../loading_widget.dart';

class FeedbackListWidget extends StatelessWidget {
  FeedbackListWidget({super.key});

  final feedbackController = Get.put(FeedbackController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());

  Offset? _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> deleteFeedbackForm(context, String feedbackId) async {
    loadingController.toggleLoading();
    final result = await feedbackController.deleteFeedbackForm(feedbackId);
    loadingController.toggleLoading();
    if (result['status'] == 'error') {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.red);
    } else {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: feedbackController.feedbackList.length,
                itemBuilder: (context, index) {
                  bool isAuthorized() {
                    return profileController.currentUser.value.role == 'admin' ||
                        clubsController.clubList
                            .where((club) =>
                                club.id ==
                                feedbackController.feedbackList[index].clubId)
                            .first
                            .members
                            .any((member) =>
                                member.id ==
                                profileController.currentUser.value.id);
                  }

                  return Card(
                    child: InkWell(
                      onTapDown: (details) {
                        _storePosition(details);
                      },
                      onLongPress: () async {
                        final RenderBox overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;
                        await buildShowMenu(context, overlay, feedbackController.feedbackList[index].id);
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FeedbackPage(
                                feedbackForm:
                                    feedbackController.feedbackList[index])));
                      },
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              imageUrl: clubsController.clubList
                                  .where((club) =>
                                      club.id ==
                                      feedbackController.feedbackList[index].clubId)
                                  .first
                                  .imageUrl),
                        ),
                        trailing: isAuthorized()
                            ? ButtonWidget(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FeedbackResponsePage(
                                            feedbackId: feedbackController
                                                .feedbackList[index].id,
                                          )));
                                },
                                buttonText: 'View',
                                isNegative: false)
                            : const Icon(Icons.arrow_forward_ios),
                        title:
                            Text(feedbackController.feedbackList[index].eventName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                )),
                        subtitle:
                            Text(feedbackController.feedbackList[index].clubName),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
        Obx(() {
          return Container(
            child: loadingController.isLoading.value ? LoadingWidget() : null,
          );
        }),
      ],
    );
  }

  Future<dynamic> buildShowMenu(BuildContext context, RenderBox overlay, String feedbackId) {
    return showMenu(
      context: context,
      elevation: 5,
      // color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      position: RelativeRect.fromLTRB(
        _tapPosition!.dx,
        _tapPosition!.dy,
        overlay.size.width - _tapPosition!.dx,
        overlay.size.height - _tapPosition!.dy,
      ),
      items: <PopupMenuEntry>[
        CustomPopupMenuItem(
            title: 'Delete',
            icon: Icons.delete,
            color: Colors.red,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (dialogueContext) {
                    return CustomAlertDialogue(
                        context: dialogueContext,
                        onPressed: () {
                          Navigator.of(dialogueContext).pop();
                          deleteFeedbackForm(context, feedbackId);
                        },
                        title: 'Confirm delete',
                        content:
                            'Are you sure you want to delete this feedback form?');
                  });
            }),
        // delete post
      ],
    );
  }
}
