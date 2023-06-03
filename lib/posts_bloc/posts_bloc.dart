import 'dart:async';

import 'package:app_post/models/post.dart';
import 'package:app_post/repository/posts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;

  PostsBloc(this.repository) : super(PostsState()) {
    on<GetAllPosts>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));

      try {
        final posts = await repository.getPosts();
        emit(state.copyWith(status: PostsStatus.success, posts: posts));
      } catch (error) {
        emit(
            state.copyWith(status: PostsStatus.error, error: error.toString()));
      }
    });

    on<AddPost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));
      try {
        final id = await repository.addPost(event.);    //PROBLEME ICI
        emit(state.copyWith(status: PostsStatus.editSuccess));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: PostsStatus.error));
      }
    });
  }
}
