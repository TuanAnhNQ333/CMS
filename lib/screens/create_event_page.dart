import 'dart:io';

import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/utils/repositories/image_repository.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/clubs_controller.dart';
import '../controllers/event_controller.dart';
import '../controllers/image_picker_controller.dart';
import '../controllers/loading_controller.dart';
import '../widgets/loading_widget.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final eventController = Get.put(EventController());

  final eventNameController = TextEditingController();

  final eventDescriptionController = TextEditingController();

  final eventDateController = TextEditingController();

  final eventTimeController = TextEditingController();

  final eventLocationController = TextEditingController();

  final imagePickerController = Get.put(ImagePickerController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());

  var eventDate;
  var organizingClub;
  var bannerUrl;

  Future<void> createEvent(context) async {
    if (imagePickerController.image == null) {
      CustomSnackBar.show(context,
          message: 'Please select a banner image', color: Colors.red);
      return;
    }
    if (eventNameController.text.isEmpty) {
      CustomSnackBar.show(context,
          message: 'Please enter event name', color: Colors.red);
      return;
    }
    if (eventDescriptionController.text.isEmpty) {
      CustomSnackBar.show(context,
          message: 'Please enter event description', color: Colors.red);
      return;
    }
    if (eventLocationController.text.isEmpty) {
      CustomSnackBar.show(context,
          message: 'Please enter event location', color: Colors.red);
      return;
    }
    if (eventDate == null) {
      CustomSnackBar.show(context,
          message: 'Please select event date', color: Colors.red);
      return;
    }
    if (organizingClub == null) {
      CustomSnackBar.show(context,
          message: 'Please select organizing club', color: Colors.red);
      return;
    }
    loadingController.toggleLoading();
    final imageUrl = await ImageRepository()
        .uploadImage(imagePickerController.image!);
    final event = EventModel(
      name: eventNameController.text,
      description: eventDescriptionController.text,
      date: '$eventDate',
      bannerUrl: imageUrl,
      location: eventLocationController.text,
      clubId: organizingClub.id,
      clubName: organizingClub.name,
      clubImageUrl: organizingClub.imageUrl,
      id: '',
    );
    final result = await eventController.createEvent(event);
    imagePickerController.resetImage();
    loadingController.toggleLoading();
    if (result['status'] == 'error') {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.red);
    } else {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.green);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool isPop) {
        eventDate = null;
      },
      child: Stack(
        children: [
              Scaffold(
              appBar: AppBar(
                title: const Text('Create Event'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonWidget(
                        onPressed: () async {
                          await createEvent(context);
                        },
                        buttonText: 'Create',
                        isColorInverted: true,
                        isNegative: false,),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Event Name :',
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: TextFormField(
                            // initialValue: club.name,
                            controller: eventNameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Event Description :',
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: TextFormField(
                            maxLines: 5,
                            controller: eventDescriptionController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Event Location :',
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: TextFormField(
                            maxLines: 1,
                            controller: eventLocationController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text('Organizing Club :',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: DropdownMenu(
                                        onSelected: (value) {
                                          setState(() {
                                            organizingClub =
                                                clubsController.clubList.firstWhere(
                                                        (club) => club.id == value);
                                          });
                                        },
                                        inputDecorationTheme: InputDecorationTheme(
                                          fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                          constraints: const BoxConstraints(
                                            maxWidth: 180,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        dropdownMenuEntries: profileController
                                            .currentUser.value.role ==
                                            'admin'
                                            ? clubsController.clubList.map((club) {
                                          return DropdownMenuEntry(
                                              value: club.id, label: club.name);
                                        }).toList()
                                            : clubsController.clubList
                                            .where((club) =>
                                            club.members.any(
                                                    (member) =>
                                                member.id ==
                                                    profileController
                                                        .currentUser.value.id))
                                            .map((club) {
                                          return DropdownMenuEntry(
                                              value: club.id,
                                              label: club.name);
                                        }).toList()),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          eventDate != null
                              ? null
                              : showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((date) {
                            if (date != null) {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((time) {
                                if (time != null) {
                                  setState(() {
                                    eventDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              });
                            }
                          });
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                eventDate == null
                                    ? const Text('Select Event Date',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                                    : Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Date : ${DateFormat('dd MMM').format(
                                                eventDate)}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'Time : ${DateFormat.jm().format(
                                                eventDate)}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),
                                eventDate == null
                                    ? const SizedBox(
                                  width: 0,
                                )
                                    : ButtonWidget(
                                    onPressed: () async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now(),
                                          initialDate: DateTime.now(),
                                          lastDate: DateTime(
                                              DateTime
                                                  .now()
                                                  .year + 2));
                                      final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());

                                      setState(() {
                                        eventDate = DateTime(
                                            date!.year,
                                            date.month,
                                            date.day,
                                            time!.hour,
                                            time.minute);
                                      });
                                    },
                                    preceedingIcon: Icons.calendar_month,
                                    buttonText: 'Change Date',
                                    isNegative: false,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GetBuilder<ImagePickerController>(builder: (logic) {
                        return Align(
                          alignment: Alignment.center,
                          child:
                          imagePickerController.image != null ? const SizedBox(
                            width: 0,
                          ) :
                          ButtonWidget(
                              onPressed: () async {
                                imagePickerController.getImage(ImageSource.gallery);
                              },
                              buttonText: 'Add banner image',
                              isNegative: false,),
                        );
                      }),
                      GetBuilder<ImagePickerController>(builder: (logic) {
                        return Container(
                          // color: Colors.transparent,
                          child: imagePickerController.image == null
                              ? const SizedBox(
                            width: 0,
                          )
                              : Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.file(
                                      File(imagePickerController.image!
                                          .path), // Placeholder image URL
                                      fit: BoxFit.cover,
                                      // Ensure the image fits within the space
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      imagePickerController.resetImage();
                                    },
                                    child: const Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor: Colors.redAccent,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              )),
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
