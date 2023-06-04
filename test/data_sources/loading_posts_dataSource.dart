import 'dart:async';

import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';

class LoadingPostsDataSource extends PostsDataSource {
  final StreamController<List<Post>> streamControllerPost =
  StreamController<List<Post>>();

  @override
  Stream<List<Post>> getAllPosts() {
    return streamControllerPost.stream;
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
