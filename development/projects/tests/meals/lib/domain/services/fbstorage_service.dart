import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meals/domain/models/meal.dart';

import '../models/user.dart';

class FBStorageService {
  FBStorageService._();

  static final FBStorageService instance = FBStorageService._();

  Future<String> addProfilePicture(File file, String uid, String familyId) async {
    final _userProfilePictures =
        FirebaseStorage.instance.ref('$familyId/$uid/profile');
    final uploadSnapshot = await _userProfilePictures.putFile(file);
    if (uploadSnapshot.state != TaskState.success) {
      throw ('upload picture: ${uploadSnapshot.state.name}');
    }
    final imgFullPath = uploadSnapshot.metadata!.fullPath;
    final downloadURL =
        await _userProfilePictures.child(imgFullPath).getDownloadURL();
    return downloadURL;
  }
}
