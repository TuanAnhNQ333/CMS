import '../network_services/admin_service.dart';
import '/controllers/network_controller.dart';
import '/models/user_model.dart';
import 'package:get/get.dart';

class AdminRepository{

  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<List<UserModel>> updateUserRole(email, role) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Update user role
    try{
      Map<String, dynamic> data = await AdminService().updateUserRole(email, role);
      if(data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        return Future.error(errorMessage);
      }
      return fetchAdminUsers();
    } catch(e){
      return Future.error('Failed to update user role');
    }
  }

  Future<List<UserModel>> fetchAdminUsers() async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Fetch admin users
    try{
      Map<String, dynamic> data = await AdminService().fetchAdminUsers();
      final users = (data['data'])['getUsers'];
      final adminUserList = users.map<UserModel>((user) => UserModel.fromJson(user)).toList();
      return adminUserList;
    }
    catch(e){
      return Future.error('Failed to fetch admin users');
    }
  }

}