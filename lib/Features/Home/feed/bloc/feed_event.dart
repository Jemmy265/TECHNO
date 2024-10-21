part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPosts extends FeedEvent {}

class AddPost extends FeedEvent {
  final Post post;

  AddPost(this.post);

  @override
  List<Object?> get props => [post];
}

class LikePost extends FeedEvent {
  final String postId;

  LikePost({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class SubscribeToPosts extends FeedEvent {}

class PostsUpdated extends FeedEvent {
  final List<Post> posts;

  PostsUpdated(this.posts);
}
