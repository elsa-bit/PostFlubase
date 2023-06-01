import 'package:app_post/models/post.dart';
import 'package:app_post/post_item.dart';
import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:app_post/repository/posts_repository.dart';
import 'package:app_post/screen/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc(
        repository: RepositoryProvider.of<PostsRepository>(context),
      )..add(GetAllPosts(10)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Posts'),
            ),
            body: BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) {
                switch (state.status) {
                  case PostsStatus.initial:
                    return const SizedBox();
                  case PostsStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PostsStatus.error:
                    return Center(
                      child: Text(state.error),
                    );
                  case PostsStatus.success:
                    final posts = state.posts;

                    if (posts.isEmpty) {
                      return const Center(
                        child: Text('Aucun post'),
                      );
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostItem(
                          post: post,
                          onTap: () => _onProductTap(context, post),
                        );
                      },
                    );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () => _onRefreshList(context),
            ),
          );
        },
      ),
    );
  }

  void _onRefreshList(BuildContext context) {

  }

  void _onProductTap(BuildContext context, Post post) {
    PostDetailScreen.navigateTo(context, post);
  }
}
