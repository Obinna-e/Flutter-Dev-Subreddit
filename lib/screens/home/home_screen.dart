import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('r/FlutterDev'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          itemBuilder: ((context, index) => ListTile(
                visualDensity: VisualDensity(vertical: 3),
                leading: Column(
                  children: const [
                    Icon(Icons.arrow_upward),
                    Text('1'),
                    Icon(Icons.arrow_downward),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
