import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:think/Core/Models/comment_model.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FirebaseManager _firebaseManager = FirebaseManager();
  PostBloc() : super(const PostState()) {
    on<GetComments>(_onGetComments);
    on<AddComment>(_onAddComment);
  }

  Future<void> _onGetComments(
      GetComments event, Emitter<PostState> emit) async {
    emit(state.copyWith(status: PostStatus.loading));

    try {
      List<MyComment> comments =
          await _firebaseManager.getComments(event.postId);
      emit(state.copyWith(status: PostStatus.success, comments: comments));
    } catch (e) {
      emit(state.copyWith(
        status: PostStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddComment(AddComment event, Emitter<PostState> emit) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot? userDoc =
            await _firebaseManager.getUserData(user.uid);
        event.comment.name = userDoc['name'];
        dynamic data = userDoc.data();
        if (data["imagePath"] != null) {
          event.comment.imagePath = data["imagePath"];
          emit(state.copyWith(status: PostStatus.success));
        } else {
          event.comment.imagePath = '';
          emit(state.copyWith(status: PostStatus.success));
        }
      }
      await _firebaseManager.addComment(event.comment, event.postId);
      add(GetComments(postId: event.postId));
    } catch (e) {
      emit(state.copyWith(
        status: PostStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
