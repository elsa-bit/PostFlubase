import 'dart:async';

import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';

class ErrorPostsDataSource extends PostsDataSource {
  final StreamController<List<Post>> streamControllerPost =
  StreamController<List<Post>>();

  @override
  Stream<List<Post>> getAllPosts() {
    throw Exception("Il y a une erreur");
  }

  @override
  Future<String> addPost(Post post) {
    throw UnimplementedError();
  }

  @override
  Future<void> editPost(Post post) {
    throw UnimplementedError();
  }
}
