import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/models/Activity.dart';
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
        ? Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 20.0),
              children: items,
            ),
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              collapsedHeight: 65,
              expandedHeight: 65,
              backgroundColor: Theme.of(context).backgroundColor,
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
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              actions: [],
            ),
          ];
        },
        body: _buildActivities(context),
      ),
    );
  }
}
