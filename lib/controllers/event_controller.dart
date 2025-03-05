import 'package:club_app/models/event_model.dart';
import 'package:club_app/utils/repositories/event_repository.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:get/get.dart';

import 'network_controller.dart';

class EventController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    final networkController = Get.find<NetworkController>();
    networkController.isOnline.value ?
    fetchEvents() : fetchEventsFromSharedPrefs();
  }

  var eventList = <EventModel>[].obs;

  Future<void> fetchEvents() async {
    eventList.value = await EventRepository().fetchEvents();
    await SharedPrefs.saveEvents(eventList);
    update();
  }

  void fetchEventsFromSharedPrefs() async {
    eventList.value = await SharedPrefs.getEvents();
    update();
  }



  Future<Map<String, dynamic>> createEvent(EventModel event) async {
    try{
      eventList.add(await EventRepository().createEvent(event));
      update();
      return {'status': 'ok', 'message': 'Event created successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateEvent(id, name, description, date, location, club) async {

    try{
      eventList.value = await EventRepository().updateEvent(id, name, description, date, location, club);
      update();
      return {'status': 'ok', 'message': 'Event Updated successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteEvent(id) async {
    try{
      eventList.value = await EventRepository().deleteEvent(id);
      update();
      return {'status': 'ok', 'message': 'Event Deleted successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

}
