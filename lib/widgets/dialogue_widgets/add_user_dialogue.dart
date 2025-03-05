import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/loading_controller.dart';
import '../button_widget.dart';
import '../custom_snackbar.dart';

class AddUserDialogue extends StatelessWidget {
  AddUserDialogue({super.key, this.clubId, required this.type});

  final adminController = Get.put(AdminController());
  final clubsController = Get.put(ClubsController());
  final emailController = TextEditingController();
  final loadingController = Get.put(LoadingController());

  final clubId;
  final String type;

  Future<void> addAdminUser(context) async {
    loadingController.toggleLoading();
    final result = await adminController.updateUserRole(context, emailController.text, "admin");
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
        message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);
    // Navigator.pop(context);
    // Navigator.pop(context);
  }

  Future<void> addClubUser(context) async {
    loadingController.toggleLoading();
    final result =  await clubsController.addUserToClub(context, clubId, emailController.text);
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
        message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);
    // Navigator.pop(context);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type == 'admin' ? 'Add Admin User' : 'Add Club User',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                ),
                ButtonWidget(
                  onPressed: (){
                    showDialog(context: context, builder: (dialogueContext){
                      return CustomAlertDialogue(context: dialogueContext,
                          onPressed: ()
                          {
                            Navigator.pop(dialogueContext);
                              type == 'admin'
                                  ? addAdminUser(context)
                                  : addClubUser(context);
                              Navigator.pop(context);
                            },
                          title: 'Add User',
                          content: 'Are you sure you want to add this user ${type == 'admin' ? 'as Admin' : 'to this Club'}?',);
                    });
                  },
                  buttonText: 'Add user',
                  isNegative: false,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
