


import 'package:flutter/material.dart';

class DLScreen extends StatelessWidget {
final  String title ;
DLScreen(this.title);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
