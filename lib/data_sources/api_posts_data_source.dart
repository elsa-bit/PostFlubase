import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';

class ApiPostsDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(10, (index) {
      return Post(
        id: '$index',
        title: 'Post $index',
        description: 'Description $index',
     );
    });
  }
}
