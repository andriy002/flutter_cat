import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cat/models/user_model/user_model.dart';
import 'package:flutter_cat/services/cache_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseRepositories {
  static final _firebaseAuth = FirebaseAuth.instance;

  Future<bool?> signInGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? signIn = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await signIn!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      CacheServices.instance.setElement(
        key: 'profile',
        value: UserModel(
          name: _firebaseAuth.currentUser!.displayName,
          photoUrl: _firebaseAuth.currentUser!.photoURL,
          email: _firebaseAuth.currentUser!.email,
          uid: _firebaseAuth.currentUser!.uid,
        ),
      );
      return true;
    } catch (e) {
      log(
        e.toString(),
      );
    }

    return null;
  }

  Future<bool?> signInFacebook() async {
    final LoginResult? loginResult = await FacebookAuth.instance.login();

    if (loginResult?.accessToken != null) {
      final String accessToken = loginResult!.accessToken!.token;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken);

      try {
        await FirebaseAuth.instance.signInWithCredential(credential);

        CacheServices.instance.setElement(
          key: 'profile',
          value: UserModel(
            name: _firebaseAuth.currentUser!.displayName,
            photoUrl: _firebaseAuth.currentUser!.photoURL,
            email: _firebaseAuth.currentUser!.email,
            uid: _firebaseAuth.currentUser!.uid,
          ),
        );

        return true;
      } catch (e) {
        log(
          e.toString(),
        );
      }
    }

    return null;
  }

  Future<bool?> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}
