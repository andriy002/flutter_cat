import 'package:flutter/material.dart';
import 'package:flutter_cat/pages/auth_page/auth_page.dart';
import 'package:flutter_cat/pages/favorite_page/favorive_page.dart';
import 'package:flutter_cat/pages/home_page/home_page.dart';
import 'package:flutter_cat/pages/main_page.dart';
import 'package:flutter_cat/pages/profile_page/profile_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
      case MainPage.routeName:
        builder = (_) => const MainPage();
        break;

      case HomePage.routeName:
        builder = (_) => const HomePage();
        break;

      case FavoritePage.routeName:
        builder = (_) => const FavoritePage();
        break;

      case ProfilePage.routeName:
        builder = (_) => const ProfilePage();
        break;

      case AuthPage.routeName:
        builder = (_) => const AuthPage();
        break;

      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
