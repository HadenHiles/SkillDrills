import 'package:flutter/material.dart';

class BasicTitle extends StatelessWidget {
  const BasicTitle({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}