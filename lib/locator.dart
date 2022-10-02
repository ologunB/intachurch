import 'package:get_it/get_it.dart';
import 'package:mms_app/core/api/families_api.dart';
import 'package:mms_app/core/viewmodels/video_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/api/auth_api.dart';
import 'core/api/event_api.dart';
import 'core/api/video_api.dart';
import 'core/utils/dialog_service.dart';
import 'core/utils/navigator.dart';
import 'core/viewmodels/auth_vm.dart';
import 'core/viewmodels/events_vm.dart';
import 'core/viewmodels/families_vm.dart';
import 'core/viewmodels/onboard_vm.dart';
import 'core/viewmodels/splash_vm.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());

  locator.registerFactory(() => SplashViewModel());
  locator.registerFactory(() => OnboardingViewModel());

  locator.registerLazySingleton(() => AuthApi());
  locator.registerFactory(() => AuthViewModel());

  locator.registerLazySingleton(() => EventApi());
  locator.registerFactory(() => EventsViewModel());

  locator.registerLazySingleton(() => FamiliesApi());
  locator.registerFactory(() => FamiliesViewModel());

  locator.registerLazySingleton(() => VideoApi());
  locator.registerFactory(() => VideoViewModel());
}

final List<SingleChildWidget> allProviders = <SingleChildWidget>[
  ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
  ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => OnboardingViewModel()),
  ChangeNotifierProvider<VideoViewModel>(create: (_) => VideoViewModel()),
  ChangeNotifierProvider<EventsViewModel>(create: (_) => EventsViewModel()),
];
