import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat/blocs/auth/auth_bloc.dart';
import 'package:flutter_cat/pages/auth_page/auth_page.dart';
import 'package:flutter_cat/pages/main_page.dart';
import 'package:flutter_cat/repositories/cat_api_repositories/cat_api_repositories.dart';

import 'package:flutter_cat/repositories/cat_fact_repositories/cat_fact_repositories.dart';
import 'package:flutter_cat/repositories/firebase_repositories/firebase_repositories.dart';
import 'package:flutter_cat/resources/app_themes.dart';
import 'package:flutter_cat/routes/app_router.dart';
import 'package:flutter_cat/services/cache_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheServices.instance.setInitState();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const FlutterCat(),
  );
}

class FlutterCat extends StatelessWidget {
  const FlutterCat({Key? key}) : super(key: key);

  static final CatApiRepository _catRepository = CatApiRepository();
  static final CatFactRepository _catFactRepository = CatFactRepository();
  static final FireBaseRepositories _fireBaseRepositories =
      FireBaseRepositories();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CatApiRepository>(
          create: (_) => _catRepository,
        ),
        RepositoryProvider<CatFactRepository>(
          create: (_) => _catFactRepository,
        ),
        RepositoryProvider<FireBaseRepositories>(
          create: (_) => _fireBaseRepositories,
        ),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          fireBaseRepositories: context.read<FireBaseRepositories>(),
        ),
        child: MaterialApp(
          title: 'Flutter Cat',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light(),
          home: FirebaseAuth.instance.currentUser == null
              ? const AuthPage()
              : const MainPage(),
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
