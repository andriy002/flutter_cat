import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_cat/pages/main_page.dart';
import 'package:flutter_cat/resources/app_images.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const routeName = '/auth_page';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isHasConnection = true;

  @override
  void initState() {
    _checkInternet();
    super.initState();
  }

  Future<void> _checkInternet() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isHasConnection = true;
      });
    } else {
      setState(() {
        _isHasConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[800],
      body: BlocListener<AuthBloc, AuthInitial>(
        listener: (context, state) {
          if (state.status == BlocStatus.success) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainPage.routeName,
              (_) => false,
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset(
                AppImages.catAuth,
                width: 280.0,
              ),
            ),
            const Text(
              'Sign In pls ;)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34.0,
              ),
            ),
            const SizedBox(
              height: 60.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_isHasConnection) {
                      context.read<AuthBloc>().add(
                            SignInGoogle(),
                          );
                    }
                  },
                  child: Image.asset(
                    AppImages.googleLogo,
                    width: 160.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_isHasConnection) {
                      context.read<AuthBloc>().add(
                            SignInFacebook(),
                          );
                    }
                  },
                  child: Image.asset(
                    AppImages.facebookLogo,
                    width: 110.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
