import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/edit_club_dialogue.dart';
import 'package:club_app/widgets/app_widgets/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/image_picker_controller.dart';
import '../controllers/loading_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';
import '../widgets/dialogue_widgets/custom_alert_dialogue.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/loading_widget.dart';

class ClubInfoPage extends StatelessWidget {
  ClubInfoPage({super.key, required this.clubId});

  final String clubId;

  final clubsController = Get.put(ClubsController());
  final imagePickerController = Get.put(ImagePickerController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());

  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
    return currentUser.role == 'admin' ||
        clubsController.clubList
            .where((club) => club.id == clubId)
            .first
            .members
            .any((member) => member.id == currentUser.id);
  }

  final isDescriptionExpanded = false.obs;

  void showEditClubDialogue(context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: 'Edit Club Info',
        context: context,
        pageBuilder: (context, _, __) => PopScope(
            onPopInvoked: (bool didPop) {
              if (didPop) {
                imagePickerController.resetImage();
              }
            },
            child: EditClubDialogue(
              clubId: clubId,
            )));
  }

  Future<void> deleteClub(context) async {
    // Delete club
    final result = await clubsController.deleteClub(clubId);
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Club Info'),
            actions: [
              !isAuthorized
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonWidget(
                          onPressed: () => showEditClubDialogue(context),
                          buttonText: 'Edit info',
                          preceedingIcon: Icons.edit,
                          isNegative: false,),
                    )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(65),
                    child: Obx(() {
                      var club = clubsController.clubList.where((club) => club.id == clubId);
                      if(club.isEmpty) {
                        return const SizedBox();
                      }
                      return CachedNetworkImage(
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          imageUrl: clubsController.clubList
                              .where((club) => club.id == clubId)
                              .first
                              .imageUrl);
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: GetBuilder<ClubsController>(builder: (logic) {
                  var club = clubsController.clubList.where((club) => club.id == clubId);
                  if(club.isEmpty) {
                    return const SizedBox();
                  }
                  return Text(
                    textAlign: TextAlign.center,
                    clubsController.clubList
                        .where((club) => club.id == clubId)
                        .first
                        .name,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Obx(() {
                var club = clubsController.clubList.where((club) => club.id == clubId);
                if(club.isEmpty) {
                  return const SizedBox();
                }
                return InkWell(
                  onTap: () {
                    isDescriptionExpanded.value = !isDescriptionExpanded.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GetBuilder<ClubsController>(builder: (logic) {
                          return const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                        LinkifyText(
                          clubsController.clubList
                              .where((club) => club.id == clubId)
                              .first
                              .description,
                          maxLines: isDescriptionExpanded.value ? 10 : 2,
                          overflow: isDescriptionExpanded.value
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          onTap: (link) async {
                            if (link.type == LinkType.url) {
                              final Uri url = Uri.parse('${link.value}');
                              if (!await launchUrl(url)) {
                                CustomSnackBar.show(context,
                                    message:
                                    'Could not launch ${link.value}',
                                    color: Colors.red);
                                throw Exception(
                                    'Could not launch ${link.value}');
                              }
                            }
                            if (link.type == LinkType.email) {
                              final Uri url =
                              Uri.parse('mailto:${link.value}');
                              if (!await launchUrl(url)) {
                                CustomSnackBar.show(context,
                                    message:
                                    'Could not launch ${link.value}',
                                    color: Colors.red);
                                throw Exception(
                                    'Could not launch ${link.value}');
                              }
                            }
                          },
                          linkStyle: TextStyle(color: Theme.of(context).primaryColor),
                          linkTypes: const [
                            LinkType.url,
                            LinkType.userTag,
                            LinkType.hashTag,
                            LinkType.email
                          ],
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              UserListWidget(
                type: 'club',
                clubId: clubId,
              ),
              profileController.currentUser.value.role == 'user'
                  ? const SizedBox()
                  :
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtonWidget(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialogue(
                                      context: context,
                                      onPressed: () => {
                                        deleteClub(context),
                                      },
                                      title: 'Conformation',
                                      content:
                                          'Are you sure you want to delete ${clubsController.clubList.where((club) => club.id == clubId).first.name} and all its post ? This action cannot be undone.',
                                    );
                                  });
                            },
                            buttonText: 'Delete Club',
                            isNegative: true,),
                      )))
            ],
          ),
        ),
        Obx(() {
          return Container(
            child:
            loadingController.isLoading.value
                ?
            LoadingWidget() : null,
          );
        }),
      ],
    );
  }
}
