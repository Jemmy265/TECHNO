import 'dart:io';

abstract class FirebaseEvent {}

class LoginTry extends FirebaseEvent {
  String email;
  String password;
  LoginTry({
    required this.email,
    required this.password,
  });
}

class LogoutTry extends FirebaseEvent {}

class SignUpTry extends FirebaseEvent {
  String email;
  String password;
  String name;
  SignUpTry({
    required this.email,
    required this.password,
    required this.name,
  });
}

class GetUserName extends FirebaseEvent {}

class UpdateUserName extends FirebaseEvent {
  final String newName;

  UpdateUserName(this.newName);
}

class UploadImageEvent extends FirebaseEvent {
  File image;
  UploadImageEvent({
    required this.image,
  });
}

class GetImageEvent extends FirebaseEvent {}

class GetLocalImage extends FirebaseEvent {}
