import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/Activity.dart';
import 'package:skill_drills/tabs/profile/settings/ActivityDetail.dart';

final user = FirebaseAuth.instance.currentUser;

class ActivityItem extends StatefulWidget {
  ActivityItem({Key key, this.activity}) : super(key: key);

  final Activity activity;

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
        color: Theme.of(context).colorScheme.primaryVariant,
        elevation: 1.0,
        child: Padding(
          padding: EdgeInsets.all(2),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  iconSize: 28,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
                      return ActivityDetail(activity: widget.activity);
                    }));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).iconTheme.color,
                    size: 20,
                  ),
                ),
              ],
            ),
            onTap: () {
              navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
                return ActivityDetail(activity: widget.activity);
              }));
            },
          ),
        ),
      ),
    );
  }
}
