// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class GetComments extends PostEvent {
  final String postId;
  const GetComments({
    required this.postId,
  });
}

class AddComment extends PostEvent {
  final String postId;
  final MyComment comment;
  const AddComment({
    required this.comment,
    required this.postId,
  });
}
