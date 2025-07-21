import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:think/Core/Models/request_model.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';

part 'rental_request_event.dart';
part 'rental_request_state.dart';

class RentalRequestBloc extends Bloc<RentalRequestEvent, RentalRequestState> {
  final FirebaseManager _firebaseManager;

  RentalRequestBloc(this._firebaseManager) : super(const RentalRequestState()) {
    on<RequestBookRental>(_onRequestBookRental);
    on<CheckExistingRequest>(_onCheckExistingRequest);
  }

  Future<void> _onRequestBookRental(
    RequestBookRental event,
    Emitter<RentalRequestState> emit,
  ) async {
    emit(const RentalRequestState(status: RentalRequestStatus.loading));

    try {
        if (event.endDate.isBefore(event.startDate)) {
          emit(state.copyWith(
            status: RentalRequestStatus.failure,
            message: 'End date cannot be before start date.',
          ));
          return;
        }

        if (event.startDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
          emit(state.copyWith(
            status: RentalRequestStatus.failure,
            message: 'Start date cannot be in the past.',
          ));
          return;
        }
      final existingRequest =
          await _firebaseManager.checkExistingRequest(event.bookTitle);

      if (existingRequest != null) {
        emit(RentalRequestState(
          status: RentalRequestStatus.alreadyExists,
          message:
              'You have already requested this book. Please wait for admin approval.',
          existingRequest: existingRequest,
        ));
        return;
      }

      // Create new request
      await _firebaseManager.createRentalRequest(event.bookTitle,
          event.startDate, event.endDate);

      emit(RentalRequestState(status: RentalRequestStatus.success, message: "Your rental request for ${event.bookTitle} has been submitted successfully! You will be notified once the admin approves it." )
        
      );
    } catch (e) {
      emit(RentalRequestState(
        status: RentalRequestStatus.failure,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onCheckExistingRequest(
    CheckExistingRequest event,
    Emitter<RentalRequestState> emit,
  ) async {
    try {
      final existingRequest =
          await _firebaseManager.checkExistingRequest(event.bookTitle);

      if (existingRequest != null) {
        emit(RentalRequestState(
          status: RentalRequestStatus.alreadyExists,
          message: 'You have already requested this book.',
          existingRequest: 
          existingRequest,
        ));
      } else {
        emit(const RentalRequestState(status: RentalRequestStatus.initial));
      }
    } catch (e) {
      emit(const RentalRequestState(message: 'Failed to check existing request'));
    }
  }
}
