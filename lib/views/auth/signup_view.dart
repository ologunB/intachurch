import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/views/widgets/text_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  ValueNotifier<int> barListener = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: barListener,
        builder: (a, b, c) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              titleSpacing: 0,
              iconTheme: IconThemeData(color: AppColors.black),
              title: regularSansText(context,
                  text: 'Signup',
                  fontSize: 24.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600),
              elevation: 0.3,
              backgroundColor: AppColors.white,
              centerTitle: false,
            ),
            body: Column(
              children: [
                if (barListener.value != 100)
                  LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    backgroundColor: Colors.white,
                  ),
                Expanded(
                    child: WebView(
                  initialUrl: 'https://intachurch.com/signup',
                  javascriptMode: JavascriptMode.unrestricted,
                  onProgress: (a) {
                    print(a);
                    barListener.value = a;
                  },
                ))
              ],
            ),
          );
        });
  }
}
