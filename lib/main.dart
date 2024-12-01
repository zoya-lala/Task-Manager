import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/post_bloc.dart';
import 'package:task_manager_app/screens/postList.dart';
import 'package:task_manager_app/services/api.dart';
import 'package:task_manager_app/services/storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(Api(), StorageService()),
      child: MaterialApp(
        home: PostListScreen(),
      ),
    );
  }
}
