import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit_cubit.dart';

class HomPage extends StatelessWidget {
  const HomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("congrats!......Successfully Logged in"),
          ),
          BlocConsumer<AuthCubit, AuthCubitState>(
            listener: (context, state) {
              
            },
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).signOut();
                    print("Logoutedddddd");
                  }, child: const Icon(Icons.logout));
            },
          )
        ],
      ),
    );
  }
}
