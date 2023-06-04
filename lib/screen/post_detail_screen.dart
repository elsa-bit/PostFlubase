import 'package:app_post/models/post.dart';
import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailScreen extends StatelessWidget {
  static const String routeName = '/PostDetailScreen';

  static void navigateTo(BuildContext context, Post post) {
    Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  final Post post;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  PostDetailScreen({
    super.key,
    required this.post,
  }) {
    _titleController.text = post.title;
    _descriptionController.text = post.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edition du post : ${post.title}"),
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
              decoration: const InputDecoration(
                labelText: "Titre du post",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description du post",
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
                  _showSnackBar(context, 'Post modifié', Colors.green);
                  Navigator.of(context).pop();
                } else if (state.status == PostsStatus.error) {
                  _showSnackBar(
                      context, state.error ?? '', Colors.yellowAccent);
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case PostsStatus.loading:
                    return const CircularProgressIndicator();
                  default:
                    return Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () => _editPost(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        child: const Text('Modifier le post'),
                      ),
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

  void _editPost(BuildContext context) {
    var bloc = BlocProvider.of<PostsBloc>(context);
    if (_titleController.text != "" && _descriptionController.text != "") {
      final editPost = Post(
        id: post.id,
        title: _titleController.text,
        description: _descriptionController.text,
      );
      bloc.add(EditPost(post: editPost));
    } else {
      _showSnackBar(
          context, "Vous devez remplir tous les champs", Colors.redAccent);
    }
  }
}
