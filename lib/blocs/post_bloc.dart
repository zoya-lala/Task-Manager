import 'package:bloc/bloc.dart';
import 'package:task_manager_app/blocs/bloc_events.dart';
import 'package:task_manager_app/blocs/bloc_states.dart';
import 'package:task_manager_app/services/api.dart';
import 'package:task_manager_app/services/storage.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final Api api;
  final StorageService storageService;
  PostBloc(this.api, this.storageService) : super(PostInitial()) {
    on<FetchPosts>(
      (event, emit) async {
        emit(PostLoadingList());

        try {
          final localPosts = await storageService.getPosts();
          if (localPosts != null) {
            for (var post in localPosts) {
              final isRead = await storageService.isPostRead(post['id']);
              post['isRead'] = isRead;
            }
            emit(PostLoaded(localPosts));
          }

          final posts = await api.fetchPostList();
          for (var post in posts) {
            final isRead = await storageService.isPostRead(post['id']);
            post['isRead'] = isRead;
          }
          emit(PostLoaded(posts));
          await storageService.savePosts(posts);
        } catch (e) {
          emit(PostError('Unable to load posts'));
        }
      },
    );
    on<MarkAsRead>(
      (event, emit) async {
        try {
          await storageService.markPostAsRead(event.postId);
          final postStatus = await storageService.getPosts();
          for (var post in postStatus) {
            final isRead = await storageService.isPostRead(post['id']);
            post['isRead'] = isRead;
          }
          emit(PostLoaded(postStatus));
        } catch (e) {
          emit(PostError('Unable to update state'));
        }
      },
    );
    on<FetchPostDetails>((event, emit) async {
      emit(PostLoading());
      try {
        final post = await storageService.getPostById(event.postId);
        if (post != null) {
          print('postdetails');
          emit(PostLoadedDetails(post));
        } else {
          final fetchPost = await api.fetchPostDetails(event.postId);
          emit(PostLoadedDetails(fetchPost));
          await storageService.savePosts([fetchPost]);
        }
      } catch (e) {
        emit(
          PostError('Unable to load Details'),
        );
      }
    });
  }
}
