import 'package:club_app/models/feedback_model.dart';
import 'package:club_app/utils/network_services/feedback_service.dart';
import 'package:get/get.dart';

import '../../controllers/network_controller.dart';

class FeedbackRepository {
  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<List<FeedbackModel>> fetchFeedbackForms(List<String> userClubs) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
          await FeedbackService().fetchFeedbackForms(userClubs);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      final feedbackForms = (data['data'])['getFeedbacks'];
      final feedbackFormList = feedbackForms
          .map<FeedbackModel>((feedback) => FeedbackModel.fromJson(feedback))
          .toList();
      return feedbackFormList;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<FeedbackModel>> uploadFeedback(id, ratingList, userClubs, suggestion) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
      await FeedbackService().uploadFeedback(id, ratingList, suggestion);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchFeedbackForms(userClubs);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<FeedbackModel>> createFeedbackForm(eventId, clubId, List<String> questionList, userClubs) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
      await FeedbackService().createFeedbackForm(eventId, clubId, questionList);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchFeedbackForms(userClubs);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<FeedbackModel>> deleteFeedbackForm(id, userClubs) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data = await FeedbackService().deleteFeedbackForm(id);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchFeedbackForms(userClubs);
    } catch (e) {
      return Future.error(e);
    }
  }

}
