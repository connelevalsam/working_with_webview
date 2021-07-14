import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ranqz/screen/Webview.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Webview()));

            },
            child: Container(
                child: Text("Go to webview"),
              color: Colors.blue,
              padding: EdgeInsets.all(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
