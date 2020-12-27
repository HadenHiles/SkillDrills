import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
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
                    child: Text(
                      user.displayName != null && user.displayName.isNotEmpty ? user.displayName : "You",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
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

                Navigator.of(context).pushReplacement(
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
