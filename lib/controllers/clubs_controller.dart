
import 'package:club_app/controllers/post_controller.dart';
import 'package:club_app/utils/repositories/club_repository.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:get/get.dart';

import '../models/club_model.dart';
import 'network_controller.dart';

class ClubsController extends GetxController {

  var clubList = <Club>[].obs;

  final postController = Get.put(PostController());


  @override
  void onInit() {
    super.onInit();
    final networkController = Get.find<NetworkController>();
    networkController.isOnline.value ?
    fetchClubs() : fetchClubsFromSharedPrefs();
  }

  Future<Map<String, dynamic>> fetchClubs() async {
    try{
      clubList.value = await ClubRepository().fetchClubs();
      await SharedPrefs.saveClubs(clubList);
      update();
      return {'status': 'ok', 'message': 'Clubs fetched successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchClubsFromSharedPrefs() async {
    try{
      clubList.value = await SharedPrefs.getClubs();
      update();
      return {'status': 'ok', 'message': 'Clubs fetched from shared preferences'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addUserToClub(context, clubId, userEmail) async {
    try{
      clubList.value = await ClubRepository().addMembersToClub(clubId, userEmail);
      update();
      return {'status': 'ok', 'message': 'User added to club successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> removeUserFromClub(context, clubId, userEmail) async {
    try{
      clubList.value = await ClubRepository().removeMembersFromClub(clubId, userEmail);
      update();
      return {'status': 'ok', 'message': 'User removed from club successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateClub(context, id, name, description, imageUrl) async {
    try{
      clubList.value = await ClubRepository().updateClubInfo(id, name, description, imageUrl);
      update();
      return {'status': 'ok', 'message': 'Club updated successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }

  }

  Future<Map<String, dynamic>> createClub(name, description, imageUrl, createdBy) async {
    try{
      clubList.value = await ClubRepository().createNewClub(name, description, imageUrl, createdBy);
      await postController.fetchPosts();
      update();
      return {'status': 'ok', 'message': 'Club created successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteClub(clubId) async {
    try{
      clubList.value = await ClubRepository().deleteClub(clubId);
      await postController.fetchPosts();
      update();
      return {'status': 'ok', 'message': 'Club deleted successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

}

