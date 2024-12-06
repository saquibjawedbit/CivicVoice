import 'package:civic_voice/dashboard/components/pages/all_user_info.dart';
import 'package:civic_voice/dashboard/components/pages/complaint_info.dart';
import 'package:civic_voice/dashboard/components/pages/notification_page.dart';
import 'package:civic_voice/dashboard/components/pages/settings.dart';
import 'package:civic_voice/dashboard/components/pages/user_info_page.dart';
import 'package:civic_voice/dashboard/home_sceen.dart';
import 'package:civic_voice/screens/authentication/login_screen.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: '/', page: () => const HomeScreen()),
  GetPage(name: '/complains', page: () => const AllUserInfo()),
  GetPage(name: '/user', page: () => const UserInfo()),
  GetPage(name: '/complain', page: () => const ComplaintInfo()),
  GetPage(name: '/settings', page: () => const Settings()),
  GetPage(name: '/notifications', page: () => const NotificationPage()),
  GetPage(name: '/auth', page: () => LoginScreen()),
];
