import 'package:flutter_firebase/constant/firebase_instances.dart';
import 'package:flutter_firebase/model/auth_state.dart';
import 'package:flutter_firebase/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final defaultState = AuthState(
    errMessage: '', 
    isError: false, 
    isLoad: false,
    isSuccess: false
);

final authStream = StreamProvider((ref) => FirebaseInstances.firebaseAuth.authStateChanges());


final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) => AuthProvider(defaultState));

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(super.state);
  //user sign up
  Future<void> userSignUp(
      {required String email,
      required String password,
      required String username,
      required XFile image}) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userSignUp(
        email: email, password: password, username: username, image: image);
    response.fold(
            (l) {
              state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
            },
            (r) {
              state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: '');
            });
  }
  //user login
  Future<void> userLogIn(
      {required String email,
        required String password}) async {

    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userLogin(
        email: email, password: password);
    response.fold(
            (l) {
          state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
        },
            (r) {
          state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: '');
        });
  }

  //user logout
  Future<void> userLogOut() async{
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response =  await AuthService.userLogout();
    response.fold(
            (l){
              state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);
            },
            (r) {
              state= state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: '');
            });
  }


}
