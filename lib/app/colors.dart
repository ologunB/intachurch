import 'package:flutter/material.dart';
import 'package:mms_app/core/storage/local_storage.dart';

class AppColors {
  static const textBlue = Color(0XFF18366C);
  static const grey = Color(0XFFF7F7FC);
  static const white = Colors.white;
  static const textGrey = Color(0XFF999999);
  static const black = Color(0XFF253043);
  static const darkTextGrey = Color(0XFFA1A4B2);
  static const lightTextGrey = Color(0XFF333333);
  static const containerColor = Color(0XFFF2F2F2);
  static const pitchBlack = Color(0XFF282930);
  static const red = Color(0XFFC30052);

  static int colorInt() {
    String a = AppCache?.myChurch?.uiTheme?.primaryColor ?? 'FF5D1AB2';
    var hexColor = a.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    int value = int.tryParse(hexColor, radix: 16) ?? 0xFF5D1AB2;
    return value;
  }

  static Color primaryColor = Color(colorInt());
}
