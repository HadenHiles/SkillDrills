import 'package:flutter/material.dart';

class BasicTitle extends StatelessWidget {
  const BasicTitle({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 22,
          color: Theme.of(context).textTheme.headline1.color,
          fontFamily: "Choplin",
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
