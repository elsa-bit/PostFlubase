import 'package:app_post/models/post.dart';

abstract class PostsDataSource {
  Stream<List<Post>> getAllPosts();

  Future<String> addPost(Post post);

  Future<void> editPost(Post post);
}