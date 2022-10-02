import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/events_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';

import '../event_details.dart';

Widget eventItem(BuildContext context,
    {EventModel eventModel, bool isLoading = false, String search}) {
  SizeConfig.init(context);

  return InkWell(
    onTap: isLoading
        ? null
        : () {
            AppCache.saveRecentSearch(search);
            routeTo(context, EventDetailsView(model: eventModel));
          },
    highlightColor: AppColors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8.h),
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(.65)
                    ]).createShader(bounds);
              },
              blendMode: BlendMode.darken,
              child: CachedNetworkImage(
                imageUrl: eventModel?.pictures == null
                    ? 'null'
                    : eventModel?.pictures[0]?.url,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) => Image.asset(
                  Images.eventBg,
                  fit: BoxFit.cover,
                ),
                errorWidget:
                    (BuildContext context, String url, dynamic error) =>
                        Image.asset(
                  Images.eventBg,
                  fit: BoxFit.cover,
                ),
              ),
            )),
        regularSansText(context,
            text: eventModel?.title ?? 'Sunday School',
            fontSize: 16.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w600),
        regularSansText(context,
            text: formatDate(eventModel?.startDate, eventModel?.startTime) ??
                'Jan 12th  ●  02:50PM',
            fontSize: 14.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w400),
      ],
    ),
  );
}

String formatDate(String a, String b) {
  if (a == null || b == null) {
    return null;
  }
  return DateFormat('EEE, MMM. dd  ● ').format(DateTime.parse(a)) + b;
}
