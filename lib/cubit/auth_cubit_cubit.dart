import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitialState());
  String? _verificationCode;

  void verifyPhone(String number) async {
    emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: '+91 ${number}',
      codeSent: (String verificationID, [int? forceResendingTocken]) {
        _verificationCode = verificationID;
        emit(AuthCodeSentState());
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            print("user logged in");
          }
        });
      },
      verificationFailed: (error) {
        emit(AuthErrorState(error.message.toString()));
        // if (e.code == "invalid-phone-number") {
        //   print("provide number is not valid");
        // }
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        _verificationCode = verificationID;
        emit(AuthCodeSentState());
      },
    );
  }

  void verifyOtp(String otp,BuildContext context) async {
     emit(AuthLoadingState());
   try {
  PhoneAuthCredential credential= await PhoneAuthProvider.credential(
       verificationId: _verificationCode.toString(), smsCode: otp);
   SiginWithPhone(credential);
}   catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP")));
}

  }


  void SiginWithPhone(PhoneAuthCredential credential)async{
     try {
       UserCredential userCredential=await _auth.signInWithCredential(credential);
       if(userCredential.user!=null){
          emit(AuthLoggedInState(userCredential.user!));
       }
     } on FirebaseAuthException catch (e) {
       emit(AuthErrorState(e.message.toString()));
     }
  }

  void signOut() async{
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}
