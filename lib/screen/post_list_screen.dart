import 'package:app_post/AddPostIcon.dart';
import 'package:app_post/models/post.dart';
import 'package:app_post/post_item.dart';
import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:app_post/repository/posts_repository.dart';
import 'package:app_post/screen/post_add_screen.dart';
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

  void _dataFirestore() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('posts');

    try {
      //final DocumentReference documentReference = await collectionReference.add({'title': 'TitrePost', 'description': "Ceci est la description"});
      //debugPrint('Document added with id: ${documentReference.id}');

      final ref = await collectionReference.get();
      debugPrint('Collection data: ${ref.docs}');
    } catch (error) {
      debugPrint('Error writting in firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostsBloc>(context).add(GetAllPosts());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AddPostIcon(
              onTap: () => _navigateToAddPostScreen(context),
            ),
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          switch (state.status) {
            case PostsStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PostsStatus.error:
              return Center(
                child: Text(state.error),
              );
            case PostsStatus.success:
            default:
              if (state.posts.isEmpty) {
                return const Center(
                  child: Text(
                    "Il n'y a pas de posts\n Vous pouvez en ajouter",
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostItem(
                    post: post,
                    onTap: () => _onPostTap(context, post),
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
            heroTag: 'cloudButton',
          ),
          SizedBox(height: 18),
          FloatingActionButton(
            onPressed: _crash,
            tooltip: 'Crash',
            child: const Icon(Icons.warning),
            backgroundColor: Colors.redAccent,
            heroTag: 'crashButton',
          ),
        ],
      ),
    );
  }

  void _onPostTap(BuildContext context, Post post) {
    PostDetailScreen.navigateTo(context, post);
  }

  void _navigateToAddPostScreen(BuildContext context) {
    PostAddScreen.navigateTo(context);
  }
}
