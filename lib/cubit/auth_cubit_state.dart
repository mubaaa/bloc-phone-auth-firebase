part of 'auth_cubit_cubit.dart';

@immutable
abstract class  AuthCubitState {}

class AuthInitialState extends AuthCubitState{}

class AuthLoadingState extends AuthCubitState{}

class AuthCodeSentState extends AuthCubitState {}

class AuthLoggedInState extends AuthCubitState{
  final User firebaseUser;
  AuthLoggedInState(this.firebaseUser);
}

class AuthLoggedOutState extends AuthCubitState{}

class AuthErrorState extends AuthCubitState{
final  String? error;
  AuthErrorState(this.error);
}