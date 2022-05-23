import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit_cubit.dart';
import 'package:phone_authentication/otp.dart';

class NumberVerification extends StatelessWidget {
  NumberVerification({Key? key}) : super(key: key);
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _phoneController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Auth"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Center(
              child: Text(
            "Phone Authentication",
            style: TextStyle(fontSize: 20),
          )),
          const SizedBox(
            height: 50,
          ),
          Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter the mobile Number";
                  } else if (value.length != 10) {
                    return "Enter a correct Mobile Number";
                  }
                  return null;
                }),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: "+91  ",
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          BlocConsumer<AuthCubit, AuthCubitState>(
            listener: (context, state) {
              if (state is AuthCodeSentState) {
                Navigator.push(
                  context,
                 CupertinoPageRoute(
                    builder: (context) => OtpVerification(
                      phonenumber: _phoneController.text.toString(),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                  onPressed: () {
                    String phoneNumber = _phoneController.text;
                    BlocProvider.of<AuthCubit>(context)
                        .verifyPhone(phoneNumber);
                  },
                  child: const Text("Next"));
            },
          )
        ],
      ),
    );
  }
}
