import 'package:get/get.dart';

import '../../modules/borjoniyo/binding/borjoniyo_binding.dart';
import '../../modules/borjoniyo/view/borjoniyo_view.dart';
import '../../modules/dashboard/binding/dashboard_binding.dart';
import '../../modules/dashboard/view/dashboard_view.dart';
import '../../modules/dashboard/widgets/leaderboard_widget.dart';
import '../../modules/dus-list/binding/dua_binding.dart';
import '../../modules/dus-list/view/dua_view.dart';
import '../../modules/home/view/home_view.dart';
import '../../modules/home/binding/home_binding.dart';
import '../../modules/koroniyo/binding/koroniyo_binding.dart';
import '../../modules/koroniyo/view/koroniyo_view.dart';
import '../../modules/login/binding/login_binding.dart';
import '../../modules/login/view/login_view.dart';
import '../../modules/main/binding/main_view_binding.dart';
import '../../modules/main/view/main_view.dart';
import '../../modules/amal_tracker/binding/ramadan_planner_binding.dart';
import '../../modules/amal_tracker/view/amal_tracker_view.dart';
import '../../modules/register/binding/register_binding.dart';
import '../../modules/register/view/register_view.dart';
import '../../modules/tracking_overview/view/tracking_overview_view.dart';
import '../../modules/tracking_overview/binding/tracking_overview_binding.dart';
import '../../modules/prayer_times/view/prayer_times_view.dart';
import '../../modules/prayer_times/binding/prayer_times_binding.dart';
import '../../splash.dart';

class Routes {
  static const splash = '/splash';
  static const home = '/home';
  static const register = '/register';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const ramadanPlanner = '/ramadan-planner';
  static const trackingOverview = '/tracking-overview';
  static const emailVarification = '/email-varification';
  static const profile = '/profile';
  static const leaderboard = '/leaderboard';
  static const tasks = '/tasks';
  static const borjoniyo = '/borjoniyo';
  static const koroniyo = '/koroniyo';
  static const duaList = '/duaList';
  static const prayerTimes = '/prayer-times';

  // Dynamic route generator for single task
  // static String singleTask(String id) => '/task/$id';
}

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      bindings: [
        HomeBinding(), // Ensure HomeController is registered
        PrayerTimesBinding(),
      ],
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.ramadanPlanner,
      page: () => RamadanPlannerView(),
      binding: RamadanPlannerBinding(),
    ),
    GetPage(
      name: Routes.trackingOverview,
      page: () => const TrackingOverviewView(),
      binding: TrackingOverviewBinding(),
    ),
    GetPage(
      name: Routes.leaderboard,
      page: () => LeaderboardWidget(),
      bindings: [RamadanPlannerBinding(), DashboardBinding()],
    ),
    GetPage(
      name: Routes.borjoniyo,
      page: () => BorjoniyoView(),
      binding: BorjoniyoBinding(),
    ),
    GetPage(
      name: Routes.koroniyo,
      page: () => KoroniyoView(),
      binding: KoroniyoBinding(),
    ),
    GetPage(
      name: Routes.duaList,
      page: () => const DuaView(),
      binding: DuaBinding(),
    ),
    GetPage(
      name: Routes.prayerTimes,
      page: () => const PrayerTimesView(),
      binding: PrayerTimesBinding(),
    ),
  ];
}
