import 'package:club_app/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../models/feedback_model.dart';
import '../utils/repositories/feedback_repository.dart';
import 'clubs_controller.dart';

class FeedbackController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchFeedbackForms();
  }

  var feedbackList = <FeedbackModel>[].obs;

  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());

  List<String> get userClubs => clubsController.clubList
      .where((club) =>
          club.members.any((member) => member.id == profileController.currentUser.value.id))
      .map((club) => club.id)
      .toList();

  Future<void> fetchFeedbackForms() async {
    try{
      final response = await FeedbackRepository().fetchFeedbackForms(userClubs);
      feedbackList.value = response;
      update();
    } catch(e){
      print(e);
    }
  }


  Future<Map<String, dynamic>> uploadFeedback(id, ratingList, suggestion) async {
    try{
      feedbackList.value = await FeedbackRepository().uploadFeedback(id, ratingList, userClubs, suggestion);
      return {'status': 'ok', 'message': 'Feedback uploaded successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createFeedbackForm(eventId, clubId, List<String> questionList) async {
    try{
      feedbackList.value = await FeedbackRepository().createFeedbackForm(eventId, clubId, questionList, userClubs);
      return {'status': 'ok', 'message': 'Feedback form created successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteFeedbackForm(feedbackId) async {
    try{
      feedbackList.value = await FeedbackRepository().deleteFeedbackForm(feedbackId, userClubs);
      return {'status': 'ok', 'message': 'Feedback form deleted successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

}