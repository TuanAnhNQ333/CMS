
import 'package:club_app/models/event_model.dart';
import 'package:club_app/utils/network_services/event_service.dart';
import '/controllers/network_controller.dart';
import 'package:get/get.dart';

class EventRepository{

  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<List<EventModel>> fetchEvents() async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data = await EventService().fetchEvents();
      final events = (data['data'])['getEvents'];
      final eventList = events.map<EventModel>((event) => EventModel.fromJson(event)).toList();
      return eventList;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<EventModel> createEvent(
      EventModel event) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data = await EventService()
          .createEvent(event.name, event.description, event.date, event.location, event.bannerUrl, event.clubId);

      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }

      final eventData = (data['data'])['createEvent'];
      return EventModel.fromJson(eventData);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<EventModel>> updateEvent(id, name, description, date, location, club) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
      await EventService().updateEvent(id, name, description, date, location, club);

      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }

      return fetchEvents();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<EventModel>> deleteEvent(id) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data = await EventService().deleteEvent(id);

      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }

      return fetchEvents();
    } catch (e) {
      return Future.error(e);
    }
  }


}