import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit_cubit.dart';
import 'package:phone_authentication/homepage.dart';
import 'package:phone_authentication/verification.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthCubit())],
      child:  MaterialApp(
        title: "phone",
        home: BlocBuilder<AuthCubit, AuthCubitState>(
          builder: (context, state) {
            return const AuthenticationCheak();
          },
        ),
      ),
    );
  } 
}

class AuthenticationCheak extends StatelessWidget {
  const AuthenticationCheak({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomPage();
            } else {
              return NumberVerification();
            }
          }),
    );
  }
}
