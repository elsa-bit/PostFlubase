import 'package:app_post/data_sources/posts_data_source.dart';
import 'package:app_post/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiPostsDataSource extends PostsDataSource {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<String> addPost(Post post) async {
    final response = await collectionReference
        .add({'title': post.title, 'description': post.description});
    return response.id;
  }

  @override
  Future<List<Post>> getPosts() async {

    final response = await collectionReference.get();

    final List<Post> posts = response.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Post(
        id: doc.id,
        title: data['title'],
        description: data['description'],
      );
    }).toList();

    return posts;
  }
}
