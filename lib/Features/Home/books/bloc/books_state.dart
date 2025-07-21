part of 'books_bloc.dart';

enum BooksStatus { initial, loading, success, failure }

class BooksState extends Equatable {
  final BooksStatus status;
  final List<Book> books;
  final String errorMessage;

  const BooksState({
    this.status = BooksStatus.initial,
    this.books = const [],
    this.errorMessage = '',
  });

  BooksState copyWith({
    BooksStatus? status,
    List<Book>? books,
    String? errorMessage,
  }) {
    return BooksState(
      status: status ?? this.status,
      books: books ?? this.books,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, books, errorMessage];
}
