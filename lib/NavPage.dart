import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  NavPage({Key key, this.title, this.actions, this.body}) : super(key: key);

  final Widget title;
  final List<Widget> actions;
  final Widget body;

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
      ),
      margin: EdgeInsets.only(top: 40),
      child: widget.body,
    );
  }
}
