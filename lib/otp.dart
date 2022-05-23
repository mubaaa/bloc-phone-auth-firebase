
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit_cubit.dart';
import 'package:phone_authentication/homepage.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatelessWidget {
  final String phonenumber;
  OtpVerification({
    Key? key,
    required this.phonenumber,
  }) : super(key: key);

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 73, 118, 155)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OTP Verification",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
              child: Text(
            "Varify +91- ${phonenumber}",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          const Text("Enter the code sent to the number"),
          const SizedBox(height: 50),
          BlocConsumer<AuthCubit, AuthCubitState>(
            listener: (context, state) {
              if (state is AuthLoggedInState) {
               
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomPage()));
              } else if (state is AuthErrorState) {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                  content: Text("Invalid OTP"),
                  dismissDirection: DismissDirection.up,
                ));
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(child:  CircularProgressIndicator());
              }
              return Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                        color: const Color.fromARGB(255, 170, 105, 7)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: const Color.fromRGBO(234, 239, 243, 1),
                    ),
                  ),
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                  pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                  showCursor: true,
                  onSubmitted: (String otp) {
                
                    BlocProvider.of<AuthCubit>(context).verifyOtp(otp, context);
                      print(phonenumber);
                  });
            },
          ),
          const SizedBox(height: 50),
          const Text("Didn't receive code?"),
          const Text("Resend"),
        ],
      ),
    );
  }
}
