import 'dart:async';
import 'dart:io';
import 'package:club_app/widgets/custom_popup_menu_item.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/config/colors.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/loading_controller.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../screens/image_viewer.dart';
import 'package:share_plus/share_plus.dart';

class PostWidget extends StatelessWidget {
  PostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  final isEditMode = false.obs;

  final editPostController = TextEditingController();
  final postController = Get.put(PostController());
  final clubsController = Get.put(ClubsController());
  final loadingController = Get.put(LoadingController());
  final profileController = Get.put(ProfileController());
  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
    return currentUser.role == 'admin' ||
        clubsController.clubList
            .where((club) => club.id == post.clubId)
            .first
            .members
            .any((member) => member.id == currentUser.id);
  }

  Future<void> updatePost(context) async {
    loadingController.toggleLoading();
    final result = await postController.updatePost(
        context, post.id, editPostController.text);
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
    // Navigator.pop(context);
  }

  Future<void> deletePost(context) async {
    loadingController.toggleLoading();
    final result = await postController.deletePost(context, post.id);
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
    // Navigator.pop(context);
  }

  Future<String> _downloadAndSaveFile(String url) async {
    String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$filename';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> sharePost(String imageUrl, String content) async {
    loadingController.toggleLoading();
    final result = imageUrl == ''
        ? await Share.share(content)
        : await Share.shareXFiles([XFile(await _downloadAndSaveFile(imageUrl))],
            text: content);
    loadingController.toggleLoading();

    if (result.status == ShareResultStatus.success) {
    }
  }

  Offset? _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    editPostController.text = post.content;

    return InkWell(
      onTapDown: (details) {
        _storePosition(details);
      },
      onLongPress: () async {
        if (!isAuthorized) return;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        await buildShowMenu(context, overlay);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                        imageUrl: clubsController.clubList
                                    .where((club) => club.id == post.clubId)
                                    .first
                                    .imageUrl ==
                                ''
                            ? 'https://via.placeholder.com/50x50'
                            : clubsController.clubList
                                .where((club) => club.id == post.clubId)
                                .first
                                .imageUrl,
                        width: 40.0,
                        height: 40.0)),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    post.imageUrl == ''
                        ? const SizedBox()
                        : InkWell(
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ImageViewer(image: post.imageUrl)));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CachedNetworkImage(
                                  imageUrl: post.imageUrl,
                                  width: 250,
                                  fit: BoxFit.cover,
                                  height: 250.0,
                                )),
                          ),
                    const SizedBox(height: 8.0),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: isEditMode.value
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.4),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: TextFormField(
                                    controller: editPostController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Write something...'),
                                    maxLines: null,
                                  ),
                                ),
                              )
                            : LinkifyText(post.content, onTap: (link) async {
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
                                linkStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                linkTypes: const [
                                  LinkType.url,
                                  LinkType.userTag,
                                  LinkType.hashTag,
                                  LinkType.email
                                ],
                                textStyle: const TextStyle(
                                    // color: Colors.black,
                                    fontSize: 16.0)),
                      );
                    }),
                    const SizedBox(height: 8.0),
                    Obx(() {
                      return Container(
                        child: !isEditMode.value
                            ? const SizedBox()
                            : Row(
                                children: [
                                  ButtonWidget(
                                    onPressed: () {
                                      isEditMode.value = false;
                                    },
                                    buttonText: 'Cancel',
                                    isNegative: true,
                                  ),
                                  const SizedBox(width: 8.0),
                                  ButtonWidget(
                                    onPressed: () {
                                      // isEditMode.value = false;

                                      // show custom alert dialog
                                      showDialog(
                                          context: context,
                                          builder: (dialogueContext) {
                                            return CustomAlertDialogue(
                                              context: dialogueContext,
                                              title: 'Conformation',
                                              content:
                                                  'You are about to save the changes made to this post. Do you wish to proceed?',
                                              onPressed: () async {
                                                Navigator.pop(dialogueContext);
                                                await updatePost(context);
                                              },
                                            );
                                          });

                                      // post.content = editPostController.text;
                                    },
                                    buttonText: 'Done',
                                    isNegative: false,
                                  ),
                                ],
                              ),
                      );
                    }),
                    Row(
                      children: [
                        Expanded(
                          child: Text(post.formattedDateTime,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: currentColors.tertiaryTextColor)),
                        ),
                        Obx(() {
                          return Container(
                            child: isEditMode.value
                                ? const SizedBox()
                                : isAuthorized
                                    ? InkWell(
                                        onTap: () {
                                          isEditMode.value = true;
                                        },
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: currentColors.oppositeColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(width: 4.0),
                                                Icon(
                                                    size: 12.0,
                                                    color: currentColors
                                                        .oppositeColor
                                                        .withOpacity(0.5),
                                                    Icons.edit_outlined),
                                                const SizedBox(width: 3.0),
                                                Text('Edit',
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: currentColors
                                                            .tertiaryTextColor)),
                                                const SizedBox(width: 4.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                          );
                        }),
                        const SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowMenu(BuildContext context, RenderBox overlay) {
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
            title: 'Share',
            icon: Icons.share,
            color: Theme.of(context).primaryColor,
            onTap: () {
              sharePost(post.imageUrl, post.content);
            }),
        const PopupMenuDivider(),
        CustomPopupMenuItem(
            title: 'Edit Post',
            icon: Icons.edit,
            color: Theme.of(context).primaryColor,
            onTap: () {
              isEditMode.value = true;
            }),
        const PopupMenuDivider(),
        CustomPopupMenuItem(
            title: 'Delete Post',
            icon: Icons.delete_outline,
            color: Colors.red,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (dialogueContext) {
                    return CustomAlertDialogue(
                      context: dialogueContext,
                      title: 'Conformation',
                      content:
                          'You are about to delete this post. Do you wish to proceed?',
                      onPressed: () async {
                        Navigator.pop(dialogueContext);
                        await deletePost(context);
                      },
                    );
                  });
              // delete post
            }),
      ],
    );
  }
}
