import 'package:club_app/models/club_model.dart';
import '../network_services/club_service.dart';
import '/controllers/network_controller.dart';
import 'package:get/get.dart';

class ClubRepository {
  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<List<Club>> fetchClubs() async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Fetch clubs
    try{
      Map<String, dynamic> data = await ClubService().fetchClubs();
      final clubs = (data['data'])['getClubs'];
      final clubList = clubs.map<Club>((club) => Club.fromJson(club)).toList();
      return clubList;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Club>> addMembersToClub(clubId, userEmail) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Add members to club
    try {
      Map<String, dynamic> data =
          await ClubService().addMembersToClub(clubId, userEmail);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchClubs();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Club>> removeMembersFromClub(clubId, userEmail) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Remove members from club
    try {
      Map<String, dynamic> data =
          await ClubService().removeMembersFromClub(clubId, userEmail);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchClubs();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Club>> updateClubInfo(id, name, description, imageUrl) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Update club info
    try{
      Map<String, dynamic> data = await ClubService().updateClubInfo(id, name, description, imageUrl);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchClubs();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Club>> createNewClub(name, description, imageUrl, createdBy) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Update club info
    try{
      Map<String, dynamic> data = await ClubService().createNewClub(name, description, imageUrl, createdBy);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchClubs();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Club>> deleteClub(id) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Update club info
    try{
      Map<String, dynamic> data = await ClubService().deleteClub(id);
      if (data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchClubs();
    } catch (e) {
      return Future.error(e);
    }
  }

}
