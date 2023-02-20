import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future signIn(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic verification is complete, sign in with the credential
        final _credential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        //TODO NOTIFY?
        _credential.user!.uid;
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verification ID somewhere for later use
        // You'll need this to create a credential for signInWithCredential
        //TODO STORE INSIDE SETPREFS
        String storedVerificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval of verification code timed out, handle error
      },
    );
  }
}
