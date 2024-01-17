// custom_button.dart

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  
  String? label;
  final void Function() onPressed;

  Button({
   
    this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffbc0229),
          foregroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: const Color(0x519e1d1d),
          elevation: 6,
        ),
        child: 
        Text(
         
          label!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
         
      ),
    );
  }
}
