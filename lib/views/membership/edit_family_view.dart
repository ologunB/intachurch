import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/connect_model.dart';
import 'package:mms_app/core/models/family_tree_response.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/families_vm.dart';
import 'package:mms_app/views/membership/widgets/header.dart';
import 'package:mms_app/views/membership/widgets/member_option.dart';
import 'package:mms_app/views/membership/widgets/member_textfield.dart';
import 'package:mms_app/views/membership/widgets/textfield_user_search.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';

class EditFamilyView extends StatefulWidget {
  const EditFamilyView({Key key}) : super(key: key);

  @override
  _EditFamilyViewState createState() => _EditFamilyViewState();
}

class _EditFamilyViewState extends State<EditFamilyView> {
  bool isAdding = false;
  String myStand = AppCache.myRelationship;

  TextEditingController fNameController;
  TextEditingController dobController;
  final ScrollController _scrollController = ScrollController();

  TextEditingController lNameController;

  GlobalKey<ScaffoldState> scafoldKey = GlobalKey<ScaffoldState>();

  Profile partnerProfile, adultProfile;
  bool isAdult = false;
  String title = 'First Name';

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<FamiliesViewModel>(onModelReady: (FamiliesViewModel model) {
      model.getSentConnects();
      model.getFamilyTree();
    }, builder: (_, FamiliesViewModel model, __) {
      return Scaffold(
        backgroundColor: AppColors.white,
        key: scafoldKey,
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
            controller: _scrollController,
            children: [
              MemberHeaderItem(
                  title: 'Family',
                  image: Images.family,
                  isEdit: null,
                  editColor: AppColors.red),
              SizedBox(height: 15.h),
              memberOption(context, "My Position"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.h),
                    border: Border.all(color: AppColors.textGrey)),
                child: DropdownButton(
                  value: myStand,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      myStand = newValue;
                      AppCache.setMyRelationship(myStand);
                    });
                    model.getFamilyTree();
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 24.h,
                    color: Colors.black,
                  ),
                  underline: SizedBox(),
                  items: ['Father', 'Mother'].map((location) {
                    return DropdownMenuItem(
                      child: Text(
                        location,
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
              SizedBox(height: 10.h),
              memberOption(context, "Partner's Name"),
              BaseView<FamiliesViewModel>(
                  builder: (_, FamiliesViewModel spouseModel, __) => Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.h),
                              child: TextFieldUserSearch(
                                hintText: "Partner's Name",
                                minStringLength: 1,
                                controller: model.partnerController,
                                future: () async {
                                  await spouseModel.searchUsers(
                                      model.partnerController.text);
                                  return spouseModel.allUsers.length < 5
                                      ? spouseModel.allUsers
                                      : spouseModel.allUsers.sublist(0, 5);
                                },
                                selectedValue: (Profile a) {
                                  partnerProfile = a;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () async {
                                if (partnerProfile == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: regularSansText(
                                      context,
                                      text:
                                          'Search for your partner or add them to the church',
                                      color: AppColors.white,
                                      fontSize: 14.h,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    backgroundColor: AppColors.textGrey,
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                  return;
                                }
                                Utils.offKeyboard();
                                Map<String, dynamic> data = {
                                  "spouseName":
                                      partnerProfile.firstName.toLowerCase() +
                                          ' ' +
                                          partnerProfile.lastName.toLowerCase(),
                                  "spouseId": partnerProfile.userId,
                                  "yourFamilyPosition": myStand.toLowerCase()
                                };
                                bool isTrue = await model.addSpouse(data);

                                if (isTrue) {
                                  model.sentConnects.add(
                                    ConnectData(
                                      isSpousalConnection: false,
                                      status: 'pending',
                                      receiverName: data['spouseName'],
                                    ),
                                  );
                                  fNameController.text = '';
                                  lNameController.text = '';
                                  dobController.text = '';
                                  startDate = DateTime(2005);
                                  isAdding = !isAdding;
                                }
                              },
                              child: buttonWithBorder(
                                context,
                                text: 'Save Partner',
                                fontSize: 14.sp,
                                textColor: AppColors.white,
                                buttonColor: AppColors.primaryColor,
                                borderColor: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.h),
                        ],
                      )),
              memberOption(context, 'Child(ren)'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: (model?.childrenList?.isEmpty ?? true)
                    ? regularSansText(context,
                        text:
                            'No children added. Click the button below to add new child',
                        fontSize: 14.sp,
                        color: AppColors.lightTextGrey,
                        fontWeight: FontWeight.w400)
                    : ListView.builder(
                        itemCount: model?.childrenList?.length ?? 0,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              regularSansText(context,
                                  text:
                                      '${index + 1}. ${model.childrenList[index].profile.fullName.toTitleCase()}\n',
                                  fontSize: 14.sp,
                                  color: AppColors.lightTextGrey,
                                  fontWeight: FontWeight.w400),
                              Container(
                                padding: EdgeInsets.all(5.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.h),
                                    color: Colors.lightGreenAccent),
                                child: regularSansText(context,
                                    text: 'APPROVED',
                                    fontSize: 11.sp,
                                    color: AppColors.lightTextGrey,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          );
                        }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: ListView.builder(
                    itemCount: model?.sentConnects?.length ?? 0,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return model?.sentConnects[index].status.toLowerCase() !=
                              'pending'
                          ? SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                regularSansText(context,
                                    text:
                                        '${(model?.childrenList?.length ?? 0) + index + 1}. ${model?.sentConnects[index].receiverName?.toTitleCase()}\n',
                                    fontSize: 14.sp,
                                    color: AppColors.lightTextGrey,
                                    fontWeight: FontWeight.w400),
                                Container(
                                  padding: EdgeInsets.all(5.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.h),
                                      color: Color(0xffFFF0B3)),
                                  child: regularSansText(context,
                                      text: 'PENDING',
                                      fontSize: 11.sp,
                                      color: AppColors.lightTextGrey,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            );
                    }),
              ),
              isAdding
                  ? ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(height: 15.h),
                        BaseView<FamiliesViewModel>(
                            builder: (_, FamiliesViewModel fNameModel, __) =>
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 15.h),
                                  child: TextFieldUserSearch(
                                      label: title,
                                      minStringLength: 1,
                                      controller: fNameController,
                                      selectedValue: (Profile a) {
                                        adultProfile = a;
                                        isAdult = true;
                                        title = 'Full Name';
                                        setState(() {});
                                      },
                                      future: () async {
                                        adultProfile = null;
                                        isAdult = false;
                                        title = 'First Name';
                                        lNameController.text = '';
                                        dobController.text = '';
                                        startDate = DateTime(2005);
                                        setState(() {});
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 500));
                                        await fNameModel
                                            .searchUsers(fNameController.text);

                                        return fNameModel.allUsers.length < 5
                                            ? fNameModel.allUsers
                                            : fNameModel.allUsers.sublist(0, 5);
                                      }),
                                )),
                        if (!isAdult)
                          Column(
                            children: [
                              SizedBox(height: 15.h),
                              BaseView<FamiliesViewModel>(
                                  builder:
                                      (_, FamiliesViewModel lNameModel, __) =>
                                          MemberTextField(
                                            labelText: 'Last Name',
                                            controller: lNameController,
                                          )),
                              SizedBox(height: 15.h),
                              InkWell(
                                onTap: () {
                                  chooseDob(context);
                                },
                                child: MemberTextField(
                                  labelText: 'Date of Birth',
                                  hintText: '-- select date of birth --',
                                  controller: dobController,
                                  enabled: false,
                                ),
                              ),
                            ],
                          ),
                        Padding(
                            padding: EdgeInsets.all(15.h),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (adultProfile != null) {
                                      over16OnDialog(context, model);
                                    } else {
                                      if (dobController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: regularSansText(
                                            context,
                                            text: 'Choose the date of Birth',
                                            color: AppColors.white,
                                            fontSize: 14.h,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          backgroundColor: AppColors.textGrey,
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                        return;
                                      }
                                      if (fNameController.text.trim().isEmpty ||
                                          lNameController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: regularSansText(
                                            context,
                                            text: 'Fill all fields',
                                            color: AppColors.white,
                                            fontSize: 14.h,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          backgroundColor: AppColors.textGrey,
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                        return;
                                      }
                                      int age = startDate
                                          .difference(DateTime.now())
                                          .inDays
                                          .abs();
                                      print(age / 365);
                                      if (age > 5844) {
                                        //more than 16 years
                                        over16ONotOnDialog(context);
                                      } else {
                                        under16NotOnDialog(context, model);
                                      }
                                    }
                                  },
                                  child: buttonWithBorder(
                                    context,
                                    text: 'Add Child',
                                    fontSize: 14.sp,
                                    textColor: AppColors.white,
                                    buttonColor: AppColors.primaryColor,
                                    borderColor: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                InkWell(
                                  onTap: () {
                                    dobController = TextEditingController();
                                    fNameController = TextEditingController();
                                    lNameController = TextEditingController();
                                    isAdding = !isAdding;
                                    setState(() {});
                                  },
                                  child: buttonWithBorder(
                                    context,
                                    text: 'CANCEL',
                                    fontSize: 14.sp,
                                    textColor: AppColors.white,
                                    buttonColor: AppColors.red,
                                    borderColor: AppColors.red,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      child: InkWell(
                        onTap: () {
                          dobController = TextEditingController();
                          fNameController = TextEditingController();
                          lNameController = TextEditingController();
                          isAdding = !isAdding;
                          setState(() {});
                        },
                        child: buttonWithBorder(
                          context,
                          text: 'Add Child',
                          fontSize: 14.sp,
                          textColor: AppColors.black,
                          buttonColor: AppColors.textGrey.withOpacity(.5),
                          borderColor: AppColors.textGrey.withOpacity(.5),
                        ),
                      )),
              SizedBox(height: 100.h)
            ],
          ),
        ),
      );
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

  void under16NotOnDialog(BuildContext context, FamiliesViewModel model) async {
    Utils.unfocusKeyboard(context);
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20.h),
            Container(
              height: 60.h,
              width: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: Color(0xffFFF8E5),
              ),
            ),
            SizedBox(height: 20.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'The child is under 16, a sub account will be created under your name.',
                style: GoogleFonts.roboto(
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        Map<String, dynamic> data = {
                          "firstName": fNameController.text,
                          "lastName": lNameController.text,
                          "dob": startDate.toIso8601String(),
                          "yourFamilyPosition": myStand.toLowerCase()
                        };
                        bool isSucc = await model.addChild(data);
                        if (isSucc) {
                          model.childrenList.add(Members(
                            profile: Profile(
                                fullName:
                                    data['firstName'] + ' ' + data['lastName']),
                          ));
                          fNameController.text = '';
                          lNameController.text = '';
                          dobController.text = '';
                          startDate = DateTime(2005);
                          isAdding = !isAdding;
                        }
                        setState(() {});
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Create a sub account',
                        fontSize: 14.sp,
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Flexible(
                    flex: 3,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Cancel',
                        fontSize: 14.sp,
                        textColor: AppColors.textGrey,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.textGrey,
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

  void over16ONotOnDialog(BuildContext context) {
    Utils.unfocusKeyboard(context);
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                        color: AppColors.textGrey,
                        borderRadius: BorderRadius.circular(30.h)),
                    child: Icon(
                      Icons.close,
                      size: 15.h,
                      color: AppColors.black,
                    )),
              ),
            ),
            Container(
              height: 60.h,
              width: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: Color(0xffFFF8E5),
              ),
            ),
            SizedBox(height: 20.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'The child is above 16, kindly tell them to open an account and they will be available to be added as part of the family.',
                style: GoogleFonts.roboto(
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.h)),
      ),
    );
  }

  void over16OnDialog(BuildContext context, FamiliesViewModel model) {
    String fullName = adultProfile.firstName + ' ' + adultProfile.lastName;
    Utils.unfocusKeyboard(context);
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            regularSansText(context,
                text: 'Add a Child',
                fontSize: 18.sp,
                textAlign: TextAlign.center,
                color: AppColors.black,
                fontWeight: FontWeight.w600),
            SizedBox(height: 15.h),
            RichText(
              text: TextSpan(
                  text: 'You are about to add ',
                  style: GoogleFonts.roboto(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: fullName,
                      style: GoogleFonts.nunito(
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' as a child and therefore a family member, to do this, we will need to send a confirmation request to $fullName, once they accept, they will be added immediately as a child.',
                      style: GoogleFonts.nunito(
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        Map<String, dynamic> data = {
                          "childName":
                              (adultProfile?.firstName?.toLowerCase() ?? '') +
                                  ' ' +
                                  (adultProfile?.lastName?.toLowerCase() ?? ''),
                          "childId": adultProfile?.userId,
                          "yourFamilyPosition": myStand?.toLowerCase()
                        };

                        print(data['childName']);
                        bool isTrue = await model.addAdult(data);

                        if (isTrue) {
                          model.sentConnects.add(
                            ConnectData(
                              isSpousalConnection: false,
                              status: 'pending',
                              receiverName: data['childName'],
                            ),
                          );
                          fNameController.text = '';
                          lNameController.text = '';
                          dobController.text = '';
                          startDate = DateTime(2005);
                          isAdding = !isAdding;
                        }
                        setState(() {});
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Send Request',
                        fontSize: 14.sp,
                        textColor: AppColors.white,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: buttonWithBorder(
                        context,
                        text: 'Cancel',
                        fontSize: 14.sp,
                        textColor: AppColors.textGrey,
                        buttonColor: AppColors.white,
                        borderColor: AppColors.textGrey,
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
