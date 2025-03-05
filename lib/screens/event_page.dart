import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/screens/create_feedback_page.dart';
import 'package:club_app/screens/image_viewer.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/clubs_controller.dart';
import '../controllers/event_controller.dart';
import '../controllers/feedback_controller.dart';
import '../controllers/loading_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/loading_widget.dart';
import 'club_info_page.dart';

class EventPage extends StatefulWidget {
  EventPage({
    super.key,
    required this.eventId,
  });

  final String eventId;
  final eventController = Get.put(EventController());

  EventModel get event =>
      eventController.eventList.where((event) => event.id == eventId).first;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  void initState() {
    super.initState();
    editNameController.text = widget.event.name;
    editDescriptionController.text = widget.event.description;
    editLocationController.text = widget.event.location;
  }

  final isEditMode = false.obs;

  final editNameController = TextEditingController();

  final editDescriptionController = TextEditingController();

  final editLocationController = TextEditingController();

  var editedEventDate;

  final eventController = Get.put(EventController());

  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());
  final feedbackController = Get.put(FeedbackController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isAuthorized =>
      profileController.currentUser.value.role == 'admin' ||
      clubsController.clubList
          .where((club) => club.id == widget.event.clubId)
          .first
          .members
          .any((member) => member.id == profileController.currentUser.value.id);

  Future<void> updateEvent(context) async {
    loadingController.toggleLoading();
    final result = await eventController.updateEvent(
        widget.event.id,
        editNameController.text,
        editDescriptionController.text,
        '${editedEventDate ?? widget.event.date}',
        editLocationController.text,
        widget.event.clubId);
    // Navigator.pop(context);
    loadingController.toggleLoading();
    isEditMode.value = !isEditMode.value;
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
  }

  Future<void> deleteEvent(context) async {
    loadingController.toggleLoading();
    final result = await eventController.deleteEvent(widget.event.id);
    loadingController.toggleLoading();
    Navigator.pop(context);

    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
  }

  // final Color leadingIconColor;
  void addToCalendar(event) {
    final Event calendarEvent = Event(
      title: event.name,
      description: event.description,
      location: event.location,
      startDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
      endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
      iosParams: const IOSParams(
        reminder: Duration(/* Ex. hours:1 */),
        // on iOS, you can set alarm notification after your event.
        url:
            'https://www.example.com', // on iOS, you can set url to your event.
      ),
      androidParams: const AndroidParams(
        emailInvites: [], // on Android, you can add invite emails to your event.
      ),
    );
    Add2Calendar.addEvent2Cal(calendarEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // final iconColor = await isBright() ? Colors.black : Colors.white;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ImageViewer(image: widget.event.bannerUrl)),
                        );
                      },
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 370,
                          imageUrl: widget.event.bannerUrl),
                    ),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ClubInfoPage(
                                      clubId: widget.event.clubId)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              widget.event.clubImageUrl),
                                      radius: 15,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3),
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        widget.event.clubName,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(() {
                            return Container(
                              child: !isAuthorized
                                  ? const SizedBox()
                                  : Container(
                                      child: isEditMode.value
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ButtonWidget(
                                                  onPressed: () {
                                                    isEditMode.value =
                                                        !isEditMode.value;
                                                  },
                                                  buttonText: 'Cancel',
                                                  isNegative: true,
                                                ),
                                                const SizedBox(width: 8),
                                                ButtonWidget(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (dialogueContext) =>
                                                                CustomAlertDialogue(
                                                                  context:
                                                                      dialogueContext,
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        dialogueContext);
                                                                    await updateEvent(
                                                                        context);
                                                                  },
                                                                  title:
                                                                      'Conform Edit',
                                                                  content:
                                                                      'Are you sure you want to edit this event?',
                                                                ));
                                                  },
                                                  buttonText: 'Done',
                                                  isNegative: false,
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ButtonWidget(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (dialogueContext) =>
                                                            CustomAlertDialogue(
                                                              context: dialogueContext,
                                                              onPressed: () async {
                                                                Navigator.pop(
                                                                    dialogueContext);
                                                                await deleteEvent(context);
                                                              },
                                                              title: 'Conform Delete',
                                                              content:
                                                              'Are you sure you want to delete this event? This action cannot be undone',
                                                            ));
                                                  },
                                                  buttonText: 'Delete',
                                                  isNegative: true,
                                                ),
                                                const SizedBox(width: 8),
                                                ButtonWidget(
                                                  onPressed: () {
                                                    isEditMode.value =
                                                        !isEditMode.value;
                                                  },
                                                  preceedingIcon: Icons.edit,
                                                  isNegative: false, buttonText: '',
                                                ),
                                              ],
                                            ),
                                    ),
                            );
                          })
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: isEditMode.value
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.4),
                                          width: 1.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: TextFormField(
                                      controller: editNameController,
                                      style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                )
                              : Obx(() {
                                  return Text(
                                    widget.event.name,
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  );
                                }),
                        );
                      }),
                      const SizedBox(
                        height: 8,
                      ),
                      Card(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, size: 40),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Text(
                                    isEditMode.value
                                        ? editedEventDate != null
                                            ? DateFormat('dd MMM')
                                                .format(editedEventDate)
                                            : widget.event.formattedDate
                                        : widget.event.formattedDate,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Theme.of(context).primaryColor),
                                  );
                                }),
                                Obx(() {
                                  return Text(
                                    isEditMode.value
                                        ? editedEventDate != null
                                            ? DateFormat.jm()
                                                .format(editedEventDate)
                                            : widget.event.formattedTime
                                        : widget.event.formattedTime,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  );
                                }),
                              ],
                            ),
                            Expanded(child: Obx(() {
                              return Align(
                                  alignment: Alignment.centerRight,
                                  child: isEditMode.value
                                      ? ButtonWidget(
                                          onPressed: () async {
                                            final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                initialDate: DateTime.now(),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 2));
                                            final time = await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              setState(() {
                                                if (date != null &&
                                                    value != null) {
                                                  editedEventDate = DateTime(
                                                      date.year,
                                                      date.month,
                                                      date.day,
                                                      value.hour,
                                                      value.minute);
                                                }
                                              });
                                            });
                                          },
                                          buttonText: 'Change Date',
                                          isNegative: false)
                                      : ButtonWidget(
                                          onPressed: () {
                                            addToCalendar(widget.event);
                                          },
                                          buttonText: 'Add to Calendar',
                                          isNegative: false));
                            }))
                          ],
                        ),
                      )),
                      const SizedBox(
                        height: 8,
                      ),
                      Card(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 40),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return Container(
                                      child: isEditMode.value
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.4),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: TextFormField(
                                                  controller:
                                                      editLocationController,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            )
                                          : Obx(() {
                                              return Text(
                                                widget.event.location,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              );
                                            }),
                                    );
                                  }),
                                  const Text(
                                    'Location',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(
                        height: 8,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text('Description',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Obx(() {
                                return Container(
                                  child: isEditMode.value
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: TextFormField(
                                              controller:
                                                  editDescriptionController,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              maxLines: null,
                                            ),
                                          ),
                                        )
                                      : Obx(() {
                                          return Text(
                                            widget.event.description,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          );
                                        }),
                                );
                              }),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      !isAuthorized
                          ? const SizedBox()
                          : Obx(() {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: feedbackController.feedbackList.any(
                                        (feedbackForm) =>
                                            feedbackForm.eventId ==
                                            widget.event.id)
                                    ? const SizedBox(
                                        width: 0,
                                      )
                                    : ButtonWidget(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateFeedbackPage(eventId: widget.event.id, clubId: widget.event.clubId ,)));
                                        },
                                        buttonText: 'Add Feedback Form',
                                        isNegative: false,
                                      ),
                              );
                            }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return Container(
              child: loadingController.isLoading.value ? LoadingWidget() : null,
            );
          }),
        ],
      ),
    );
  }
}
