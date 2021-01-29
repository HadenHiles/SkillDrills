import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/services/auth.dart';
import 'package:skill_drills/widgets/UserAvatar.dart';

import '../Login.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Static variables
  final user = FirebaseAuth.instance.currentUser;

  int _sessionCount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 65),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 25),
                child: FractionalTranslation(
                  translation: Offset(0.0, -0.15),
                  child: Align(
                    child: SizedBox(
                      height: 65,
                      child: UserAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    alignment: FractionalOffset(0.0, 0.0),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      user.displayName != null && user.displayName.isNotEmpty ? user.displayName : user.email,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                  ),
                  Text(
                    "$_sessionCount Sessions",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              padding: EdgeInsets.all(25),
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                signOut();

                navigatorKey.currentState.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
