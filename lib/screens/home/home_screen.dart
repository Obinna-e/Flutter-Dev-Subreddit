import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dev/models/post_details.dart';
import 'package:flutter_dev/services/post_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late List<Post>? _posts;
  bool isLoading = true;
  bool hasCache = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    final SharedPreferences prefs = await _prefs;

    try {
      result = await _connectivity.checkConnectivity();

      if (result != ConnectivityResult.none) {
        _posts = await ApiService().fetchPost(prefs, false);
        setState(() {
          isLoading = false;
        });
      } else {
        _posts = await ApiService().fetchPost(prefs, true);
        setState(() {
          isLoading = false;
        });
      }
    } on PlatformException catch (e) {
      print('Couldn\'t verify network $e');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
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
          initConnectivity();
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
