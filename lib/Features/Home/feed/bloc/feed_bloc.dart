import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:think/Core/Models/post_model.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart'; // Import your FirebaseManager

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FirebaseManager _firebaseManager = FirebaseManager();

  FeedBloc() : super(const FeedState()) {
    on<LoadPosts>(_onLoadPosts);
    on<AddPost>(_onAddPost);
    on<LikePost>(_onLike);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<FeedState> emit) async {
    emit(state.copyWith(status: FeedStatus.loading));

    try {
      List<Post> posts = await _firebaseManager.getPosts();
      emit(state.copyWith(status: FeedStatus.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddPost(AddPost event, Emitter<FeedState> emit) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot? userDoc =
            await _firebaseManager.getUserData(user.uid);
        event.post.name = userDoc['name'];
        dynamic data = userDoc.data();
        if (data["imagePath"] != null) {
          event.post.imagePath = data["imagePath"];
          emit(state.copyWith(status: FeedStatus.success));
        } else {
          event.post.imagePath = '';
          emit(state.copyWith(status: FeedStatus.success));
        }
      }
      await _firebaseManager.addPost(event.post);
      add(LoadPosts());
    } catch (e) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLike(LikePost event, Emitter<FeedState> emit) async {
    emit(state.copyWith(status: FeedStatus.loading));
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot? userDoc =
            await _firebaseManager.getUserData(user.uid);
        await _firebaseManager.likePost(
          postId: event.postId,
          userId: user.uid,
          userName: userDoc['name'],
          userPhoto: userDoc['imagePath'],
        );
        emit(state.copyWith(status: FeedStatus.success));
      } else {
        emit(state.copyWith(
          status: FeedStatus.failure,
          errorMessage: "User is not logged in",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
