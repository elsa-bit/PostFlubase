// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app_post/post_item.dart';
import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:app_post/repository/posts_repository.dart';
import 'package:app_post/screen/post_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'data_sources/empty_posts_dataSource.dart';
import 'data_sources/error_posts_dataSource.dart';
import 'data_sources/loading_posts_dataSource.dart';
import 'data_sources/success_posts_dataSource.dart';

void main() {
  testWidgets('List post empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          postDataSource: EmptyPostsDataSource(),
        ),
        child: BlocProvider<PostsBloc>(
          create: (context) => PostsBloc(
            RepositoryProvider.of<PostsRepository>(context),
          ),
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text("Il n'y a pas de post"), findsOneWidget);
  });

  testWidgets('List post success', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          postDataSource: SuccessPostsDataSource(),
        ),
        child: BlocProvider<PostsBloc>(
          create: (context) => PostsBloc(
            RepositoryProvider.of<PostsRepository>(context),
          ),
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(PostItem), findsOneWidget);
  });

  testWidgets('List post loading', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          postDataSource: LoadingPostsDataSource(),
        ),
        child: BlocProvider<PostsBloc>(
          create: (context) => PostsBloc(
            RepositoryProvider.of<PostsRepository>(context),
          ),
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('List post error', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          postDataSource: ErrorPostsDataSource(),
        ),
        child: BlocProvider<PostsBloc>(
          create: (context) => PostsBloc(
            RepositoryProvider.of<PostsRepository>(context),
          ),
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text("Exception: Il y a une erreur"), findsOneWidget);
  });
}
