import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/bloc_events.dart';
import 'package:task_manager_app/blocs/bloc_states.dart';
import 'package:task_manager_app/blocs/post_bloc.dart';
import 'package:task_manager_app/screens/postDetail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<PostBloc>().add(FetchPosts());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<PostBloc, PostState>(
            buildWhen: (previous, current) => current is PostLoaded,
            builder: (context, state) {
              if (state is PostLoadingList) {
                return Center(child: CircularProgressIndicator());
              } else if (state is PostLoaded) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PostTile(
                        post: post,
                      ),
                    );
                  },
                );
              } else if (state is PostError) {
                return Center(child: Text('Error: ${state.errorMsg}'));
              } else {
                return Center(child: Text('No posts available'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class PostTile extends StatefulWidget {
  final dynamic post;
  final VoidCallback? onTap;

  const PostTile({this.onTap, this.post});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late int timerDuration;
  late int elapsedSeconds;
  Timer? timer;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    timerDuration = generateRandomDuration();
    elapsedSeconds = 0;
  }

  int generateRandomDuration() {
    List<int> durations = [10, 20, 25];
    durations.shuffle();
    return durations.first;
  }

  void startTimer() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (elapsedSeconds < timerDuration) {
          setState(() {
            elapsedSeconds++;
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  void pauseTimer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isRead = post?['isRead'] ?? false;

    return VisibilityDetector(
      key: Key(post['id'].toString()),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          startTimer();
        } else {
          pauseTimer();
        }
      },
      child: ListTile(
        shape: Border.all(),
        title: Text(
          post['id'].toString(),
        ),
        subtitle: Text(
          post['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        tileColor: isRead ? Colors.white : Colors.yellow[100],
        trailing: Column(
          children: [
            Icon(
              Icons.timer,
              color: Colors.red,
            ),
            Text('$elapsedSeconds / $timerDuration s'),
          ],
        ),
        onTap: () {
          context.read<PostBloc>().add(MarkAsRead(post['id']));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetail(
                postId: post['id'],
              ),
            ),
          );
        },
      ),
    );
  }
}
