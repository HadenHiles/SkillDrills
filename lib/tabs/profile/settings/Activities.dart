import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/models/Activity.dart';
import 'package:skill_drills/services/factory.dart';
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

  //Loading counter value on start
  Widget _buildActivities(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').orderBy('title', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildActivityList(context, snapshot.data.docs);
        });
  }

  Widget _buildActivityList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<ActivityItem> items = snapshot
        .map((data) => ActivityItem(
              activity: Activity.fromSnapshot(data),
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
                "There are no items to display",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          );
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
                  title: BasicTitle(title: "Activites"),
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              actions: [],
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
                  confirmResetDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void confirmResetDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Reset",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        resetActivities();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Reset Activities",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 20,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text(
        "Are you sure you want to reset your activities?\n\nThis can't be undone.",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
