import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/colors.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/loading_controller.dart';
import '../widgets/loading_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authenticationController = Get.put(AuthenticationController());
  final loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.4),
              painter: BluePainter(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.23,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(65, 61, 49, 1.0),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const Text(
                        'The app where you can find all the clubs and events in one place.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(65, 61, 49, 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'You can login using your Google account to continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: currentColors.oppositeColor.withOpacity(0.7)
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onTap: () async {
                      loadingController.toggleLoading();
                      final result = await authenticationController.authenticate(context);
                      loadingController.toggleLoading();
                      result['status'] == 'error'
                              ? CustomSnackBar.show(context,
                                  message: result['message'], color: Colors.red)
                              : CustomSnackBar.show(context,
                          message: result['message'], color: Colors.green);
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Image.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ?
                          'assets/android_light_rd_ctn@4x.png' : 'assets/android_dark_rd_ctn@4x.png'
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return Container(
              child:
              loadingController.isLoading.value
                  ?
              LoadingWidget() : null,
            );
          }),
        ],
      ),
    );
  }
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.06185000,0);
    path_0.lineTo(size.width*0.9317000,0);
    path_0.cubicTo(size.width*0.9317000,0,size.width*0.9916250,size.height*0.006662067,size.width*0.9974250,size.height*0.05668147);
    path_0.cubicTo(size.width*1.003225,size.height*0.1067009,size.width*0.9974250,size.height*0.9518779,size.width*0.9974250,size.height*0.9518779);
    path_0.cubicTo(size.width*0.9974250,size.height*0.9518779,size.width*0.7345500,size.height*1.068561,size.width*0.5064500,size.height*0.9385322);
    path_0.cubicTo(size.width*0.2783500,size.height*0.8085033,0,size.height*0.9652020,0,size.height*0.9652020);
    path_0.lineTo(0,size.height*0.06668535);
    path_0.cubicTo(0,size.height*0.06668535,size.width*0.001925000,size.height*0.01166401,size.width*0.06185000,0);
    path_0.close();

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Theme.of(Get.context!).primaryColor;
    canvas.drawPath(path_0,paint0Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
