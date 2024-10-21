import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Core/Models/post_model.dart';
import 'package:think/Features/Home/feed/bloc/feed_bloc.dart';
import 'package:think/Features/post/post_screen.dart';

class PostWidget extends StatelessWidget {
  PostWidget({
    required this.inFeed,
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;
  bool inFeed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  post.imagePath != ''
                      ? CachedNetworkImage(
                          imageUrl: post.imagePath,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 24,
                          ),
                          placeholder: (context, url) => const CircleAvatar(
                            radius: 24,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            radius: 24,
                            child: Icon(Icons.error),
                          ),
                        )
                      : const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.content,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("${post.likesCount} likes"),
                ],
              ),
              inFeed
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<FeedBloc>()
                                .add(LikePost(postId: post.id));
                          },
                          child: const Text("Like"),
                        ),
                        TextButton(
                          onPressed: () {
                            inFeed
                                ? Navigator.pushNamed(
                                    context, PostScreen.routeName,
                                    arguments: post)
                                : null;
                          },
                          child: const Text("Comment"),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
