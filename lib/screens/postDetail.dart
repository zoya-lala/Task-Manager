import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/bloc_events.dart';
import 'package:task_manager_app/blocs/bloc_states.dart';
import 'package:task_manager_app/blocs/post_bloc.dart';

class PostDetail extends StatelessWidget {
  final int postId;
  PostDetail({required this.postId});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(FetchPostDetails(postId));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post Details',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
            if (state is PostLoading) {
              return CircularProgressIndicator();
            } else if (state is PostLoadedDetails) {
              final post = state.posts;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title:${post['title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Body:${post['body']}'),
                  ],
                ),
              );
            } else {
              return Text('Failed to load details');
            }
          }),
        ),
      ),
    );
  }
}
