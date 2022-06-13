import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_cat/pages/favorite_page/favorive_page.dart';
import 'package:flutter_cat/pages/home_page/home_page.dart';
import 'package:flutter_cat/pages/profile_page/profile_page.dart';

import 'package:flutter_cat/routes/app_router.dart';
import 'package:flutter_cat/widgets/navigation/custom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static const List<String> _pages = [
    HomePage.routeName,
    FavoritePage.routeName,
    ProfilePage.routeName,
  ];

  int _currentTab = 0;

  void _onSelectTab(int index) {
    if (_navigatorKey.currentState != null) {
      if (_currentTab != index) {
        setState(() => _currentTab = index);

        _navigatorKey.currentState!.pushNamedAndRemoveUntil(
          _pages[index],
          (_) => false,
        );
      } else {
        _navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NavigationBloc(),
        ),
      ],
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (_, state) {
          if (state.status == NavigationStateStatus.tab) {
            _onSelectTab(state.tabIndex);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.amber[800],
          body: Navigator(
            key: _navigatorKey,
            initialRoute: HomePage.routeName,
            onGenerateRoute: AppRouter.generateRoute,
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentTab: _currentTab,
            onSelect: _onSelectTab,
          ),
        ),
      ),
    );
  }
}
