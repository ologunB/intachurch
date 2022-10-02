import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';
import '../../core/routes/router.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool hasNotification = AppCache.shouldNotify;
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  String dob, loc, bType;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<AuthViewModel>(
        onModelReady: (AuthViewModel model) => model.getProfile(),
        builder: (_, AuthViewModel model, __) {
          fNameController.text =
              model?.userModel?.profile?.firstName?.toTitleCase() ?? 'A';
          lNameController.text =
              model?.userModel?.profile?.lastName?.toTitleCase() ?? 'M';
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(milliseconds: 200), () {});
              return model.getProfile();
            },
            color: AppColors.primaryColor,
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                titleSpacing: 0,
                iconTheme: IconThemeData(color: AppColors.black),
                title: regularSansText(context,
                    text: 'Profile',
                    fontSize: 24.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600),
                elevation: 0.3,
                backgroundColor: AppColors.white,
                centerTitle: false,
              ),
              body: LoadingOverlay(
                isLoading: model.busy,
                color: AppColors.textGrey,
                progressIndicator: SpinKitFadingCube(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? AppColors.white
                            : AppColors.primaryColor,
                      ),
                    );
                  },
                  size: 40,
                ),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(74.h),
                              child: CachedNetworkImage(
                                imageUrl:
                                    model?.userModel?.profile?.picture?.url ??
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
                                      text: fNameController.text
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          lNameController.text
                                              .substring(0, 1)
                                              ?.toUpperCase(),
                                      fontSize: 24.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                errorWidget: (BuildContext context, String url,
                                        dynamic error) =>
                                    Container(
                                  height: 74.h,
                                  width: 74.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(74.h)),
                                  child: regularRobotoText(context,
                                      text: fNameController.text
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          lNameController.text
                                              .substring(0, 1)
                                              ?.toUpperCase(),
                                      fontSize: 24.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: regularRobotoText(context,
                              text: fNameController.text +
                                  ' ' +
                                  lNameController.text,
                              fontSize: 16.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        if (!model.busy && model.userModel != null)
                          InkWell(
                            highlightColor: AppColors.white,
                            onTap: () {
                              routeTo(context,
                                  EditProfileView(userModel: model.userModel));
                            },
                            child: Container(
                              margin: EdgeInsets.all(20.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.h),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20.h)),
                              child: regularRobotoText(context,
                                  text: 'Edit Profile',
                                  fontSize: 14.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Divider(
                        thickness: 1.5.h,
                        color: AppColors.darkTextGrey.withOpacity(.4),
                        height: 0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.h, vertical: 14.h),
                      child: Row(
                        children: [
                          Image.asset(
                            Images.notification2Icon,
                            height: 20.h,
                          ),
                          SizedBox(width: 20.h),
                          Expanded(
                            child: regularRobotoText(context,
                                text: 'Notifications',
                                fontSize: 16.sp,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Switch.adaptive(
                              inactiveTrackColor: Colors.grey.withOpacity(.5),
                              activeColor: AppColors.primaryColor,
                              value: hasNotification,
                              onChanged: (bool val) {
                                hasNotification = val;
                                setState(() {});
                                AppCache.setShouldNotify(val);
                              }),
                        ],
                      ),
                    ),
                    Divider(
                        thickness: 1.5.h,
                        color: AppColors.darkTextGrey.withOpacity(.4),
                        height: 0),
                    Padding(
                      padding: EdgeInsets.all(25.h),
                      child: Row(
                        children: [
                          Image.asset(
                            Images.lockIcon,
                            height: 20.h,
                          ),
                          SizedBox(width: 20.h),
                          regularRobotoText(context,
                              text: 'Privacy',
                              fontSize: 16.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),
                    Divider(
                        thickness: 1.5.h,
                        color: AppColors.darkTextGrey.withOpacity(.4),
                        height: 0),
                    InkWell(
                      onTap: model.busy
                          ? null
                          : () => deleteAccDialog(context, model),
                      child: Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 23.h,
                              color: AppColors.black,
                            ),
                            SizedBox(width: 20.h),
                            /*   model.busy
                                ? SizedBox(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                    height: 20.height,
                                    width: 20.width,
                                  )
                                :*/
                            regularRobotoText(context,
                                text: 'Delete Account',
                                fontSize: 16.sp,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                        thickness: 1.5.h,
                        color: AppColors.darkTextGrey.withOpacity(.4),
                        height: 0),
                    InkWell(
                      onTap: model.busy
                          ? null
                          : () => logoutDialog(context, model),
                      child: Padding(
                        padding: EdgeInsets.all(25.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 20.h,
                              color: AppColors.red,
                            ),
                            SizedBox(width: 20.h),
                            /*   model.busy
                                ? SizedBox(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                    height: 20.height,
                                    width: 20.width,
                                  )
                                :*/
                            regularRobotoText(context,
                                text: 'Logout',
                                fontSize: 16.sp,
                                color: AppColors.red,
                                fontWeight: FontWeight.w400),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1.5.h,
                      color: AppColors.darkTextGrey.withOpacity(.4),
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void logoutDialog(BuildContext context, AuthViewModel model) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10.h),
            regularSansText(context,
                text: 'Are you sure you want to logout?',
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
                        text: 'NO',
                        fontSize: 14.sp,
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        model.logout();
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'YES',
                        fontSize: 14.sp,
                        textColor: AppColors.red,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.h)),
      ),
    );
  }

  TextEditingController delController = TextEditingController();

  void deleteAccDialog(BuildContext context, AuthViewModel model) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10.h),
            regularSansText(context,
                text: 'Why do you want to delete the account?',
                fontSize: 18.sp,
                textAlign: TextAlign.center,
                color: AppColors.black,
                fontWeight: FontWeight.w400),
            SizedBox(height: 10.h),
            TextFormField(
              cursorColor: AppColors.black.withOpacity(0.2),
              cursorWidth: 2.w,
              cursorHeight: 20.h,
              controller: delController,
              style: GoogleFonts.roboto(
                color: AppColors.pitchBlack,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                letterSpacing: 0.4,
              ),
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 15.w,
                ),
                hintText: 'Enter the reasons...',
                hintStyle: GoogleFonts.roboto(
                  color: AppColors.darkTextGrey,
                  fontWeight: FontWeight.w300,
                  fontSize: 14.sp,
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
                  borderSide: BorderSide(
                      color: AppColors.containerColor.withOpacity(0.5)),
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'CANCEL',
                        fontSize: 14.sp,
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        model.deleteUser(reason: delController.text);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'CONFIRM',
                        fontSize: 14.sp,
                        textColor: AppColors.red,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.h)),
      ),
    );
  }
}
