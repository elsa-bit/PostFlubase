import 'package:app_post/models/post.dart';
import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostAddScreen extends StatelessWidget {
  static const String routeName = '/PostAddScreen';

  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  PostAddScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Titre du post",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Description du post",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            BlocConsumer<PostsBloc, PostsState>(
              listener: (context, state) {
                if (state.status == PostsStatus.editSuccess) {
                  _showSnackBar(context, 'Post ajouté', Colors.lightGreenAccent);
                  Navigator.of(context).pop();
                } else if (state.status == PostsStatus.error) {
                  _showSnackBar(context, state.error ?? '', Colors.yellowAccent);
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case PostsStatus.loading:
                    return const CircularProgressIndicator();
                  default:
                    return ElevatedButton(
                      onPressed: () => _onAddPost(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      child: Text('Ajouter le post'),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: background,
      ),
    );
  }

  void _onAddPost() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('posts');
    try {
      await collectionReference.add({
        'title': _titleController.text,
        'description': _descriptionController.text
      });
    } catch (error) {
      debugPrint('Error writting in firestore: $error');
    }
  }
}
