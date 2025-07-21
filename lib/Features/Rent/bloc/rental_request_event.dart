part of 'rental_request_bloc.dart';

sealed class RentalRequestEvent extends Equatable {
  const RentalRequestEvent();

  @override
  List<Object> get props => [];
}

class RequestBookRental extends RentalRequestEvent {
  final String bookTitle;
  final DateTime startDate;
  final DateTime endDate;

  RequestBookRental({
    required this.bookTitle,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [bookTitle, startDate, endDate];
}

class CheckExistingRequest extends RentalRequestEvent {
  final String bookTitle;

  const CheckExistingRequest(this.bookTitle);

  @override
  List<Object> get props => [bookTitle];
}
