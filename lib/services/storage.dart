import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> savePosts(List<dynamic> posts) async {
    final preferences = await SharedPreferences.getInstance();
    final jsonPosts = jsonEncode(posts);
    await preferences.setString('posts', jsonPosts);
  }

  Future<List<dynamic>> getPosts() async {
    final preferences = await SharedPreferences.getInstance();
    final getJsonPosts = preferences.getString('posts');
    if (getJsonPosts != null) {
      return List<dynamic>.from(jsonDecode(getJsonPosts));
    }
    return [];
  }

  Future<dynamic> getPostById(int postId) async {
    final preferences = await SharedPreferences.getInstance();
    final getPost = preferences.getString('posts');
    if (getPost != null) {
      final List<dynamic> post = jsonDecode(getPost);
      return post.firstWhere((post) => post['id'] == postId);
    }
  }

  Future<void> markPostAsRead(int postId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('post $postId', true);
  }

  Future<bool> isPostRead(int postId) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool('post $postId') ?? false;
  }
}
