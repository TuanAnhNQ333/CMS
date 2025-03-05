import 'package:club_app/controllers/post_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../utils/shared_prefs.dart';
import 'clubs_controller.dart';
import 'event_controller.dart';

class NetworkController extends GetxController {

  final Connectivity _connectivity = Connectivity();

  @override
  Future<void> onInit() async {
    super.onInit();
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    print('Connectivity result: $connectivityResult');
    await _updateNetworkStatus(connectivityResult);
    _connectivity.onConnectivityChanged.listen(_updateNetworkStatus);
  }

  var isOnline = true.obs;


  Future<void> _updateNetworkStatus(List<ConnectivityResult> result) async {
    if(result.contains(ConnectivityResult.none)){
      isOnline.value = false;
      print('No internet');
    } else {
      isOnline.value = true;
      fetchData();
      print('Internet available');
    }
  }

  Future<void> fetchData() async {
    final token = await SharedPrefs.getToken();
    if (token != ''){
      final postController = Get.put(PostController());
      final clubController = Get.put(ClubsController());
      final eventController = Get.put(EventController());
    }

  }

}

