import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/user_model.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/loading_controller.dart';
import '../../controllers/profile_controller.dart';
import '../dialogue_widgets/add_user_dialogue.dart';
import '../custom_snackbar.dart';

class UserListWidget extends StatelessWidget {
  UserListWidget({
    super.key,
    required this.type,
    this.clubId,
  });

  final adminController = Get.put(AdminController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());

  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
    if (clubId != null) {
      return currentUser.role == 'admin' ||
          clubsController.clubList
              .where((club) => club.id == clubId)
              .first
              .members
              .any((member) => member.id == currentUser.id);
    } else {
      return currentUser.role == 'admin';
    }
  }

  final clubId;
  final String type;

  Future<void> removeAdminUser(context, index) async {
    loadingController.toggleLoading();
    final result = await adminController.updateUserRole(
        context, adminController.adminUsers[index].email, "user");
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
    // Navigator.pop(context);
  }

  Future<void> removeClubUser(context, index) async {
    loadingController.toggleLoading();
    final result = await clubsController.removeUserFromClub(
        context,
        clubId,
        clubsController.clubList
            .where((club) => club.id == clubId)
            .first
            .members[index]
            .email);
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
    // Navigator.pop(context);
  }

  void showAddUserDialogue(context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: type == 'admin' ? 'Add Admin User' : 'Add Club User',
        context: context,
        pageBuilder: (context, _, __) => AddUserDialogue(
              type: type,
              clubId: clubId,
            ));
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Obx(() {
      if (type != 'admin') {
        var club = clubsController.clubList.where((club) => club.id == clubId);
        if (club.isEmpty) {
          return const SizedBox();
        }
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Wrap(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        type == 'admin'
                            ? 'All Admin Users'
                            : 'All Club Members',
                        style: const TextStyle(
                            // color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: !isAuthorized
                        ? const SizedBox(
                            height: 40,
                          )
                        : ButtonWidget(
                            onPressed: () => showAddUserDialogue(context),
                            buttonText:
                                type == 'admin' ? 'Add Admin' : 'Add Member',
                            isNegative: false,
                          ),
                  )
                ],
              ),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    radius: const Radius.circular(10),
                    thickness: 5,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: type == 'admin'
                          ? adminController.adminUsers.length
                          : clubsController.clubList
                              .where((club) => club.id == clubId)
                              .first
                              .members
                              .length,
                      itemBuilder: (context, index) {
                        final user = type == 'admin'
                            ? adminController.adminUsers[index]
                            : clubsController.clubList
                                .where((club) => club.id == clubId)
                                .first
                                .members[index];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(isDarkTheme ? 0.1 : 0.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: user.photoUrl),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          user.email,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: currentColors
                                                  .secondaryTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  !isAuthorized
                                      ? const SizedBox()
                                      : ButtonWidget(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (dialogueContext) {
                                                  return CustomAlertDialogue(
                                                      context: dialogueContext,
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            dialogueContext);
                                                        type == 'admin'
                                                            ? removeAdminUser(
                                                                context, index)
                                                            : removeClubUser(
                                                                context, index);
                                                      },
                                                      title: 'Remove User',
                                                      content:
                                                          'Are you sure you want to remove ${user.name} from ${type == 'admin' ? 'Admin' : 'the Club'}?');
                                                });
                                          },
                                          buttonText: 'Remove',
                                          isNegative: true,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
