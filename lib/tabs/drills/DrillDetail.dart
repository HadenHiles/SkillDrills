import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/firestore/Activity.dart';
import 'package:skill_drills/models/firestore/Category.dart';
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
  final _titleFieldController = TextEditingController();
  final _descriptionFieldController = TextEditingController();

  List<Activity> _activities;
  Activity _activity = Activity("", null);

  List<Category> _selectedCategories = [];

  @override
  void initState() {
    if (widget.drill != null) {
      _titleFieldController.text = widget.drill.title;
      _descriptionFieldController.text = widget.drill.description;
    }

    // Load the activities
    FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').get().then((snapshot) async {
      List<Activity> activities = [];
      if (snapshot.docs.length > 0) {
        await Future.forEach(snapshot.docs, (doc) async {
          Activity a = Activity.fromSnapshot(doc);
          await _getCategories(doc.reference).then((categories) {
            a.categories = categories;
            activities.add(a);
          });
        }).then((_) {
          setState(() {
            _activities = activities;
            _activity = _activity == null ? activities[0] : _activity;
          });
        });
      }
    });

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
                          controller: _titleFieldController,
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
                          controller: _descriptionFieldController,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              leading: Text("Sport", style: Theme.of(context).textTheme.bodyText1),
              trailing: _activities == null
                  ? Container(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      _activity.title.isNotEmpty ? _activity.title : "choose",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                      ),
                    ),
              onTap: _activities == null
                  ? null
                  : () {
                      SelectDialog.showModal<Activity>(
                        context,
                        label: "Choose Sport",
                        items: _activities,
                        showSearchBox: false,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        alwaysShowScrollBar: true,
                        selectedValue: _activity,
                        itemBuilder: (BuildContext context, Activity activity, bool isSelected) {
                          return Container(
                            decoration: !isSelected
                                ? null
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).colorScheme.primaryVariant,
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                            child: ListTile(
                              selected: isSelected,
                              tileColor: Theme.of(context).colorScheme.primary,
                              title: Text(
                                activity.title ?? "",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          );
                        },
                        emptyBuilder: (context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          );
                        },
                        onChange: (selected) async {
                          await _getCategories(selected.reference).then((cats) async {
                            selected.categories = cats;

                            setState(() {
                              _activity = selected;
                              _selectedCategories = [];
                            });
                          });
                        },
                      );
                    },
            ),
            (_activity.categories?.length ?? 0) < 1
                ? Container()
                : ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    leading: Text("Skill", style: Theme.of(context).textTheme.bodyText1),
                    trailing: Text(
                      _selectedCategories.length > 0 ? _outputCategories() : "choose",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      SelectDialog.showModal<Category>(
                        context,
                        label: "Choose Skill(s)",
                        items: _activity.categories,
                        showSearchBox: false,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        alwaysShowScrollBar: true,
                        multipleSelectedValues: _selectedCategories,
                        itemBuilder: (BuildContext context, Category category, bool isSelected) {
                          return Container(
                            decoration: !isSelected
                                ? null
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).colorScheme.primaryVariant,
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                            child: ListTile(
                              selected: isSelected,
                              tileColor: Theme.of(context).colorScheme.primary,
                              title: Text(
                                category.title ?? "",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              trailing: isSelected ? Icon(Icons.check) : null,
                            ),
                          );
                        },
                        onMultipleItemsChange: (List<Category> selected) {
                          setState(() {
                            _selectedCategories = selected;
                          });
                        },
                        okButtonBuilder: (context, onPressed) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: FloatingActionButton(
                              onPressed: onPressed,
                              child: Icon(Icons.check),
                              mini: true,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Future<List<Category>> _getCategories(DocumentReference aDoc) async {
    List<Category> categories = [];
    return await aDoc.collection('categories').get().then((catSnapshot) async {
      catSnapshot.docs.forEach((cDoc) {
        categories.add(Category.fromSnapshot(cDoc));
      });
    }).then((_) => categories);
  }

  String _outputCategories() {
    String catString = "";

    _selectedCategories.asMap().forEach((i, c) {
      catString += (i != _selectedCategories.length - 1 && _selectedCategories.length != 1) ? c.title + ", " : c.title;
    });

    return catString;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleFieldController.dispose();
    super.dispose();
  }
}
