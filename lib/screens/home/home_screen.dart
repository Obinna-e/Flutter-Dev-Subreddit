import 'package:flutter/material.dart';
import 'package:flutter_dev/models/post_details.dart';
import 'package:flutter_dev/services/post_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Post>? _posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  void _getPosts() async {
    _posts = await ApiService().fetchPost();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('r/FlutterDev'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getPosts();
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _posts?.length,
                itemBuilder: ((context, index) => ListTile(
                      visualDensity: const VisualDensity(vertical: 3),
                      leading: Column(
                        children: [
                          const Icon(Icons.arrow_upward),
                          Text(_posts![index].score.toString()),
                          const Icon(Icons.arrow_downward),
                        ],
                      ),
                      title: Text(_posts![index].title!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: Text('posted by ${_posts![index].author}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child:
                                Text('${_posts![index].commentCount} comments'),
                          )
                        ],
                      ),
                    )),
              ),
      ),
    );
  }
}
