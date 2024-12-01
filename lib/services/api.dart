import 'dart:convert';

import 'package:http/http.dart';

class Api {
  static const baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  Future<List<dynamic>> fetchPostList() async {
    final response = await get(Uri.parse('$baseUrl'));
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to load posts. Try again later!');
    }
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> fetchPostDetails(int postId) async {
    final response = await get(Uri.parse('$baseUrl/$postId'));
    try {
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
