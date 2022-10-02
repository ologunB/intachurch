import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/membership/widgets/member_option.dart';
import 'package:mms_app/views/membership/widgets/member_textfield.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import 'about_you_view.dart';

class EditAboutYouView extends StatefulWidget {
  const EditAboutYouView({Key key, this.userModel}) : super(key: key);

  final LoginData userModel;

  @override
  _EditAboutYouViewState createState() => _EditAboutYouViewState();
}

class _EditAboutYouViewState extends State<EditAboutYouView> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController mNumberController = TextEditingController();
  TextEditingController wNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String maritalStatus, gender;

  @override
  void initState() {
    fNameController.text =
        widget?.userModel?.profile?.firstName?.toTitleCase() ?? '';
    lNameController.text =
        widget?.userModel?.profile?.lastName?.toTitleCase() ?? '';
    professionController.text =
        widget?.userModel?.profile?.profession?.toTitleCase() ?? '';
    gender = widget?.userModel?.profile?.gender;
    maritalStatus = widget?.userModel?.profile?.maritalStatus;
    mNumberController.text = widget?.userModel?.profile?.mobilePhone ?? '';
    addressController.text = widget?.userModel?.profile?.address ?? '';
    wNumberController.text = widget?.userModel?.profile?.workNumber ?? '';
    emailController.text = widget?.userModel?.email?.toLowerCase() ?? '';
    dobController.text = widget?.userModel?.profile?.dob ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<AuthViewModel>(builder: (_, AuthViewModel model, __) {
      return Scaffold(
          backgroundColor: AppColors.white,
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  padding: EdgeInsets.all(20.h),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.h),
                          bottomRight: Radius.circular(10.h))),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    AboutYouView())),
                        child: Container(
                            width: 50.w,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.arrow_back,
                                color: AppColors.white, size: 22.h)),
                      ),
                      Expanded(
                        child: Center(
                          child: regularSansText(context,
                              text: 'About you',
                              fontSize: 18.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      model.busy
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              height: 20.h,
                              width: 20.w,
                            )
                          : InkWell(
                              onTap: () {
                                Map<String, dynamic> data = <String, dynamic>{};

                                if (fNameController.text !=
                                    widget.userModel.profile.firstName) {
                                  data.putIfAbsent(
                                      'firstName', () => fNameController.text);
                                  //    widget.userModel.profile.firstName = fNameController.text;
                                }
                                if (lNameController.text !=
                                    widget.userModel.profile.lastName) {
                                  data.putIfAbsent(
                                      'lastName', () => lNameController.text);
                                }
                                if (mNumberController.text !=
                                    widget.userModel.profile.mobilePhone) {
                                  data.putIfAbsent('mobilePhone',
                                      () => mNumberController.text);
                                }
                                if (wNumberController.text !=
                                    widget.userModel.profile.workNumber) {
                                  data.putIfAbsent('workNumber',
                                      () => wNumberController.text);
                                }
                                if (professionController.text !=
                                    widget.userModel.profile.profession) {
                                  data.putIfAbsent('profession',
                                      () => professionController.text);
                                }
                                if (maritalStatus !=
                                    widget.userModel.profile.maritalStatus) {
                                  data.putIfAbsent(
                                      'maritalStatus', () => maritalStatus);
                                }
                                if (dobController.text !=
                                    widget.userModel.profile.dob) {
                                  data.putIfAbsent('dob',
                                      () => startDate?.toIso8601String());
                                }

                                if (addressController.text !=
                                    widget.userModel.profile.address) {
                                  data.putIfAbsent(
                                      'address', () => addressController.text);
                                }

                                if (gender != widget.userModel.profile.gender) {
                                  data.putIfAbsent('gender', () => gender);
                                }

                                if (data.isNotEmpty) {
                                  doneDialog(context, model, data);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'No changes have been made')));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 15.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.h),
                                    color: Colors.white),
                                child: regularSansText(context,
                                    text: 'Save',
                                    fontSize: 14.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              memberOption(context, 'First Name'),
              MemberTextField(controller: fNameController),
              memberOption(context, 'Last Name'),
              MemberTextField(controller: lNameController),
              memberOption(context, 'Profession'),
              MemberTextField(controller: professionController),
              memberOption(context, 'Marital Status'),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.h),
                    border: Border.all(
                      color: AppColors.darkTextGrey,
                    )),
                child: DropdownButton(
                  hint: Text(
                    'Choose your status',
                    style: GoogleFonts.openSans(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  // Not necessary for Option 1
                  value: maritalStatus,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      maritalStatus = newValue;
                    });
                  },
                  underline: SizedBox(),
                  items: ['single', 'married', 'divorced'].map((location) {
                    return DropdownMenuItem(
                      child: Text(
                        location.toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: AppColors.pitchBlack,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          letterSpacing: 0.4,
                        ),
                      ),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
              memberOption(context, 'Gender'),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.h),
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.h),
                    border: Border.all(
                      color: AppColors.darkTextGrey,
                    )),
                child: DropdownButton(
                  hint: Text(
                    'Choose your gender',
                    style: GoogleFonts.openSans(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  // Not necessary for Option 1
                  value: gender,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  underline: SizedBox(),
                  items: ['male', 'female'].map((location) {
                    return DropdownMenuItem(
                      child: Text(
                        location.toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: AppColors.pitchBlack,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          letterSpacing: 0.4,
                        ),
                      ),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
              memberOption(context, 'Mobile Number'),
              MemberTextField(
                controller: mNumberController,
                keyboardType: TextInputType.number,
              ),
              memberOption(context, 'Work Number'),
              MemberTextField(
                  controller: wNumberController,
                  keyboardType: TextInputType.number),
              memberOption(context, 'Home Address'),
              MemberTextField(
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress),
              memberOption(context, 'Email'),
              MemberTextField(
                  enabled: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress),
              memberOption(context, 'Date of Birth'),
              InkWell(
                onTap: () {
                  chooseDob(context);
                },
                child:
                    MemberTextField(controller: dobController, enabled: false),
              ),
              SizedBox(height: 20.w),
            ],
          ));
    });
  }

  DateTime startDate;

  Future<void> chooseDob(BuildContext context) async {
    Utils.unfocusKeyboard(context);
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1910, 1, 1),
        maxTime: DateTime.now(), onChanged: (date) {
      if (date == null) {
        return;
      }
      startDate = date;

      dobController.text = DateFormat('MMMM dd, yyyy').format(startDate);
      setState(() {});
    }, onConfirm: (date) {
      if (date == null) {
        return;
      }
      startDate = date;

      dobController.text = DateFormat('MMMM dd, yyyy').format(startDate);
      setState(() {});
    }, currentTime: startDate ?? DateTime(2005, 1, 1));
  }

  void doneDialog(
      BuildContext context, AuthViewModel model, Map<String, dynamic> data) {
    Utils.unfocusKeyboard(context);
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(child: Image.asset(Images.info, height: 70.h)),
            SizedBox(height: 15.h),
            regularSansText(context,
                text:
                    'You have made some changes, do you want to save or discard these changes',
                fontSize: 18.sp,
                textAlign: TextAlign.center,
                color: AppColors.black,
                fontWeight: FontWeight.w400),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Discard',
                        fontSize: 14.sp,
                        textColor: AppColors.textGrey,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.textGrey,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        model.editProfile(data);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Save Edits',
                        fontSize: 14.sp,
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.h)),
      ),
    );
  }
}
