// abstract class FirebaseState {}

// class InitialFirebase extends FirebaseState {}

// class LoadingFirebase extends FirebaseState {}

// class FailedFirebase extends FirebaseState {
//   final String error;

//   FailedFirebase(this.error);
// }

// class SuccessLogin extends FirebaseState {}

// class SuccessLogout extends FirebaseState {}

// class SuccessSignUp extends FirebaseState {}

// class SuccessGetUserName extends FirebaseState {
//   final String name;

//   SuccessGetUserName(this.name);
// }

// class SuccessUpdateUserName extends FirebaseState {}

import 'dart:io';

import 'package:equatable/equatable.dart';

enum FirebaseStatus {
  initial,
  loading,
  loadingImage,
  failed,
  successLogin,
  successLogout,
  successSignUp,
  successGetUserName,
  successUpdateUserName,
  successUploadImage,
  sucessGetImage,
  getLocalImage,
  noImageAssigned,
}

class FirebaseState extends Equatable {
  final String errorMessage;
  final String name;
  final String? path;
  final File? imageFile;
  final FirebaseStatus status;
  const FirebaseState({
    this.status = FirebaseStatus.initial,
    this.errorMessage = '',
    this.name = '',
    this.path,
    this.imageFile,
  });

  FirebaseState copyWith({
    FirebaseStatus? status,
    String? errorMessage,
    String? name,
    File? imageFile,
    String? path,
  }) =>
      FirebaseState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        name: name ?? this.name,
        imageFile: imageFile ?? this.imageFile,
        path: path ?? this.path,
      );
  @override
  List<Object?> get props => [status];
}
