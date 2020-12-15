import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String data = "我最帅！！";

  // ignore: non_constant_identifier_names
  _MyAppState () {
    Future.delayed(Duration(seconds: 3)).then((value) {
      this.data = "哈哈哈";
      //修改状态
      setState(() {
        debugPrint("11111111");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("测试"),
        ),
        body: Center(child: Text(data)),
      ),
    );
  }
}
