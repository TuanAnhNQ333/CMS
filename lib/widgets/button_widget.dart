import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.preceedingIcon,
      required this.isNegative,
      this.isColorInverted});

  final VoidCallback onPressed;
  final String buttonText;
  final bool isNegative;
  // final Color textColor;
  // final Color buttonColor;
  final isColorInverted;
  final preceedingIcon;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color buttonColor = isNegative ? Colors.red : Theme.of(context).primaryColor;
    final Color textColor = isNegative ? Colors.white : const Color.fromRGBO(40, 40, 40, 1);
    final Color invertedTextColor = !isDark ? buttonColor : textColor;
    final Color invertedButtonColor = !isDark ? textColor : buttonColor;


    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
              color: isColorInverted != null ? (isColorInverted ? invertedButtonColor : buttonColor) : buttonColor,
              borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                preceedingIcon == null
                    ? const SizedBox()
                    : Icon(
                        preceedingIcon,
                        color: isColorInverted != null ? (isColorInverted ? invertedTextColor : textColor) : textColor,
                        size: 18,
                      ),
                preceedingIcon == null
                    ? const SizedBox()
                    : buttonText != '' ? const SizedBox(
                        width: 5,
                      ) : const SizedBox(),

                Text(
                  buttonText,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isColorInverted != null ? (isColorInverted ? invertedTextColor : textColor) : textColor,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
