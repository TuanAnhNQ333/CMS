

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/utils/repositories/image_repository.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/image_picker_controller.dart';
import '../../controllers/profile_controller.dart';
import '../button_widget.dart';
import '../custom_snackbar.dart';

class NewClubDialogue extends StatefulWidget {
  const NewClubDialogue({super.key,});

  @override
  State<NewClubDialogue> createState() => _EditClubDialogueState();
}

class _EditClubDialogueState extends State<NewClubDialogue> {

  @override
  void initState() {
    super.initState();
  }

  final clubNameController = TextEditingController();
  final clubDescriptionController = TextEditingController();
  final imagePickerController = Get.put(ImagePickerController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());

  String escapeGraphQLSpecialChars(String input) {
    return input.split('').map((char) {
      return '\\u${char.codeUnitAt(0).toRadixString(16).padLeft(4, '0')}';
    }).join('');
  }

  Future<void> createClub(context) async {
    var imageUrl = 'https://via.placeholder.com/150x150';
    if(imagePickerController.image != null){
      imageUrl = await ImageRepository().uploadImage(imagePickerController.image!);
      imagePickerController.resetImage();
    }
    final result = await clubsController.createClub(
      clubNameController.text,
      escapeGraphQLSpecialChars(clubDescriptionController.text),
      imageUrl,
      profileController.currentUser.value.id,
    );
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
        message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Create New Club",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            GetBuilder<ImagePickerController>(builder: (logic) {
                              return Container(
                                child: imagePickerController.image != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(65),
                                  child: Image.file(
                                    File(imagePickerController.image!.path),
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(65),
                                  child: CachedNetworkImage(
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                    imageUrl: 'https://via.placeholder.com/150x150',
                                  ),
                                ),
                              );
                            }),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                onTap: () {
                                  imagePickerController
                                      .getImage(ImageSource.gallery);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(
                                          size: 18,
                                          Icons.edit,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Club Name :',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                                child: TextFormField(
                                  // initialValue: club.name,
                                  controller: clubNameController,
                                  onChanged: (value) {
                                    clubNameController.text = value;
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    // hintText: '${club.name}',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Description :',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                                child: TextFormField(
                                  controller: clubDescriptionController,
                                  onChanged: (value) {
                                    clubDescriptionController.text = value;
                                  },
                                  // initialValue: club.description,
                                  maxLines: 4,
                                  minLines: 1,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    // hintText: '${club.name}',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonWidget(
                          onPressed: () => {
                            // updateClubInfo(context),
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialogue(
                                      context: context,
                                      onPressed: () => {
                                        createClub(context),
                                      },
                                      title: 'Conformation',
                                      content:
                                      'Are you sure you want to create a new club ${clubNameController.text}?');
                                })
                          },
                          buttonText: 'Create',
                          isNegative: false,)
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

