
import 'package:club_app/models/user_model.dart';

import '../../controllers/network_controller.dart';
import '../network_services/user_service.dart';
import 'package:get/get.dart';

class UserRepository{

  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<UserModel> getUserDetails(email) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }

    print('EMAIL: $email');
    try{
      final Map<String, dynamic> data = await UserService().getUserDetails(email);
      final user = UserModel.fromJson(data['data']['getUser']);
      return user;
    } catch (e) {
      return Future.error(e);
    }

  }

  Future<UserModel> createUser(name, email, photoUrl) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Create user
    try {
      final Map<String, dynamic> data = await UserService().createUser(name, email, photoUrl);
      final user = UserModel.fromJson(data['data']['createUser']);
      return user;
    } catch (e) {
      return Future.error(e);
    }

  }

}