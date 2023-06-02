import 'package:app_post/models/post.dart';
import 'package:app_post/post_item.dart';
import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:app_post/repository/posts_repository.dart';
import 'package:app_post/screen/post_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _crash() async {
    try {
      throw Exception('Ce crash est géré');
    } catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  void _dataFirestore() async{
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection('posts');

    try {
      //final DocumentReference documentReference = await collectionReference.add({'title': 'TitrePost', 'description': "Ceci est la description"});
      //debugPrint('Document added with id: ${documentReference.id}');

      final ref = await collectionReference.get();
      debugPrint('Collection data: ${ref.docs}');
    } catch (error) {
      debugPrint('Error writting in firestore: $error');
    }

  }

  void _addPost() async {
  }

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
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _dataFirestore,
                  child: const Icon(Icons.cloud),
                  backgroundColor: Colors.grey,
                ),
                SizedBox(height: 18),
                FloatingActionButton(
                  onPressed: _addPost,
                  tooltip: 'Add post',
                  child: const Icon(Icons.add),
                ),
                SizedBox(height: 18),
                FloatingActionButton(
                  onPressed: _crash,
                  tooltip: 'Crash',
                  child: const Icon(Icons.car_crash),
                  backgroundColor: Colors.redAccent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onProductTap(BuildContext context, Post post) {
    PostDetailScreen.navigateTo(context, post);
  }
}
