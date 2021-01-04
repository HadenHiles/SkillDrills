import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/models/firestore/Category.dart';

final user = FirebaseAuth.instance.currentUser;

class CategoryItem extends StatefulWidget {
  CategoryItem({Key key, this.category, this.editCallback, this.deleteCallback}) : super(key: key);

  final Category category;
  final Function editCallback;
  final Function deleteCallback;

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
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
                      widget.category.title,
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
                    widget.deleteCallback(widget.category);
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
              widget.editCallback(widget.category);
            },
          ),
        ),
      ),
    );
  }
}
