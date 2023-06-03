import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPostIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const AddPostIcon({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      buildWhen: (previousState, nextState) {
        return nextState.status == PostsStatus.success;
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: onTap,
          child: Row(
            children: const [
              Icon(
                Icons.add_circle,
                size: 35,
              ),
            ],
          ),
        );
      },
    );
  }
}
