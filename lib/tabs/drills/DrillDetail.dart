import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/firestore/Activity.dart';
import 'package:skill_drills/models/firestore/Drill.dart';
import 'package:skill_drills/widgets/BasicTitle.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class DrillDetail extends StatefulWidget {
  DrillDetail({Key key, this.drill}) : super(key: key);

  final Drill drill;

  @override
  _DrillDetailState createState() => _DrillDetailState();
}

class _DrillDetailState extends State<DrillDetail> {
  final _formKey = GlobalKey<FormState>();
  final titleFieldController = TextEditingController();
  final descriptionFieldController = TextEditingController();

  Activity _activity;
  List<Activity> _activities;

  @override
  void initState() {
    if (widget.drill != null) {
      titleFieldController.text = widget.drill.title;
      descriptionFieldController.text = widget.drill.description;
    }

    super.initState();
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
                  title: BasicTitle(title: widget.drill != null ? widget.drill.title : "Drill"),
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
                      Icons.check,
                      size: 28,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: widget.drill == null
                        ? () {
                            if (_formKey.currentState.validate()) {
                              // FirebaseFirestore.instance.collection('drills').doc(auth.currentUser.uid).collection('drills').add(
                              //       Drill(
                              //         titleFieldController.text.toString().trim(),
                              //       ).toMap(),
                              //     );

                              navigatorKey.currentState.pop();
                            }
                          }
                        : () {
                            if (_formKey.currentState.validate()) {
                              // FirebaseFirestore.instance.runTransaction((transaction) async {
                              //   transaction.update(
                              //     widget.drill.reference,
                              //     Drill(
                              //       titleFieldController.text.toString().trim(),
                              //       _categories,
                              //       user.uid ?? null,
                              //     ).toMap(),
                              //   );
                              // });

                              navigatorKey.currentState.pop();
                            }
                          },
                  ),
                ),
              ],
            ),
          ];
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter a title';
                            } else if (!RegExp(r"^[a-zA-Z0-9 ]+$").hasMatch(value)) {
                              return 'No special characters are allowed';
                            }
                            return null;
                          },
                          controller: titleFieldController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          decoration: InputDecoration(
                            labelText: "Title",
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        TextFormField(
                          controller: descriptionFieldController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          minLines: 4,
                          maxLines: 6,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        ListTile(
                          leading: Text("Skill", style: Theme.of(context).textTheme.bodyText1),
                          trailing: Text(_activity?.title ?? "Choose"),
                          onTap: () {
                            FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').get().then((snapshot) {
                              List<Activity> activities = [];
                              if (snapshot.docs.length > 0) {
                                snapshot.docs.forEach((doc) {
                                  activities.add(Activity.fromSnapshot(doc));
                                });

                                setState(() {
                                  _activities = activities;
                                  _activity = activities[0];
                                });

                                SelectDialog.showModal<Activity>(
                                  context,
                                  label: "Choose a Skill",
                                  items: _activities,
                                  selectedValue: _activity,
                                  itemBuilder: (BuildContext context, Activity activity, bool isSelected) {
                                    return Container(
                                      decoration: !isSelected
                                          ? null
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                      child: ListTile(
                                        selected: isSelected,
                                        title: Text(activity.title ?? ""),
                                      ),
                                    );
                                  },
                                  onFind: (String filter) => _getActivities(filter),
                                  onChange: (selected) {
                                    setState(() {
                                      _activity = selected;
                                    });
                                  },
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Activity>> _getActivities(filter) async {
    List<Activity> activities = [];

    await Future.forEach(_activities, (a) async {
      activities.add(a);
    });

    return activities;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleFieldController.dispose();
    super.dispose();
  }
}
