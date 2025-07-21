import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:think/Core/Models/book_model.dart';
import 'package:think/Core/Models/request_model.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final FirebaseManager _firebaseManager = FirebaseManager();

  BooksBloc() : super(const BooksState()) {
    on<LoadBooks>(_onLoadBooks);
    on<RentBook>(_onRentBook);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BooksState> emit) async {
    emit(state.copyWith(status: BooksStatus.loading));

    try {
      List<Book> books = await _firebaseManager.getBooks();
      emit(state.copyWith(status: BooksStatus.success, books: books));
    } catch (e) {
      emit(state.copyWith(
        status: BooksStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

    Future<void> _onRentBook(RentBook event, Emitter<BooksState> emit) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot? userDoc =
            await _firebaseManager.getUserData(user.uid);
        // event.rentRequest.userName = userDoc['name'];
      }
      await _firebaseManager.rentBook(event.rentRequest);
      add(LoadBooks());
    } catch (e) {
      emit(state.copyWith(
        status: BooksStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
