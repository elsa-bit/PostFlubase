import 'package:app_post/data_sources/api_posts_data_source.dart';
import 'package:app_post/models/post.dart';
import 'package:app_post/posts_bloc/posts_bloc.dart';
import 'package:app_post/repository/posts_repository.dart';
import 'package:app_post/screen/post_add_screen.dart';
import 'package:app_post/screen/post_detail_screen.dart';
import 'package:app_post/screen/post_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_post/analytics_provider.dart';
import 'package:app_post/firebase_analytics_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnalyticsProvider(
      handlers: [
        FirebaseAnalyticsHandler(),
      ],
      child: RepositoryProvider(
        create: (context) => PostsRepository(
          postDataSource: ApiPostsDataSource(),
        ),
        child: BlocProvider<PostsBloc>(
          create: (context) => PostsBloc(
            RepositoryProvider.of<PostsRepository>(context),
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: const TextTheme(
                bodySmall: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            routes: {
              '/': (context) => const HomeScreen(),
              PostAddScreen.routeName: (context) => PostAddScreen(),
            },
            onGenerateRoute: (settings) {
              Widget content = const SizedBox.shrink();
              switch (settings.name) {
                case PostDetailScreen.routeName:
                  final arguments = settings.arguments;
                  if (arguments is Post) {
                    content = PostDetailScreen(post: arguments);
                  }
                  break;
              }

              return MaterialPageRoute(
                builder: (context) {
                  return content;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
