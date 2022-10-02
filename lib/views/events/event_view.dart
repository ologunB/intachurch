import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/events_response.dart';
import 'package:mms_app/core/viewmodels/events_vm.dart';
import 'package:mms_app/views/events/search_view.dart';
import 'package:mms_app/views/events/widgets/event_item.dart';
import 'package:mms_app/views/events/widgets/events_textfield.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/error_widget.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';
import '../../core/routes/router.dart';

ScrollController eventController = ScrollController();

class EventView extends StatefulWidget {
  const EventView({Key key}) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    final EventsViewModel eventProvider =
        Provider.of<EventsViewModel>(context, listen: false);

    SizeConfig.init(context);
    return BaseView<EventsViewModel>(
        onModelReady: (EventsViewModel model) => model.getAllEvents(context),
        builder: (_, EventsViewModel model, __) => Scaffold(
            backgroundColor: AppColors.white,
            body: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 200), () {});
                return model.getAllEvents(context);
              },
              color: AppColors.primaryColor,
              child: model.busy
                  ? eventProvider.contextEvents != null
                      ? _body(eventProvider.contextEvents)
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          child: StaggeredGridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(8.h),
                                child: Shimmer.fromColors(
                                    baseColor: Colors.grey.withOpacity(.1),
                                    highlightColor: Colors.white60,
                                    child: eventItem(context, isLoading: true)),
                              );
                            },
                            gridDelegate:
                                SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 15.h,
                              crossAxisSpacing: 15.h,
                              staggeredTileCount: 10,
                              staggeredTileBuilder: (int index) {
                                return StaggeredTile.count(2, 3);
                              },
                              crossAxisCount: 4,
                            ),
                          ),
                        )
                  : model.allEvents == null
                      ? eventProvider.contextEvents != null
                          ? _body(eventProvider.contextEvents)
                          : ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  height: SizeConfig.screenHeight / 1.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ErrorOccurredWidget(error: model.error),
                                      SizedBox(height: 40.h),
                                      InkWell(
                                        onTap: () {
                                          model.getAllEvents(context);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h,
                                                horizontal: 12.h),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.h),
                                                border: Border.all(
                                                    color: Colors.blueAccent,
                                                    width: 1.h)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                regularSansText(context,
                                                    text: 'RETRY',
                                                    fontSize: 18.sp,
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                SizedBox(width: 10.h),
                                                Icon(
                                                  Icons.refresh_outlined,
                                                  size: 20.h,
                                                  color: Colors.blueAccent,
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                      : model.allEvents.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.hourglass_empty_outlined,
                                      size: 30.h,
                                      color: AppColors.lightTextGrey),
                                  SizedBox(height: 20.h),
                                  Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 40.h),
                          child: regularSansText(context,
                                        text:
                                            'Unfortunately, there are no events currently!',
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.pitchBlack),
                                  ),
                                ],
                              ),
                            )
                          : _body(model.allEvents),
            )));
  }

  Widget _body(List<EventModel> list) {
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  routeTo(context, SearchView());
                },
                highlightColor: AppColors.white,
                child: EventsTextField(
                  hintText: 'Search by event name',
                  enabled: false,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                routeTo(context, SearchView(openFilter: true));
              },
              highlightColor: AppColors.white,
              child: Container(
                  height: 48.h,
                  width: 45.h,
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                      color: AppColors.containerColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.h)),
                  child: Image.asset(Images.filter, height: 16.h, width: 18.w)),
            ),
            SizedBox(width: 15.h)
          ],
        ),
        Padding(
          padding: EdgeInsets.all(15.h),
          child: StaggeredGridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              physics: ClampingScrollPhysics(),
              children: list.map<Widget>((EventModel item) {
                return eventItem(context, eventModel: item);
              }).toList(),
              staggeredTiles: list
                  .map<StaggeredTile>((_) => const StaggeredTile.fit(2))
                  .toList(),
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 15.h),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
