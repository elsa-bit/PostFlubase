import 'dart:async';

import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';

class SuccessPostsDataSource extends PostsDataSource {
  final StreamController<List<Post>> streamControllerPost =
      StreamController<List<Post>>();

  @override
  Stream<List<Post>> getAllPosts() {
    streamControllerPost.add(<Post>[
      Post(
          id: '4',
          title: 'titre du widget_test',
          description: 'description du widget_test')
    ]);
    streamControllerPost.add(<Post>[
      Post(
          id: '8',
          title: 'titre2 du widget_test',
          description: 'description2 du widget_test')
    ]);
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
