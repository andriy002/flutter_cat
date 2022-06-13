import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat/blocs/auth/auth_bloc.dart';
import 'package:flutter_cat/models/user_model/user_model.dart';
import 'package:flutter_cat/pages/auth_page/auth_page.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:flutter_cat/widgets/navigation/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;

  final _textStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
  );

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  Future<void> _setInitialData() async {
    final SharedPreferences sh = await SharedPreferences.getInstance();
    if (sh.getString('profile') != null) {
      setState(() {
        final userJson = jsonDecode(sh.getString('profile')!);
        user = UserModel.fromJson(userJson);
      });
    }
  }

  Future<void> _logOut(BuildContext context) async {
    final SharedPreferences sh = await SharedPreferences.getInstance();

    await sh.clear();

    Navigator.of(context, rootNavigator: true)
        .pushReplacementNamed(AuthPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: Text('Profile'),
        ),
        body: BlocListener<AuthBloc, AuthInitial>(
          listener: (context, state) {
            if (state.status == BlocStatus.success) {
              _logOut(context);
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 80.0,
                  ),
                  ClipOval(
                    child: Container(
                      width: 160.0,
                      color: Colors.amber[800],
                      height: 160.0,
                      child: user?.photoUrl != null
                          ? CachedNetworkImage(
                              imageUrl: user!.photoUrl!,
                              fit: BoxFit.contain,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  if (user?.name != null)
                    Text(
                      user!.name!,
                      style: _textStyle,
                    ),
                  if (user?.email != null)
                    Text(
                      user!.email!,
                      style: _textStyle,
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(
                            LogOut(),
                          );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.red[600],
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
