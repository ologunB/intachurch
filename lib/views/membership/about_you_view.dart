import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/membership/edit_about_you_view.dart';
import 'package:mms_app/views/membership/widgets/header.dart';
import 'package:mms_app/views/membership/widgets/member_option.dart';
import 'package:mms_app/views/membership/widgets/member_textfield.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';

class AboutYouView extends StatefulWidget {
  const AboutYouView({Key key}) : super(key: key);

  @override
  _AboutYouViewState createState() => _AboutYouViewState();
}

class _AboutYouViewState extends State<AboutYouView> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mNumberController = TextEditingController();
  TextEditingController wNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String dob, loc, bType;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<AuthViewModel>(
        onModelReady: (AuthViewModel model) => model.getProfile(),
        builder: (_, AuthViewModel model, __) {
          fNameController.text =
              model?.userModel?.profile?.firstName?.toTitleCase() ?? '';
          lNameController.text =
              model?.userModel?.profile?.lastName?.toTitleCase() ?? '';
          professionController.text =
              model?.userModel?.profile?.profession?.toTitleCase() ?? '';
          genderController.text =
              model?.userModel?.profile?.gender?.toTitleCase() ?? '';
          mNumberController.text = model?.userModel?.profile?.mobilePhone ?? '';
          wNumberController.text = model?.userModel?.profile?.workNumber ?? '';
          emailController.text = model?.userModel?.email?.toLowerCase() ?? '';
          addressController.text =
              model?.userModel?.profile?.address?.toLowerCase() ?? '';

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(milliseconds: 200), () {});
              return model.getProfile();
            },
            color: AppColors.primaryColor,
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: ListView(
                children: [
                  MemberHeaderItem(
                      title: 'About you',
                      image: Images.aboutYou,
                      isEdit: !model.busy && model.userModel != null,
                      editFtn: () {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    EditAboutYouView(
                                        userModel: model.userModel)));
                      },
                      editColor: AppColors.primaryColor),
                  SizedBox(height: 15.h),
                  memberOption(context, 'Email'),
                  MemberTextField(controller: emailController, enabled: false),
                  memberOption(context, 'First Name'),
                  MemberTextField(controller: fNameController, enabled: false),
                  memberOption(context, 'Last Name'),
                  MemberTextField(controller: lNameController, enabled: false),
                  memberOption(context, 'Profession'),
                  MemberTextField(
                      controller: professionController, enabled: false),
                  memberOption(context, 'Gender'),
                  MemberTextField(controller: genderController, enabled: false),
                  memberOption(context, 'Mobile Number'),
                  MemberTextField(
                      controller: mNumberController, enabled: false),
                  memberOption(context, 'Work Number'),
                  MemberTextField(
                      controller: wNumberController, enabled: false),
                  memberOption(context, 'Home Address'),
                  MemberTextField(
                      controller: addressController, enabled: false),
                  SizedBox(height: 40.h)
                ],
              ),
            ),
          );
        });
  }
}
