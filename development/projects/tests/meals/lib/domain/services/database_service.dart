import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meals/domain/models/meal.dart';

import '../models/user.dart';

class DatabaseService {
  late CollectionReference _userSuggestions;
  late Reference _userSuggestionsPictures;
  late User _user;

  FirebaseApp secondaryApp = Firebase.app('SecondaryApp');

  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  init(User user) {
    _user = user;
    _userSuggestionsPictures = FirebaseStorage.instance
        .ref('${user.familyId}/${user.uid}/suggestions');
    _userSuggestions = FirebaseFirestore.instance
        .collection('${user.familyId}/${user.uid}/suggestions');
  }

  Future<Meal> addSuggestion(
      {required String name,
      required String? description,
      required File imgFile}) async {
    final uploadSnapshot = await _userSuggestionsPictures.putFile(
        imgFile, SettableMetadata(customMetadata: {'meal': name}));
    if (uploadSnapshot.state != TaskState.success) {
      throw ('upload picture: ${uploadSnapshot.state.name}');
    }
    final imgFullPath = uploadSnapshot.metadata!.fullPath;
    final downloadURL =
        await _userSuggestionsPictures.child(imgFullPath).getDownloadURL();

    final suggestionData = {
      'name': name,
      'description': description,
      'imgUrl': downloadURL, // add the download URL to the Firestore document
    };
    final suggestionDoc = await _userSuggestions.add(suggestionData);
    return Meal(suggestionDoc.id,
        name: name, description: description, imagePath: downloadURL);
  }
}
