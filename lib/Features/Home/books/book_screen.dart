import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';
import 'package:think/Features/Home/books/bloc/books_bloc.dart';
import 'package:think/Features/Home/books/widgets/book_widget.dart';

class BookScreen extends StatelessWidget {
  static const String routeName = 'book_screen';
  final FirebaseManager firebaseManager = FirebaseManager();

  BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/background.png"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Books',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocProvider(
                create: (context) => BooksBloc()..add(LoadBooks()),
                child: BlocBuilder<BooksBloc, BooksState>(
                  builder: (context, state) {
                    if (state.status == BooksStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state.status == BooksStatus.failure) {
                      return AlertDialog(
                        title: Text(state.errorMessage),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Try Again"),
                          ),
                        ],
                      );
                    }

                    if (state.status == BooksStatus.success &&
                        state.books.isNotEmpty) {
                      return ListView.separated(
                        itemCount: state.books.length,
                        itemBuilder: (context, index) {
                          final book = state.books[index];
                          return BookWidget(book: book);
                          // SizedBox(
                          //   height: height * 0.2,
                          //   child: Card(
                          //     margin: const EdgeInsets.symmetric(
                          //       horizontal: 10,
                          //       vertical: 15,
                          //     ),
                          //     color: Theme.of(context).primaryColor,
                          //     child: Row(
                          //       children: [
                          //         CachedNetworkImage(
                          //           imageUrl: book.imageurl,
                          //           fit: BoxFit.cover,
                          //           placeholder: (context, url) => const Center(
                          //             child: CircularProgressIndicator(),
                          //           ),
                          //           errorWidget: (context, url, error) =>
                          //               const Center(
                          //             child: Icon(Icons.error),
                          //           ),
                          //         ),
                          //         Padding(
                          //           padding: const EdgeInsets.only(left: 16),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceEvenly,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               SizedBox(
                          //                 width: MediaQuery.of(context).size.width * 0.6,
                          //                 child: Text(
                          //                   book.title,
                          //                   style: Theme.of(context)
                          //                       .textTheme
                          //                       .bodyLarge
                          //                       ?.copyWith(fontSize: 18),
                          //                   maxLines: 2,
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //               ),
                          //               Text(
                          //                 "Author : ${book.author}",
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .bodySmall,
                          //               ),
                          //               Text(
                          //                 "Publisher : ${book.publisher}",
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .bodySmall,
                          //               ),
                          //               Row(
                          //                 children: [
                          //                   Text(
                          //                     "Rating : ${book.rating}  ",
                          //                     style: Theme.of(context)
                          //                         .textTheme
                          //                         .bodySmall,
                          //                   ),
                          //                   Icon(Icons.star,
                          //                       color: Colors.yellow[700]),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                      );
                    }

                    return const Center(
                      child: Text('No Books Avaliable'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
