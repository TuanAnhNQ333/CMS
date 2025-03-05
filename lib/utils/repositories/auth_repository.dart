import 'package:club_app/utils/shared_prefs.dart';
import '../network_services/auth_service.dart';
import '/controllers/network_controller.dart';
import 'package:get/get.dart';

class AuthRepository{

  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<bool> verifyGoogleUser(email, token) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Verify google user
    try{
      Map<String, dynamic> data = await AuthService().verifyGoogleUser(email, token);
      if(data['status'] == 'error'){
        return Future.error(data['message']);
      }
      SharedPrefs.saveToken(data['token']);
      return await isUserExist(email);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> isUserExist(email) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Check if user exists
    print('EMAIL: $email');
    try{
      Map<String, dynamic> data = await AuthService().isUserExist(email);
      if(data['data']['getUser'] != null){
        print('IS USER EXIST: ${data['data']['getUser']}');
        return true;
      } else {
        print('IS USER EXIST: false');
        return false;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

}