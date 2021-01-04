import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/SkillDrillsDialog.dart';
import 'package:skill_drills/models/firestore/Activity.dart';
import 'package:skill_drills/services/dialogs.dart';
import 'package:skill_drills/tabs/profile/settings/ActivityDetail.dart';

final user = FirebaseAuth.instance.currentUser;

class ActivityItem extends StatefulWidget {
  ActivityItem({Key key, this.activity, this.deleteCallback}) : super(key: key);

  final Activity activity;
  final Function deleteCallback;

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
        color: Theme.of(context).cardTheme.color,
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
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 28,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    confirmDialog(
                        context,
                        SkillDrillsDialog(
                          "Delete \"${widget.activity.title}\"?",
                          "Are you sure you want to delete this activity?\n\nThis action cannot be undone.",
                          null,
                          () {
                            Navigator.of(context).pop();
                          },
                          "Delete",
                          () {
                            widget.deleteCallback(widget.activity);
                            Navigator.of(context).pop();
                          },
                        ));
                  },
                  icon: Icon(
                    Icons.delete,
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
