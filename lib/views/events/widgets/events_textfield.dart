import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class EventsTextField extends StatelessWidget {
  final config = SizeConfig();
  final validator;
  final onSaved;
  final enabled;
  final hintText;
  final keyboardType;
  final inputFormatters;
  final onChanged;
  final bool focus;
  final controller;
  final focusNode;
  final obscuringCharacter;
  final TextInputAction textInputAction;

  EventsTextField({
    this.validator,
    this.onSaved,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.obscuringCharacter,
    this.enabled,
    this.focus = false,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      child: TextFormField(
        cursorColor: AppColors.black.withOpacity(0.2),
        cursorWidth: 2.w,
        enabled: enabled,
        focusNode: focusNode,
        autofocus: focus,
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
              fontSize: 13.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 22.h,
              color: Color(0xff7E8389),
            ),
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
            )),
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        onSaved: onSaved,
        onFieldSubmitted: onSaved,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
