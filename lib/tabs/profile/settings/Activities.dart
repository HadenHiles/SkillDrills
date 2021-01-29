import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/firestore/Activity.dart';
import 'package:skill_drills/models/SkillDrillsDialog.dart';
import 'package:skill_drills/services/dialogs.dart';
import 'package:skill_drills/services/factory.dart';
import 'package:skill_drills/tabs/profile/settings/ActivityDetail.dart';
import 'package:skill_drills/tabs/profile/settings/ActivityItem.dart';
import 'package:skill_drills/widgets/BasicTitle.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class ActivitiesSettings extends StatefulWidget {
  ActivitiesSettings({Key key}) : super(key: key);

  @override
  _ActivitiesSettingsState createState() => _ActivitiesSettingsState();
}

class _ActivitiesSettingsState extends State<ActivitiesSettings> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildActivities(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').orderBy('title', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );

          return _buildActivityList(context, snapshot.data.docs);
        });
  }

  Widget _buildActivityList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<ActivityItem> items = snapshot
        .map((data) => ActivityItem(
              activity: Activity.fromSnapshot(data),
              deleteCallback: _deleteActivity,
            ))
        .toList();

    return items.length > 0
        ? ListView(
            padding: EdgeInsets.only(top: 10),
            children: items,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "There are no sports (activities) to display",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          );
  }

  void _deleteActivity(Activity activity) {
    FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').doc(activity.reference.id).get().then((doc) {
      doc.reference.collection('categories').get().then((catSnapshots) {
        catSnapshots.docs.forEach((cDoc) {
          cDoc.reference.delete();
        });
      });

      doc.reference.delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              collapsedHeight: 65,
              expandedHeight: 65,
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              floating: false,
              pinned: true,
              leading: Container(
                margin: EdgeInsets.only(top: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding: null,
                  centerTitle: false,
                  title: Row(
                    children: [
                      BasicTitle(title: "Sports"),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "(Activities)",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 28,
                    ),
                    onPressed: () {
                      navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
                        return ActivityDetail();
                      }));
                    },
                  ),
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            Flexible(
              child: _buildActivities(context),
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                padding: EdgeInsets.all(25),
                child: Text(
                  "Reset to defaults",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  dialog(
                      context,
                      SkillDrillsDialog(
                        "Reset Sports?",
                        Text(
                          "Are you sure you want to reset your sports?\n\nThis can't be undone.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        "Cancel",
                        () {
                          Navigator.of(context).pop();
                        },
                        "Reset",
                        () {
                          resetActivities();
                          Navigator.of(context).pop();
                        },
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
