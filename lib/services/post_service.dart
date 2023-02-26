import 'dart:convert' as convert;

import 'package:flutter_dev/models/post_details.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Post>?> fetchPost() async {
    final url = Uri.https("www.reddit.com", "/r/FlutterDev.json");

    List<Post> posts = [];

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        List<dynamic> postData = jsonResponse["data"]["children"];

        for (var i = 0; i < postData.length; i++) {
          posts.add(
            Post.fromJson(jsonResponse["data"]["children"][i]["data"]),
          );
        }
      }

      return posts;
    } catch (e) {
      print(e);
      return posts;
    }
  }
}
