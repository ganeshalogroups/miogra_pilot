// ignore_for_file: file_names

import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:flutter/material.dart';

class CustomContainerDecoration {
//Login padding style

  static BoxDecoration loginPaddingDecoration({
    Color color = Customcolors.decorationWhite,
  }) {
    return const BoxDecoration(
      color: Customcolors.decorationWhite,
      borderRadius: BorderRadius.only(
        topLeft: Radius.zero,
        topRight: Radius.zero,
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }

  static BoxDecoration lormalPaddingDecoration({
    Color color = Customcolors.decorationWhite,
  }) {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    );
  }
}
