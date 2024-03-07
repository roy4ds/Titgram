import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:titgram/ads/admob/app_open_ad_manager.dart';
import 'package:titgram/incs/reactors/app_lifecycle_reactor.dart';
import 'package:titgram/routes/routes_manager.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  await Hive.openBox('app');
  await Hive.openBox('user');
  setPathUrlStrategy();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

void initPermissionRequests() async {
  Map<Permission, PermissionStatus> perms = await [
    Permission.sms,
    Permission.camera,
    Permission.location,
    Permission.storage,
  ].request();
  perms.clear();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    initPermissionRequests();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd(show: true);
    AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('app').listenable(),
      builder: (context, box, child) {
        bool? isDark = box.get('isdark');
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          theme: ThemeData(
              useMaterial3: true,
              brightness: isDark == null || !isDark
                  ? Brightness.dark
                  : Brightness.light),
          themeMode: isDark == null
              ? ThemeMode.system
              : isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
          routerConfig: RoutesManager().router,
        );
      },
    );
  }
}
