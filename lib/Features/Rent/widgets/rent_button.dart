import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';
import 'package:think/Features/Rent/bloc/rental_request_bloc.dart';

class BookRentalButton extends StatelessWidget {
  final String bookTitle;

  const BookRentalButton({
    Key? key,
    required this.bookTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RentalRequestBloc(FirebaseManager()),
      child: BlocConsumer<RentalRequestBloc, RentalRequestState>(
        listener: (context, state) {
          if (state.status == RentalRequestStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 4),
              ),
            );
          } else if (state.status == RentalRequestStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state.status == RentalRequestStatus.alreadyExists) {
            _showExistingRequestDialog(context, state);
          }
        },
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.status == RentalRequestStatus.loading
                ? null
                : () {
                    context.read<RentalRequestBloc>().add(RequestBookRental(
                        bookTitle: bookTitle,
                        startDate: DateTime.now(),
                        endDate: DateTime.now().add(const Duration(days: 7))));
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: state.status == RentalRequestStatus.loading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Submitting...'),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book_online),
                      SizedBox(width: 8),
                      Text(
                        'Rent This Book',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  void _showExistingRequestDialog(
      BuildContext context, RentalRequestState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Already Exists'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.message),
              const SizedBox(height: 10),
              Text(
                'Status: ${state.existingRequest!.isAccepted ? "Approved" : "Pending"}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: state.existingRequest!.isAccepted
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
              Text(
                'Requested on: ${DateFormat('MMM dd, yyyy').format(state.existingRequest!.createdAt)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
