import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiPostsDataSource extends PostsDataSource {
  @override
  Future<String> addPost(Post post) async {
    final reponse = await FirebaseFirestore.instance
        .collection('posts')
        .add({'title': post.title, 'description': post.description});
    return reponse.id;
  }

  @override
  Future<List<Post>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
}
