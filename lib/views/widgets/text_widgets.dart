import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/size_config/config.dart';

Widget regularSansText(
  BuildContext context, {
  String text,
  Color color,
  double fontSize,
  double letterSpacing,
  TextAlign textAlign,
  int maxLines,
  TextOverflow overflow,
  final decoration,
  final fontWeight,
}) {
  SizeConfig.init(context);
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: GoogleFonts.openSans(
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration),
  );
}

Widget regularRobotoText(
  BuildContext context, {
  String text,
  Color color,
  double fontSize,
  int maxLines,
  TextOverflow overflow,
  double letterSpacing,
  TextAlign textAlign,
  final decoration,
  final fontWeight,
}) {
  SizeConfig.init(context);
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: GoogleFonts.roboto(
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration),
  );
}
