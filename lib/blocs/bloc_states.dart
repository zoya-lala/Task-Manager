abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoadingList extends PostState {}

class PostLoaded extends PostState {
  final List<dynamic> posts;
  PostLoaded(this.posts);
}

class PostLoadedDetails extends PostState {
  final dynamic posts;
  PostLoadedDetails(this.posts);
}

class PostError extends PostState {
  final String errorMsg;
  PostError(this.errorMsg);
}
