import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/domain/models/user.dart';
import 'package:meals/domain/providers/auth_provider.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  late String _phoneNumber;
  late String _verificationId;
  late TextEditingController _smsController;
  late TextEditingController _familyIdController;
  var _loading = false;

  Future<void> _verifyPhoneNumber() async {
    try {
      setState(() {
        _loading = true;
      });
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          print('object');
          // Handle automatic verification if needed
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          setState(() {
            _loading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Verification code sent to $_phoneNumber');
          print(verificationId);
          _verificationId = verificationId;
          setState(() {
            _loading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout');
          setState(() {
            _loading = false;
          });
        },
      );
    } catch (e) {
      print('Failed to verify phone number: $e');
    }
  }

  Future<UserCredential?> _signInWithPhoneNumber() async {
    try {
      final phoneCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text.trim(),
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneCredential);
      return userCredential;
      print('Successfully signed in with phone number');
    } catch (e) {
      print('Failed to sign in with phone number: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    /**
     * While it is possible to initialize the TextEditingController at the declaration, it is generally not recommended because doing so would cause the controller to be instantiated every time the widget is rebuilt. This could lead to unnecessary memory usage and performance issues, especially if the widget is being rebuilt frequently.
     * By initializing the controller in the initState() method, it will only be created once when the widget is first created, and subsequent rebuilds will reuse the existing controller, which is more efficient.
     */
    _smsController = TextEditingController();
    _familyIdController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Phone Auth'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      hintText: 'Enter your phone number',
                    ),
                    onChanged: (value) {
                      _phoneNumber = value;
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text('Verify Phone Number'),
                  onPressed: () {
                    _verifyPhoneNumber();
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Verification code',
                      hintText: 'Enter the verification code',
                    ),
                    controller: _smsController,
                  ),
                ),
                //HOUSEHOLD ID IS GENERATED IN THE COOKERS APP
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'FamilyId',
                      hintText: "Enter your household's id",
                    ),
                    controller: _familyIdController,
                  ),
                ),
                Consumer(builder: (context, ref, _) {
                  return ElevatedButton(
                    child: Text('Sign In'),
                    onPressed: () async {
                      var userCredential = await _signInWithPhoneNumber();
                      if (userCredential != null) {
                        if (userCredential.user!.displayName == null) {
                          //TODO GO TO NEW SCREEN TO DEFINE NAME,
                        } else {
                          ref.read(userProvider).logIn(AppUser(
                              uid: userCredential.user!.uid,
                              familyId: _familyIdController.text,
                              phoneNumber: userCredential.user!.phoneNumber!,
                              name: userCredential.user!.displayName!,
                              picturePath: userCredential.user!.photoURL!));
                        }
                      }
                    },
                  );
                }),
              ],
            ),
          );
  }
}
