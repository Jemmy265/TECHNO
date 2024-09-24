part of 'post_bloc.dart';

enum PostStatus { initial, loading, success, failure }

class PostState extends Equatable {
  final PostStatus status;
  final List<MyComment> comments;
  final String errorMessage;

  const PostState({
    this.status = PostStatus.initial,
    this.comments = const [],
    this.errorMessage = '',
  });

  PostState copyWith({
    PostStatus? status,
    List<MyComment>? comments,
    String? errorMessage,
  }) {
    return PostState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, comments, errorMessage];
}

