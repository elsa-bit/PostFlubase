import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';

class PostsRepository {
  final PostsDataSource postDataSource;

  PostsRepository({
    required this.postDataSource,
  });

  Future<List<Post>> getPosts() async {
    try {
      final posts = await postDataSource.getPosts();
      return posts;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addPost(String title, String description) {
    return postDataSource.addPost(title, description);
  }
}
