part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  failed,
  success,
  loadImage,
}

class ProfileState extends Equatable {
  final String errorMessage;
  final String name;
  final String? path;
  final File? imageFile;
  final ProfileStatus status;
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.errorMessage = '',
    this.name = '',
    this.path,
    this.imageFile,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? errorMessage,
    String? name,
    File? imageFile,
    String? path,
  }) =>
      ProfileState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        name: name ?? this.name,
        imageFile: imageFile ?? this.imageFile,
        path: path ?? this.path,
      );
  @override
  List<Object?> get props => [status, errorMessage, name, imageFile, path];
}
