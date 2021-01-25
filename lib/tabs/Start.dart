import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  Start({Key key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick start".toUpperCase(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Divider(
            height: 10,
          ),
          MaterialButton(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Start empty session".toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 18,
                    fontFamily: "Choplin",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            color: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.onSecondary,
            onPressed: () {},
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Routines".toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }
}
