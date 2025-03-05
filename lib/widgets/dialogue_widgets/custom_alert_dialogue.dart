import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogue extends AlertDialog {
  CustomAlertDialogue(
      {super.key,
      required this.context,
      required this.onPressed,
      required String title,
      required String content})
      : super(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ButtonWidget(
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonText: 'Cancel',
                isNegative: true,),
            ButtonWidget(
                onPressed: onPressed,
                buttonText: 'OK',
                isNegative: false,),
          ],
        );

  final BuildContext context;
  final VoidCallback onPressed;
}
