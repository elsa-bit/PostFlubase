import 'package:app_post/models/post.dart';

abstract class PostsDataSource {
  Stream<List<Post>> getPosts();

  Future<String> addPost(Post post);

  Future<void> editPost(Post post);
}