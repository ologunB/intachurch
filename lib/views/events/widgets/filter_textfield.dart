import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class FilterTextField extends StatelessWidget {
  final config = SizeConfig();
  final validator;
  final onSaved;
  final enabled;
  final hintText;
  final keyboardType;
  final inputFormatters;
  final onChanged;
  final controller;
  final obscuringCharacter;

  FilterTextField({
    this.validator,
    this.onSaved,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.obscuringCharacter,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: TextFormField(
        cursorColor: AppColors.black.withOpacity(0.2),
        cursorWidth: 2.w,
        enabled: enabled,
        cursorHeight: 20.h,
        style: GoogleFonts.openSans(
            color: AppColors.pitchBlack,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 15.w,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            color: Color(0xff7E8389),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.containerColor),
            borderRadius: BorderRadius.circular(8.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.containerColor),
            borderRadius: BorderRadius.circular(5.h),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.containerColor),
            borderRadius: BorderRadius.circular(5.h),
          ),
        ),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onSaved: onSaved,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
