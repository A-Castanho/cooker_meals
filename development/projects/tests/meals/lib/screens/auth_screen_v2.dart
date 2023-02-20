import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  late String _phoneNumber;
  late String _verificationId;
  late TextEditingController _smsController;
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

  Future<void> _signInWithPhoneNumber() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('Successfully signed in with phone number');
    } catch (e) {
      print('Failed to sign in with phone number: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _smsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
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
                ElevatedButton(
                  child: Text('Sign In'),
                  onPressed: () {
                    _signInWithPhoneNumber();
                  },
                ),
              ],
            ),
          );
  }
}
