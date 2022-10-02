import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/viewmodels/auth_vm.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/error_widget.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

class SelectLocationScreen extends StatefulWidget {
  final TextEditingController controller;

  const SelectLocationScreen({Key key, this.controller}) : super(key: key);

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
        builder: (_, AuthViewModel model, __) => Scaffold(
              appBar: AppBar(
                leading: SizedBox(),
                centerTitle: true,
                title: Text(
                  'Select Location',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  // textAlign: TextAlign.center,
                ),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 24.h,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 10.h)
                ],
                bottom: PreferredSize(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.h, vertical: 6.h),
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      controller: controller,
                      cursorColor: Colors.grey,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      autofocus: true,
                      onChanged: (a) {
                        model.searchLocation(a);
                      },
                      onSaved: (a) {
                        model.searchLocation(a);
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.primaryColor,
                            size: 20.h,
                          ),
                          suffixIcon: controller.text.trim().isEmpty
                              ? null
                              : InkWell(
                                  onTap: () {
                                    controller.clear();
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 20.h,
                                  ),
                                ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.h, vertical: 0),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                          hintText: 'Search...',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.h),
                            borderSide: BorderSide(
                                color: AppColors.primaryColor, width: 1.2.h),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.h),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 1.2.h),
                          ),
                          border: OutlineInputBorder(),
                          counterText: '',
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.h),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 1.2.h),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.h),
                            borderSide: BorderSide(
                                color: Colors.red[300], width: 1.2.h),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.h),
                            borderSide: BorderSide(
                                color: Colors.red[300], width: 1.2.h),
                          )),
                    ),
                  ),
                  preferredSize: Size(MediaQuery.of(context).size.width, 50.h),
                ),
              ),
              body: controller.text.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 40.h),
                            Icon(Icons.search,
                                size: 30.h, color: AppColors.lightTextGrey),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.h),
                              child: regularSansText(context,
                                  text: 'Search for your location',
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.pitchBlack),
                            ),
                          ],
                        )
                      ],
                    )
                  : model.busy
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(29.h),
                              child: CircularProgressIndicator(),
                            )
                          ],
                        )
                      : model.allLocs == null
                          ? ErrorOccurredWidget(error: model.error)
                          : model.allLocs.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 40.h),
                                        Icon(Icons.hourglass_empty_outlined,
                                            size: 30.h,
                                            color: AppColors.lightTextGrey),
                                        SizedBox(height: 20.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40.h),
                                          child: regularSansText(context,
                                              text:
                                                  '"${controller.text}" returns no location',
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.pitchBlack),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : ListView(
                                  children: [
                                    SizedBox(height: 15.h),
                                    ListView.builder(
                                        itemCount: model.allLocs.length,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              //  widget.onChanged;
                                              widget.controller.text =
                                                  model.allLocs[index].location;
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30.h,
                                                    vertical: 8.h),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10.h),
                                                      child: Icon(
                                                          Icons.location_on,
                                                          size: 24.h,
                                                          color: Colors.grey),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        model.allLocs[index]
                                                            .location,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                  ],
                                ),
            ));
  }
}
