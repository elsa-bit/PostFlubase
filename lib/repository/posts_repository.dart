import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';

class PostsRepository {
  final PostsDataSource postDataSource;

  PostsRepository({
    required this.postDataSource,
  });

  Stream<List<Post>> getPosts() {
    try {
      final posts = postDataSource.getPosts();
      return posts;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addPost(Post post) {
    return postDataSource.addPost(post);
  }
}
