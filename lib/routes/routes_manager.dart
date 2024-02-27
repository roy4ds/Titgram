import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:titgram/pages/home_page.dart';
import 'package:titgram/pages/login_manager.dart';
import 'package:titgram/pages/web_page.dart';

class RoutesManager {
  /// The route configuration.
  static final LoginManager loginManager = LoginManager();
  final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/channel',
        name: 'channel',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              return Container();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/group',
        name: 'group',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              return Container();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/bot',
        name: 'bot',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              return Container();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/web',
        name: 'web',
        builder: (BuildContext context, GoRouterState state) {
          return const WebPage();
        },
      ),
      GoRoute(
        path: '/menu',
        name: 'menu',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              return Container();
            },
          ),
        ],
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
      if (!loginManager.isLoggedIn() && !isComingToLogin) return '/login';
      return null;
    },
    // refreshListenable:
  );
}
