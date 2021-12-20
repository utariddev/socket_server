import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _incomingMessage = "";

  void listen() {
    ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((ServerSocket server) {
      server.listen(handleClient);
    });
  }

  void handleClient(Socket client) {
    print('server incoming connection from ${client.remoteAddress.address}:${client.remotePort}');
    client.listen((data) {
      print("server listen  : ${String.fromCharCodes(data).trim()}");
      setState(() {
        _incomingMessage = String.fromCharCodes(data).trim();
      });
    }, onDone: () {
      print("server done");
    });
    client.close();
  }

  @override
  Widget build(BuildContext context) {
    listen();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_incomingMessage',
            ),
          ],
        ),
      ),
    );
  }
}
