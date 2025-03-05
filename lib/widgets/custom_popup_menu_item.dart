import 'package:flutter/material.dart';

class CustomPopupMenuItem extends PopupMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  @override
  final VoidCallback onTap;

  CustomPopupMenuItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.onTap})
      : super(
          onTap: onTap,
          height: 10,
          value: 'Option 3',
          child: Padding(
            padding: EdgeInsets.zero,
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: 16.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )),
          ),
        );

}
