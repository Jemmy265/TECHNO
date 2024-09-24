import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';
import 'package:think/shared_prefs.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<GetUserData>(getUserData);
    on<UploadUserData>(_uploadData);
    on<GetLocalImage>(_getLocalImage);
    on<UploadName>(_updateName);
  }

  final FirebaseManager _firebaseManager = FirebaseManager();
// a function that gets the user data from the firebase based on the id
  Future<void> getUserData(
      GetUserData event, Emitter<ProfileState> emit) async {
    String name;
    String? path;
    emit(state.copyWith(status: ProfileStatus.loadImage));
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot? userDoc =
            await _firebaseManager.getUserData(user.uid);
        if (userDoc.exists) {
          name = userDoc['name'];
          dynamic data = userDoc.data();
          // path = data["imagePath"];
          SharedPrefs.setName(name);
          if (data["imagePath"] != null) {
            path = data["imagePath"];
            emit(state.copyWith(
                status: ProfileStatus.success, name: name, path: path));
          } else {
            path = '';
            emit(state.copyWith(
                status: ProfileStatus.success, name: name, path: path));
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProfileStatus.failed, errorMessage: e.toString()));
    }
  }

// a function that uploads the user data to the firebase and link it with his id
  Future<void> _uploadData(
      UploadUserData event, Emitter<ProfileState> emit) async {
    final File imageFile = event.image;
    final String name = event.name;
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseManager.uploadData(user.uid, imageFile, name);
        SharedPrefs.setName(name);
        emit(state.copyWith(
            status: ProfileStatus.success, name: name, imageFile: imageFile));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failed));
    }
  }

// a function that only updates the name in firebase
  Future<void> _updateName(UploadName event, Emitter<ProfileState> emit) async {
    String name = event.name;
    String? path;
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseManager.uploadName(user.uid, name);
        DocumentSnapshot? userDoc =
            await _firebaseManager.getUserData(user.uid);
        name = userDoc['name'];
        dynamic data = userDoc.data();
        // path = data["imagePath"];
        if (data["imagePath"] != null) {
          path = data["imagePath"];
          SharedPrefs.setName(name);
          emit(state.copyWith(
              status: ProfileStatus.success, name: name, path: path));
        } else {
          path = '';
          emit(state.copyWith(
              status: ProfileStatus.success, name: name, path: path));
        }
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failed));
    }
  }

// a function that gets the image form the user
  Future<File?> _getLocalImage(
      GetLocalImage event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loadImage));
    try {
      File? file;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      file = File(image!.path);
      emit(state.copyWith(status: ProfileStatus.success, imageFile: file));
      return file;
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failed));
      return null;
    }
  }
}
