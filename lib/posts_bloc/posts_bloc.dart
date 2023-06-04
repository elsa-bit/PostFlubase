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
      try {
        emit(state.copyWith(status: PostsStatus.loading));
        await for (var posts in repository.getPosts()) {
          emit(state.copyWith(posts: posts, status: PostsStatus.success));
        }
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: PostsStatus.error,
        ));
      }
    });

    on<AddPost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));
      try {
        final id = await repository.addPost(event.post);
        emit(state.copyWith(status: PostsStatus.editSuccess));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: PostsStatus.error));
      }
    });

    on<EditPost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));
      try {
        await repository.editPost(event.post);
        emit(state.copyWith(status: PostsStatus.editSuccess));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: PostsStatus.error));
      }
    });
  }
}
