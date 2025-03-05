import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../controllers/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Card(
      child: GetBuilder<BottomNavController>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    bottomNavController.selectIndex(0);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event, size: 30,
                        color: bottomNavController.selectedIndex.value == 0 ? Theme.of(context).primaryColor : currentColors.oppositeColor.withOpacity(0.7)
                      ),
                      Text('Events',
                        style: TextStyle(
                          color: bottomNavController.selectedIndex.value == 0 ? Theme.of(context).primaryColor : currentColors.oppositeColor
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    bottomNavController.selectIndex(1);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble, size: 30,
                        color: bottomNavController.selectedIndex.value == 1 ? Theme.of(context).primaryColor : currentColors.oppositeColor
                      ),
                      Text('Clubs',
                        style: TextStyle(
                          color: bottomNavController.selectedIndex.value == 1 ? Theme.of(context).primaryColor : currentColors.oppositeColor
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    bottomNavController.selectIndex(2);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.feedback_outlined, size: 30,
                          color: bottomNavController.selectedIndex.value == 2 ? Theme.of(context).primaryColor : currentColors.oppositeColor
                      ),
                      Text('Feedback',
                        style: TextStyle(
                            color: bottomNavController.selectedIndex.value == 2 ? Theme.of(context).primaryColor : currentColors.oppositeColor
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
