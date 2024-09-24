part of 'profile_bloc.dart';

 class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserData extends ProfileEvent {}

class UploadUserData extends ProfileEvent {
  final File image;
  final String name;
  const UploadUserData({
    required this.image,
    required this.name,
  });

  
  @override
  List<Object> get props => [image,name];
}

class UploadName extends ProfileEvent {
  final String name;
  const UploadName({
    required this.name,
  });
}

class GetLocalImage extends ProfileEvent {}
