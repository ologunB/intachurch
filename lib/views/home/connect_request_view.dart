import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/connect_model.dart';
import 'package:mms_app/core/viewmodels/families_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/buttons.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../../app/colors.dart';
import '../../app/size_config/config.dart';
import '../main_layout.dart';

class ConnectionRequestView extends StatefulWidget {
  const ConnectionRequestView({Key key, this.connectData}) : super(key: key);

  final ConnectData connectData;

  @override
  _ConnectionRequestViewState createState() => _ConnectionRequestViewState();
}

class _ConnectionRequestViewState extends State<ConnectionRequestView> {
  ConnectData connectData;

  @override
  void initState() {
    connectData = widget.connectData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BaseView<FamiliesViewModel>(
        builder: (_, FamiliesViewModel model, __) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0.5,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => MainLayout()));
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: AppColors.black,
                size: 24.h,
              ),
            ),
            iconTheme: IconThemeData(color: AppColors.black),
            backgroundColor: AppColors.white,
            title: regularSansText(context,
                text: 'Notification',
                fontSize: 20,
                color: AppColors.black,
                fontWeight: FontWeight.w400),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.h, vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      regularRobotoText(context,
                          text: 'Connection Request',
                          fontSize: 16.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500),
                      regularRobotoText(context,
                          text: DateFormat('MMM dd, mm:ss a')
                              .format(DateTime.parse(connectData.createdAt)),
                          fontSize: 12.sp,
                          color: AppColors.darkTextGrey,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
                    child: RichText(
                      text: TextSpan(
                          text:
                              '${connectData.receiverName}, ${connectData.senderName} has added you as a ${connectData.receiverFamilyPosition} on their app, we need your confirmation to make this done. Kindly accept or reject this request below. You can also view the profile of ${connectData.senderName}',
                          style: GoogleFonts.roboto(
                            fontSize: 12.w,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' here',
                              style: GoogleFonts.nunito(
                                fontSize: 12.w,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ]),
                    )),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
                  child: model.isAccepted != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/hurray.png',
                                height: 115.h),
                            SizedBox(height: 20.h),
                            regularRobotoText(
                              context,
                              text: model.isAccepted
                                  ? 'Hurray! you have been added as a ${connectData.receiverFamilyPosition}}\nof ${connectData.senderName}'
                                  : 'You rejected the connection to ${connectData.senderName}',
                              fontSize: 12.sp,
                              textAlign: TextAlign.center,
                              color: AppColors.darkTextGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  model.acceptConnect(connectData.id);
                                },
                                child: buttonWithBorder(
                                  context,
                                  text: 'Accept',
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
                                  model.rejectConnect(connectData.id);
                                },
                                child: buttonWithBorder(
                                  context,
                                  text: 'Reject',
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
          ),
        ),
      );
    });
  }
}
