import 'package:app_post/models/post.dart';

abstract class PostsDataSource {
  Future<List<Post>> getPosts();

  Future<String> addPost(String title, String description);
}