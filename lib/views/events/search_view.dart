import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/events_response.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/viewmodels/events_vm.dart';
import 'package:mms_app/views/events/filter_view.dart';
import 'package:mms_app/views/events/widgets/event_item.dart';
import 'package:mms_app/views/events/widgets/events_textfield.dart';
import 'package:mms_app/views/widgets/base_view.dart';
import 'package:mms_app/views/widgets/error_widget.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:mms_app/views/widgets/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/colors.dart';
import '../../app/constants.dart';
import '../../app/size_config/config.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key key, this.openFilter = false}) : super(key: key);

  final bool openFilter;

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BaseView<EventsViewModel>(
        builder: (_, EventsViewModel model, __) => GestureDetector(
              onTap: Utils.offKeyboard,
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  elevation: 0.3,
                  iconTheme: IconThemeData(color: AppColors.black),
                  backgroundColor: AppColors.white,
                  centerTitle: true,
                  title: regularSansText(context,
                      text: 'Search',
                      fontSize: 20.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400),
                ),
                body: BaseView<EventsViewModel>(
                    onModelReady: (EventsViewModel m) {
                      if (widget.openFilter)
                        Future.delayed(Duration(milliseconds: 1000), () {
                          openFilter(context);
                        });
                    },
                    builder: (_, EventsViewModel model, __) => ListView(
                          children: [
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: EventsTextField(
                                    hintText: 'Search by event name',
                                    controller: searchController,
                                    focus: !widget.openFilter,
                                    focusNode: focusNode,
                                    textInputAction: TextInputAction.search,
                                    onChanged: (a) {
                                      model.searchEvents(a);
                                    },
                                    onSaved: (a) {
                                      model.searchEvents(a);
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () => openFilter(context),
                                  child: Container(
                                      height: 48.h,
                                      width: 45.h,
                                      padding: EdgeInsets.all(12.h),
                                      decoration: BoxDecoration(
                                          color: AppColors.containerColor
                                              .withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(8.h)),
                                      child: Image.asset(Images.filter,
                                          height: 16.h, width: 18.w)),
                                ),
                                SizedBox(width: 15.h)
                              ],
                            ),
                            if (searchController.text.isEmpty)
                              Padding(
                                padding: EdgeInsets.all(15.h),
                                child: regularSansText(context,
                                    text: 'Recent searches',
                                    fontSize: 20.sp,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            searchController.text.isEmpty
                                ? AppCache.getRecentSearches().isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10.h,
                                            left: 15.h,
                                            right: 15.h),
                                        child: regularSansText(context,
                                            text: 'No recent searches',
                                            fontSize: 15.sp,
                                            color: AppColors.textGrey,
                                            fontWeight: FontWeight.w400),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.h),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                AppCache.getRecentSearches()
                                                    .length,
                                            physics: ClampingScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  searchController
                                                      .text = AppCache
                                                          .getRecentSearches()[
                                                      index];
                                                  model.searchEvents(
                                                      searchController.text);

                                                  searchController.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset:
                                                                  searchController
                                                                      .text
                                                                      .length));
                                                  focusNode.requestFocus();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5.h,
                                                      left: 5.h,
                                                      bottom: 5.h),
                                                  child: regularSansText(
                                                      context,
                                                      text: AppCache
                                                              .getRecentSearches()[
                                                          index],
                                                      fontSize: 15.sp,
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              );
                                            }),
                                      )
                                : model.busy
                                    ? Padding(
                                        padding: EdgeInsets.all(15.h),
                                        child: StaggeredGridView.count(
                                            shrinkWrap: true,
                                            crossAxisCount: 4,
                                            physics: ClampingScrollPhysics(),
                                            children: tenItems
                                                .map<Widget>((String item) {
                                              return Padding(
                                                padding: EdgeInsets.all(8.h),
                                                child: Shimmer.fromColors(
                                                    baseColor: Colors.grey
                                                        .withOpacity(.2),
                                                    highlightColor:
                                                        Colors.white60,
                                                    child: eventItem(context,
                                                        isLoading: true)),
                                              );
                                            }).toList(),
                                            staggeredTiles: tenItems
                                                .map<StaggeredTile>((_) =>
                                                    const StaggeredTile.fit(2))
                                                .toList(),
                                            mainAxisSpacing: 15.h,
                                            crossAxisSpacing: 15.h),
                                      )
                                    : model.allEvents == null
                                        ? ErrorOccurredWidget(
                                            error: model.error)
                                        : model.allEvents.isEmpty
                                            ? Container(
                                                height:
                                                    SizeConfig.screenHeight / 2,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                        Icons
                                                            .hourglass_empty_outlined,
                                                        size: 30.h,
                                                        color: AppColors
                                                            .lightTextGrey),
                                                    SizedBox(height: 20.h),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 40.h),
                                                      child: regularSansText(
                                                          context,
                                                          text:
                                                              'Search returns no event',
                                                          fontSize: 16.sp,
                                                          textAlign:
                                                              TextAlign.center,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .pitchBlack),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.all(15.h),
                                                child: StaggeredGridView.count(
                                                    shrinkWrap: true,
                                                    crossAxisCount: 4,
                                                    physics:
                                                        ClampingScrollPhysics(),
                                                    children: model.allEvents
                                                        .map<Widget>(
                                                            (EventModel item) {
                                                      return eventItem(context,
                                                          eventModel: item,
                                                          search:
                                                              searchController
                                                                  .text);
                                                    }).toList(),
                                                    staggeredTiles: model
                                                        .allEvents
                                                        .map<StaggeredTile>((_) =>
                                                            const StaggeredTile
                                                                .fit(2))
                                                        .toList(),
                                                    mainAxisSpacing: 15.h,
                                                    crossAxisSpacing: 15.h),
                                              ),
                          ],
                        )),
              ),
            ));
  }

  void openFilter(BuildContext context) {
    Utils.offKeyboard();
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (_) => FilterView());
  }

  List<String> tenItems = ['', '', '', '', '', '', '', '', '', ''];
}
