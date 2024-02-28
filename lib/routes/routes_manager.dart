import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:titgram/pages/home_page.dart';
import 'package:titgram/pages/login_manager.dart';
import 'package:titgram/pages/login_page.dart';
import 'package:titgram/pages/web_page.dart';

class RoutesManager {
  /// The route configuration.
  static final LoginManager loginManager = LoginManager();
  final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: <RouteBase>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        name: 'channel',
        path: '/channel',
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
        name: 'group',
        path: '/group',
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
        name: 'bot',
        path: '/bot',
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
        name: 'login',
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        name: 'web',
        path: '/web:res',
        builder: (BuildContext context, GoRouterState state) {
          return WebPage(
            config: state.pathParameters,
          );
        },
      ),
      GoRoute(
        name: 'menu',
        path: '/menu',
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
      if (!loginManager.isLoggedIn() && !isComingToLogin) {
        return '/login';
      }
      return null;
    },
    // refreshListenable:
  );
}
