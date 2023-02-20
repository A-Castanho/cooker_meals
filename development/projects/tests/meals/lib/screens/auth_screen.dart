import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Phone number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Send verification code'),
                onPressed: () {
                  _sendVerificationCode();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      codeAutoRetrievalTimeout: (verificationId) {},
      verificationCompleted: (PhoneAuthCredential credential) {
        // Automatic verification is complete, sign in with the credential
        FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verification ID somewhere for later use
        // You'll need this to create a credential for signInWithCredential
        String storedVerificationId = verificationId;
        print('Verification code sent to $_phoneNumber');
      },
      // code
    );
  }
}
