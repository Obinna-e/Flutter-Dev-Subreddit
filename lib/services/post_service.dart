import 'dart:convert' as convert;

import 'package:flutter_dev/models/post_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<List<Post>?> fetchPost(
      SharedPreferences prefs, bool isConnected) async {
    final url = Uri.https("www.reddit.com", "/r/FlutterDev.json");

    List<Post> posts = [];

    //Offline state returns locally stored posts
    if (isConnected == false) {
      try {
        String? postResponse = prefs.getString('posts');
        var jsonResponse =
            convert.jsonDecode(postResponse!) as Map<String, dynamic>;
        List<dynamic> postData = jsonResponse["data"]["children"];

        for (var i = 0; i < postData.length; i++) {
          posts.add(
            Post.fromJson(
              jsonResponse["data"]["children"][i]["data"],
            ),
          );
        }

        return posts;
      } catch (e) {
        print(e);
        return posts;
      }
    }

    //Online state returns
    try {
      final response = await http.get(url);
      prefs.setString('posts', response.body);
      String? postResponse = prefs.getString('posts');

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(postResponse!);
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
