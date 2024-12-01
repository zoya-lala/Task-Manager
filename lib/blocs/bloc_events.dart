abstract class PostEvent {}

class FetchPosts extends PostEvent {}

class FetchPostDetails extends PostEvent {
  final int postId;
  FetchPostDetails(this.postId);
}

class MarkAsRead extends PostEvent {
  final int postId;
  MarkAsRead(this.postId);
}
