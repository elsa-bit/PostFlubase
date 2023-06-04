part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class GetAllPosts extends PostsEvent {
  GetAllPosts();
}

class AddPost extends PostsEvent {
  final Post post;

  AddPost({
    required this.post,
  });
}

class EditPost extends PostsEvent {
  final Post post;

  EditPost({
    required this.post,
  });
}
