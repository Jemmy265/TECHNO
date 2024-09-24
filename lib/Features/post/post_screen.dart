import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Core/Models/comment_model.dart';
import 'package:think/Core/Models/post_model.dart';
import 'package:think/Features/Home/widgets/post_widget.dart';
import 'package:think/Features/post/bloc/post_bloc.dart';
import 'package:think/Features/post/widgets/comment_widget.dart';
import 'package:think/Features/widgets/my_text_form_field.dart';

class PostScreen extends StatelessWidget {
  static const String routeName = 'post';
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final MyComment comment = MyComment(id: '', content: '', name: '');
  PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return BlocProvider(
      create: (context) => PostBloc()..add(GetComments(postId: post.id)),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/background.png"))),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ));
              },
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: formKey,
                  child: MyTextFormField(
                    controller: commentController,
                  ),
                ),
              ),
              PostWidget(
                post: post,
                inFeed: false,
              ),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state.status == PostStatus.loading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state.status == PostStatus.failure) {
                    return AlertDialog(
                      title: Text(state.errorMessage),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context
                                .read<PostBloc>()
                                .add(GetComments(postId: post.id));
                          },
                          child: const Text("Try Again"),
                        ),
                      ],
                    );
                  }
                  if (state.status == PostStatus.success) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: height * 0.55,
                        child: Stack(
                          children: [
                            ListView.separated(
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                    comment: state.comments[index]);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 10);
                              },
                              itemCount: state.comments.length,
                            ),
                            Positioned(
                              bottom: 16.0,
                              right: 16.0,
                              child: FloatingActionButton(
                                child: const Icon(Icons.add),
                                onPressed: () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    comment.content = commentController.text;
                                    context.read<PostBloc>().add(AddComment(
                                          comment: comment,
                                          postId: post.id,
                                        ));
                                    commentController.clear();
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
