import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:titgram/models/channel_model.dart';
import 'package:titgram/pages/channel_page.dart';
import 'package:titgram/pages/channel_view.dart';
import 'package:titgram/pages/home_page.dart';
import 'package:titgram/pages/login_manager.dart';
import 'package:titgram/pages/login_page.dart';
import 'package:titgram/pages/web_page.dart';
import 'package:titgram/routes/routes.dart';

class RoutesManager {
  /// The route configuration.
  static final LoginManager loginManager = LoginManager();
  final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: <RouteBase>[
      GoRoute(
        name: Routes.home,
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: HomePage());
        },
      ),
      GoRoute(
        name: 'channel',
        path: '/channel',
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map<String, dynamic> input = state.extra as Map<String, dynamic>;
          ChannelModel channel = input['channel']! as ChannelModel;
          return MaterialPage(
            child: ChannelPage(selectedChannel: channel),
          );
        },
      ),
      GoRoute(
        name: 'cview',
        path: '/cview:clink',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            child: ChannelView(
              clink: state.pathParameters['clink']!,
            ),
          );
        },
      ),
      GoRoute(
        name: 'discover',
        path: '/discover',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: HomePage());
        },
      ),
      GoRoute(
        name: 'bot',
        path: '/bot',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(child: Container());
        },
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        name: 'web',
        path: '/web:res',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
            child: WebPage(
              config: state.pathParameters,
            ),
          );
        },
      ),
    ],
    errorPageBuilder: (BuildContext context, state) {
      return MaterialPage(
        child: Container(
          alignment: Alignment.center,
          child: const Text("Error"),
        ),
      );
    },
    redirect: (BuildContext context, GoRouterState state) {
      bool isComingToLogin =
          state.path != null && state.path!.contains('login');
      if (!loginManager.isLoggedIn() && !isComingToLogin) {
        return '/login';
      }
      return null;
    },
    // refreshListenable:
  );
}
