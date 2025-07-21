part of 'rental_request_bloc.dart';

enum RentalRequestStatus { initial, loading, success, failure, alreadyExists }

class RentalRequestState extends Equatable {
  final RentalRequestStatus status;
  final String message;
  final RentalRequest? existingRequest;

  const RentalRequestState({
    this.status = RentalRequestStatus.initial,
    this.message = '',
    this.existingRequest,
  });

  RentalRequestState copyWith({
    RentalRequestStatus? status,
    String? message,
    RentalRequest? rentalRequest,
  }) {
    return RentalRequestState(
      status: status ?? this.status,
      existingRequest: existingRequest ?? this.existingRequest,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, existingRequest, message];
}

// final class RentalRequestInitial extends RentalRequestState {}


// class RentalRequestInitial extends RentalRequestState {}

// class RentalRequestLoading extends RentalRequestState {}

// class RentalRequestSuccess extends RentalRequestState {
//   final String message;

//   RentalRequestSuccess(this.message);
// }

// class RentalRequestError extends RentalRequestState {
//   final String message;

//   RentalRequestError(this.message);
// }

// class RentalRequestAlreadyExists extends RentalRequestState {
//   final String message;
//   final RentalRequest existingRequest;

//   RentalRequestAlreadyExists(this.message, this.existingRequest);
// }