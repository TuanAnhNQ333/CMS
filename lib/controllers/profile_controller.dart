import 'package:club_app/models/user_model.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var currentUser = UserModel(id: '', email: '', name: '', role: '', photoUrl: '').obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    currentUser.value = await SharedPrefs.getUserDetails();
    update();
  }
}
