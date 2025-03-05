import 'package:club_app/widgets/app_widgets/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/clubs_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/event_model.dart';
import '../../screens/create_event_page.dart';

class EventListWidget extends StatelessWidget {
  EventListWidget({super.key});

  final eventController = Get.put(EventController());
  final profileController = Get.put(ProfileController());
  final clubsController = Get.put(ClubsController());

  bool get isAuthorized {
    final isAdmin = profileController.currentUser.value.role == 'admin';
    final isAnyClubMember = clubsController.clubList.any((club) => club.members
        .any((member) => member.id == profileController.currentUser.value.id));
    return isAdmin || isAnyClubMember;
  }

  List<EventModel> get todayEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    return eventList
        .where((event) =>
            DateTime(event.dateTime.year, event.dateTime.month,
                event.dateTime.day) ==
            DateTime(today.year, today.month, today.day))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get thisWeekEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    final nextWeek = today.add(const Duration(days: 7));
    return eventList
        .where((event) =>
            event.dateTime.isAfter(today) && event.dateTime.isBefore(nextWeek))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get thisMonthEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    final thisWeek = today.add(const Duration(days: 7));
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 1);
    return eventList
        .where((event) =>
            event.dateTime.isAfter(thisWeek) &&
            event.dateTime.isBefore(lastDayOfMonth))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get upcomingEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 1);
    return eventList
        .where((event) => event.dateTime.isAfter(lastDayOfMonth))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get sortedEventList {
    final eventList = eventController.eventList;
    eventList.sort((a, b) => a.date.compareTo(b.date));
    return eventList;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Obx(() {
              final eventWidgetList = [
                todayEventList.isEmpty
                    ? const SizedBox()
                    : const SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Today',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ];
              todayEventList.isEmpty
                  ? null
                  : todayEventList.forEach((event) {
                      eventWidgetList
                          .add(SizedBox(child: EventWidget(event: event)));
                    });
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: eventWidgetList);
            }),
            Obx(() {
              final eventWidgetList = [
                thisWeekEventList.isEmpty
                    ? const SizedBox()
                    : const SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'This Week',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ];
              thisWeekEventList.isEmpty
                  ? null
                  : thisWeekEventList.forEach((event) {
                      eventWidgetList
                          .add(SizedBox(child: EventWidget(event: event)));
                    });
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: eventWidgetList);
            }),
            Obx(() {
              final eventWidgetList = [
                thisMonthEventList.isEmpty
                    ? const SizedBox()
                    : const SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'This Month',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ];
              thisMonthEventList.isEmpty
                  ? null
                  : thisMonthEventList.forEach((event) {
                      eventWidgetList
                          .add(SizedBox(child: EventWidget(event: event)));
                    });
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: eventWidgetList);
            }),
            Obx(() {
              final eventWidgetList = [
                upcomingEventList.isEmpty
                    ? const SizedBox()
                    : const SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Upcoming',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ];
              upcomingEventList.isEmpty
                  ? null
                  : upcomingEventList.forEach((event) {
                      eventWidgetList
                          .add(SizedBox(child: EventWidget(event: event)));
                    });
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: eventWidgetList);
            }),
            const SizedBox(
              height: 100,
            )
          ],
        ),
        !isAuthorized
            ? const SizedBox()
            : Positioned(
                bottom: 100,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateEventPage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
      ],
    );
  }
}
