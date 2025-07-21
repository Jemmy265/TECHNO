part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBooks extends BooksEvent {}

class RentBook extends BooksEvent {
  final RentalRequest rentRequest;

  RentBook(this.rentRequest);

  @override
  List<Object?> get props => [rentRequest];
}
