import 'package:flutter/material.dart';
import 'package:tic_tac_toe/util/colors.dart';
import 'package:tic_tac_toe/util/dimension.dart';

class TextFieled extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isReadOnly;

  const TextFieled({
    Key? key,
    required this.hint,
    required this.controller,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: borderColor,
            blurRadius: textFieldBlurShadowColor,
            spreadRadius: textFieldSpreadShadowColor,
          ),
        ],
        borderRadius: BorderRadius.circular(30), // Bord arrondi comme dans le design
      ),
      child: TextField(
        readOnly: isReadOnly,
        controller: controller,
        style: TextStyle(color: Colors.white), // Couleur du texte
        decoration: InputDecoration(
          filled: true,
          fillColor: bgColorDark,
          hintText: hint,
          hintStyle: TextStyle(color: borderColor), // Couleur du texte d'indication
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
