import 'package:flutter/material.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/SkillDrillsDialog.dart';
import 'package:skill_drills/services/dialogs.dart';

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
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              "Quick start".toUpperCase(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
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
            onPressed: () {
              if (!sessionService.isRunning) {
                sessionService.start();
              } else {
                dialog(
                  context,
                  SkillDrillsDialog(
                    "Override current session?",
                    Text(
                      "Starting a new session will override your existing one.\n\nWould you like to continue?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    "Cancel",
                    () {
                      Navigator.of(context).pop();
                    },
                    "Continue",
                    () {
                      sessionService.reset();
                      Navigator.of(context).pop();
                      sessionService.start();
                    },
                  ),
                );
              }
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 10),
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
        ],
      ),
    );
  }
}
