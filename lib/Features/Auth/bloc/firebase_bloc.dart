import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';
import 'package:think/shared_prefs.dart';
import 'firebase_event.dart';
import 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(const FirebaseState()) {
    on<LoginTry>(_onLoginSubmitted);
    on<LogoutTry>(_onLogoutSubmitted);
    on<SignUpTry>(_onSignUpSubmitted);
  }

  final FirebaseManager _firebaseManager = FirebaseManager();
// Sign up Function that creates user in firebase
  Future<void> _onSignUpSubmitted(
      SignUpTry event, Emitter<FirebaseState> emit) async {
    emit(state.copyWith(status: FirebaseStatus.loading));
    try {
      User? user = await _firebaseManager.signUpWithEmailAndPassword(
        event.email,
        event.password,
        event.name,
      );

      if (user != null) {
        SharedPrefs.setName(event.name);
        emit(state.copyWith(status: FirebaseStatus.successSignUp));
      } else {
        emit(state.copyWith(status: FirebaseStatus.failed));
      }
    } catch (e) {
      emit(state.copyWith(status: FirebaseStatus.failed));
    }
  }

// Log in Function that authenticates the user in my app and sets the shared prefs
  Future<void> _onLoginSubmitted(
      LoginTry event, Emitter<FirebaseState> emit) async {
    emit(state.copyWith(status: FirebaseStatus.loading));
    try {
      User? user = await _firebaseManager.signInWithEmailAndPassword(
          event.email, event.password);

      if (user != null) {
        DocumentSnapshot userDoc = await _firebaseManager.getUserData(user.uid);
        if (userDoc.exists) {
          String userName = userDoc['name'] ?? 'Unknown User';
          SharedPrefs.setName(userName);
        }
        emit(state.copyWith(status: FirebaseStatus.successLogin));
      } else {
        emit(state.copyWith(
            status: FirebaseStatus.failed, errorMessage: "User not found"));
      }
    } catch (e) {
      emit(state.copyWith(
          status: FirebaseStatus.failed, errorMessage: e.toString()));
    }
  }

// Log out Function that unauthenticate user in my app and clear shared prefs
  Future<void> _onLogoutSubmitted(
      LogoutTry event, Emitter<FirebaseState> emit) async {
    emit(state.copyWith(status: FirebaseStatus.loading));
    try {
      await FirebaseAuth.instance.signOut();
      SharedPrefs.clear();
      emit(state.copyWith(status: FirebaseStatus.successLogout));
    } catch (e) {
      emit(state.copyWith(
          status: FirebaseStatus.failed, errorMessage: e.toString()));
    }
  }
}
