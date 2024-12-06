import 'package:civic_voice/components/constants/colors.dart';
import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/controller/db_controller.dart';
import 'package:civic_voice/components/db/db_dashboard_repo.dart';
import 'package:civic_voice/components/theme/theme.dart';
import 'package:civic_voice/dashboard/home_sceen.dart';
import 'package:civic_voice/dashboard/routes/routes.dart';
import 'package:civic_voice/screens/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUrlStrategy(PathUrlStrategy());

  if (kIsWeb) {
    Get.put(DashboardController());
  } else {
    Get.put(DBController());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Civic Voice',
      theme: _theme(context),
      // home: Builder(builder: (context) {
      //   if (kIsWeb) return const HomeScreen();
      //   return const App();
      // }),
      initialRoute: '/auth',
      getPages: routes,
    );
  }

  ThemeData _theme(BuildContext context) {
    return themeData;
  }
}
