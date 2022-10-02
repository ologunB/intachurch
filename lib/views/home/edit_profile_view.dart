import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/home/select_loc_screen.dart';
import 'package:mms_app/views/home/widgets/profile_option.dart';
import 'package:mms_app/views/home/widgets/profile_textfield.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/colors.dart';
import '../../app/size_config/config.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key key, this.userModel}) : super(key: key);
  final LoginData userModel;

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController locController = TextEditingController();
  String dob, bType;
  File imageFile;

  @override
  void initState() {
    fNameController.text =
        widget?.userModel?.profile?.firstName?.toTitleCase() ?? '';
    lNameController.text =
        widget?.userModel?.profile?.lastName?.toTitleCase() ?? '';
    dobController.text = widget?.userModel?.profile?.dob ?? '';
    fullNameController.text =
        widget?.userModel?.profile?.fullName?.toTitleCase() ?? '';
    dob = widget?.userModel?.profile?.dob;
    locController.text = widget?.userModel?.profile?.location;
    bType = widget?.userModel?.profile?.bloodType;
    startDate = widget?.userModel?.profile?.dob == null
        ? null
        : DateTime.tryParse(widget?.userModel?.profile?.dob);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<AuthViewModel>(builder: (_, AuthViewModel model, __) {
      return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0.5,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.black),
            backgroundColor: AppColors.white,
            title: regularSansText(context,
                text: 'Edit Profile',
                fontSize: 20.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w400),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Utils.unfocusKeyboard(context);
                      final Map<String, dynamic> data = <String, dynamic>{};

                      if (dobController.text != widget.userModel.profile.dob) {
                        data.putIfAbsent(
                            'dob', () => startDate?.toIso8601String());
                      }
                      if (locController.text !=
                          widget.userModel.profile.location) {
                        data.putIfAbsent('location', () => locController.text);
                      }

                      if (bType != widget.userModel.profile.bloodType) {
                        data.putIfAbsent('blood_type', () => bType);
                      }

                      if (data.isNotEmpty) {
                        doneDialog(context, model, data);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('No changes have been made')));
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.h),
                          color: AppColors.primaryColor),
                      child: regularSansText(context,
                          text: 'Save',
                          fontSize: 14.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5.w)
            ],
          ),
          body: LoadingOverlay(
            isLoading: model.busy,
            color: AppColors.textGrey,
            progressIndicator: SpinKitFadingCube(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        index.isEven ? AppColors.white : AppColors.primaryColor,
                  ),
                );
              },
              size: 40,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Center(
                    child: Stack(
                      children: [
                        imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(74.h),
                                child: Image.file(imageFile,
                                    height: 74.h,
                                    width: 74.h,
                                    fit: BoxFit.fill),
                              )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(74.h),
                                child: CachedNetworkImage(
                                  imageUrl: widget
                                          ?.userModel?.profile?.picture?.url ??
                                      'null',
                                  height: 74.h,
                                  width: 74.h,
                                  fit: BoxFit.fill,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Container(
                                    height: 74.h,
                                    width: 74.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(74.h)),
                                    child: regularRobotoText(context,
                                        text: 'FL',
                                        fontSize: 24.sp,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  errorWidget: (BuildContext context,
                                          String url, dynamic error) =>
                                      Container(
                                    height: 74.h,
                                    width: 74.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(74.h)),
                                    child: regularRobotoText(context,
                                        text: (fNameController.text.isEmpty
                                                ? 'A'
                                                : fNameController?.text
                                                    ?.substring(0, 1)) +
                                            (lNameController.text.isEmpty
                                                ? 'M'
                                                : lNameController?.text
                                                    ?.substring(0, 1)),
                                        fontSize: 24.sp,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.h)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getImageGallery(model);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(8.h),
                                              child: regularSansText(
                                                context,
                                                text:
                                                    'Choose Image from Gallery',
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getImageCamera(model);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(8.h),
                                              child: regularSansText(
                                                context,
                                                text: 'Take image from Camera',
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                height: 24.h,
                                width: 24.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5.h,
                                        color: AppColors.darkTextGrey),
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(24.h)),
                                child: Icon(Icons.edit_outlined,
                                    size: 10.h, color: AppColors.black)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: regularRobotoText(context,
                      text: widget?.userModel?.email ?? '',
                      fontSize: 16.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400),
                ),
                profileOption(context, 'Full name'),
                ProfileTextField(
                  hintText: 'Enter your full name',
                  enabled: false,
                  controller: fullNameController,
                ),
                profileOption(context, 'Date of birth'),
                InkWell(
                    onTap: () {
                      chooseDob(context);
                    },
                    child: ProfileTextField(
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 24.h,
                          color: Colors.black,
                        ),
                        hintText: 'Enter your birth date',
                        controller: dobController)),
                profileOption(context, 'Location'),
                /*     Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.h),
                      color: AppColors.containerColor.withOpacity(0.5)),
                  child: DropdownButton(
                    hint: Text(
                      'Select your location',
                      style: GoogleFonts.openSans(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    // Not necessary for Option 1
                    value: loc,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        loc = newValue;
                      });
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24.h,
                      color: Colors.black,
                    ),
                    underline: SizedBox(),
                    items: ['Lagos', 'Akure', 'Portharcourt', 'Abuja']
                        .map((location) {
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
                ),*/
                InkWell(
                  onTap: () {
                    Utils.unfocusKeyboard(context);
                    Utils.offKeyboard();
                    routeTo(
                        context,
                        SelectLocationScreen(
                          controller: locController,
                        ),
                        dialog: true);
                  },
                  child: ProfileTextField(
                    hintText: 'Search your location...',
                    enabled: false,
                    controller: locController,
                  ),
                )
                /*    profileOption(context, 'Blood type'),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.h),
                      color: AppColors.containerColor.withOpacity(0.5)),
                  child: DropdownButton(
                    hint: Text(
                      'Select your blood type',
                      style: GoogleFonts.openSans(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24.h,
                      color: Colors.black,
                    ),
                    value: bType,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        bType = newValue;
                      });
                    },
                    underline: SizedBox(),
                    items: ['0', 'X', 'M'].map((location) {
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
                ),*/
              ],
            ),
          ));
    });
  }

  DateTime startDate;

  Future<void> chooseDob(BuildContext context) async {
    Utils.unfocusKeyboard(context);
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1910, 1, 1),
      currentTime: startDate ?? DateTime(2005, 1, 1),
      maxTime: DateTime.now(),
      onChanged: (date) {
        if (date == null) {
          return;
        }
        startDate = date;

        dobController.text = DateFormat('dd MMM, yyyy').format(startDate);
        setState(() {});
      },
      onConfirm: (date) {
        if (date == null) {
          return;
        }
        startDate = date;

        dobController.text = DateFormat('dd MMM, yyyy').format(startDate);
        setState(() {});
      },
    );
  }

  Future<void> chooseReDob(BuildContext context) async {
    Utils.unfocusKeyboard(context);
    await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'DATE OF BIRTH',
    ).then((DateTime date) async {
      if (date == null) {
        return;
      }
      startDate = date;

      dobController.text = DateFormat('dd MMM, yyyy').format(startDate);
      setState(() {});
    });
  }

  Future<void> getImageGallery(AuthViewModel model) async {
    Utils.offKeyboard();
    final PickedFile result =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (result != null) {
      imageFile = File(result.path);
      model.addPicture(imageFile);
    } else {
      return;
    }
    setState(() {});
  }

  Future<void> getImageCamera(AuthViewModel model) async {
    Utils.offKeyboard();
    final PickedFile result =
        await ImagePicker().getImage(source: ImageSource.camera);

    if (result != null) {
      imageFile = File(result.path);
      model.addPicture(imageFile);
    } else {
      return;
    }
    setState(() {});
  }

  void doneDialog(
      BuildContext context, AuthViewModel model, Map<String, dynamic> data) {
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
                        model.editProfile(data);
                        Navigator.pop(context);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.h)),
      ),
    );
  }
}
