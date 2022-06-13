import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cat/models/user_model/user_model.dart';
import 'package:flutter_cat/services/cache_service.dart';

class FirestoreRepositories {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<bool?> saveLike({
    required String imageId,
    required int favoriteId,
  }) async {
    final UserModel? user = await CacheServices.instance.getUser();

    try {
      await _users.doc(user!.uid).collection('likedImage').doc(imageId).set(
        {'favoriteId': favoriteId},
      );
      return true;
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<bool?> removeLike({
    required String imageId,
  }) async {
    final UserModel? user = await CacheServices.instance.getUser();

    try {
      await _users
          .doc(user!.uid)
          .collection('likedImage')
          .doc(imageId)
          .delete();
      return true;
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<int?> getFavoriteId({
    required String imageId,
  }) async {
    final UserModel? user = await CacheServices.instance.getUser();

    try {
      final DocumentSnapshot<Map<String, dynamic>> liked = await _users
          .doc(user!.uid)
          .collection('likedImage')
          .doc(imageId)
          .get();

      if (liked.data() != null) {
        return liked.data()!['favoriteId'] as int;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}
