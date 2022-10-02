import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class MemberTextField extends StatelessWidget {
  final config = SizeConfig();
  final bool suffixIcon;
  final String Function(String) validator;
  final Function(String) onSaved;
  final bool enabled;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final TextEditingController controller;
  final String obscuringCharacter;

  MemberTextField({
    Key key,
    this.suffixIcon = false,
    this.validator,
    this.onSaved,
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.controller,
    this.obscuringCharacter,
    this.enabled = true,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      child: TextFormField(
        key: key,
        cursorColor: AppColors.black.withOpacity(0.2),
        cursorWidth: 2.w,
        enabled: enabled,
        cursorHeight: 20.h,
        style: GoogleFonts.openSans(
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
          labelText: labelText,
          hintStyle: GoogleFonts.openSans(
            color: AppColors.lightTextGrey,
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
          ),
          labelStyle: GoogleFonts.openSans(
            color: AppColors.lightTextGrey,
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
          ),
          suffixIcon: suffixIcon
              ? Icon(Icons.arrow_forward_ios_outlined, size: 16.h)
              : null,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.darkTextGrey,
            ),
            borderRadius: BorderRadius.circular(5.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkTextGrey),
            borderRadius: BorderRadius.circular(5.h),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.darkTextGrey,
            ),
            borderRadius: BorderRadius.circular(5.h),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.darkTextGrey,
            ),
            borderRadius: BorderRadius.circular(5.h),
          ),
        ),
        controller: controller,
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
