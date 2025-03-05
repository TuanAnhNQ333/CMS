
import 'package:club_app/models/user_model.dart';
import 'package:club_app/utils/repositories/admin_repository.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchAdminUsers();
  }

  var adminUsers = <UserModel>[].obs;

  Future<Map<String, dynamic>> fetchAdminUsers() async {
    try{
      adminUsers.value = await AdminRepository().fetchAdminUsers();
      update();
      return {'status': 'ok', 'message': 'Admin users fetched successfully'};
    } catch(e) {
      return {'status': 'error', 'message': e.toString()};
    }

  }

  Future<Map<String, dynamic>> updateUserRole(context ,email, role) async {
    try{
      adminUsers.value = await AdminRepository().updateUserRole(email, role);
      update();
      return {'status': 'ok', 'message': 'User role updated successfully'};
    } catch(e){
      return {'status': 'error', 'message': e.toString()};
    }
  }



}