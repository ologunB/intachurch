import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class ProfileTextField extends StatelessWidget {
  final config = SizeConfig();
  final Widget suffixIcon;
  final enabled;
  final hintText;
  final keyboardType;
  final onChanged;
  final TextEditingController controller;
  final obscuringCharacter;

  ProfileTextField({
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.controller,
    this.obscuringCharacter,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.h),
      child: TextFormField(
        cursorColor: AppColors.black.withOpacity(0.2),
        cursorWidth: 2.w,
        enabled: enabled,
        cursorHeight: 20.h,
        style: GoogleFonts.roboto(
          color: AppColors.pitchBlack,
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          letterSpacing: 0.4,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 15.w,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.roboto(
            color: AppColors.darkTextGrey,
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.containerColor.withOpacity(0.5),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.containerColor,
            ),
            borderRadius: BorderRadius.circular(8.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.containerColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8.h),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.containerColor.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(8.h),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.containerColor.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        controller: controller,
        onChanged: onChanged,
      ),
    );
  }
}
