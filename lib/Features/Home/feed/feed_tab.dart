import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Core/Models/post_model.dart';
import 'package:think/Core/data/Firebase/firebase_manager.dart';
import 'package:think/Features/Home/feed/bloc/feed_bloc.dart';
import 'package:think/Features/Home/widgets/post_widget.dart';
import 'package:think/Features/widgets/my_text_form_field.dart';

class FeedTab extends StatelessWidget {
  final FirebaseManager firebaseManager = FirebaseManager();
  final formKey = GlobalKey<FormState>();
  final TextEditingController postController = TextEditingController();
  final Post post = Post(id: '', content: '', name: '', likesCount: 0);

  FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: MyTextFormField(
              controller: postController,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => FeedBloc()..add(LoadPosts()),
          child: BlocBuilder<FeedBloc, FeedState>(
            builder: (context, state) {
              if (state.status == FeedStatus.loading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state.status == FeedStatus.failure) {
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
              if (state.status == FeedStatus.success) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: height * 0.65,
                    child: Stack(
                      children: [
                        ListView.separated(
                          itemCount: state.posts.length,
                          itemBuilder: (context, index) {
                            return PostWidget(
                              post: state.posts[index],
                              inFeed: true,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                        ),
                        Positioned(
                          bottom: 16.0,
                          right: 16.0,
                          child: FloatingActionButton(
                            child: const Icon(Icons.add),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                post.content = postController.text;
                                context.read<FeedBloc>().add(AddPost(post));
                                postController.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
