import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/domain/services/database_service.dart';

import '../domain/models/user.dart';
import '../domain/providers/auth_provider.dart';

class AuthParamsScreen extends StatelessWidget {
  final String uid;
  final String phoneNumber;
  AuthParamsScreen({super.key, , required this.uid,required this.phoneNumber});
  final _nameController = TextEditingController();
  final _familyIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(label: Text('name')),
        ),
        TextField(
          controller: _,
          decoration: InputDecoration(label: Text('family id')),
        ),
        Consumer(
          builder: (context, ref, child) => TextButton(
              onPressed: () {
                DatabaseService.instance.addProfilePicture(file);
                ref.read(userProvider).logIn(AppUser(
                    uid: uid,
                    familyId: _familyIdController.text,
                    phoneNumber: phoneNumber,
                    name: userCredential.user!.displayName!,
                    picturePath: userCredential.user!.photoURL!));
              },
              child: Text('Submit')),
        )
      ],
    );
  }
}
