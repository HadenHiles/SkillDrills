import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/SkillDrillsDialog.dart';
import 'package:skill_drills/models/firestore/Category.dart';
import 'package:skill_drills/models/firestore/Drill.dart';
import 'package:skill_drills/services/dialogs.dart';
import 'package:skill_drills/tabs/drills/DrillDetail.dart';

final user = FirebaseAuth.instance.currentUser;

class DrillItem extends StatefulWidget {
  DrillItem({Key key, this.drill, this.deleteCallback}) : super(key: key);

  final Drill drill;
  final Function deleteCallback;

  @override
  _DrillItemState createState() => _DrillItemState();
}

class _DrillItemState extends State<DrillItem> {
  List<Category> _categories = [];

  @override
  void initState() {
    FirebaseFirestore.instance.collection('drills').doc(user.uid).collection('drills').doc(widget.drill.reference.id).collection('categories').get().then((cSnap) {
      List<Category> categories = [];

      cSnap.docs.forEach((m) {
        categories.add(Category.fromSnapshot(m));
      });

      setState(() {
        _categories = categories;
      });
    });

    super.initState();
  }

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
                      widget.drill.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Text(
              _outputCategories(_categories),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 28,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    dialog(
                        context,
                        SkillDrillsDialog(
                          "Delete \"${widget.drill.title}\"?",
                          Text(
                            "Are you sure you want to delete this drill?\n\nThis action cannot be undone.",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          null,
                          () {
                            Navigator.of(context).pop();
                          },
                          "Delete",
                          () {
                            widget.deleteCallback(widget.drill);
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
                return DrillDetail(drill: widget.drill);
              }));
            },
          ),
        ),
      ),
    );
  }

  String _outputCategories(List<Category> categories) {
    String catString = "";

    categories.asMap().forEach((i, c) {
      catString += (i != categories.length - 1 && categories.length != 1) ? c.title + ", " : c.title;
    });

    return catString;
  }
}
