import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/Activity.dart';
import 'package:skill_drills/models/Category.dart';
import 'package:skill_drills/widgets/BasicTitle.dart';

import 'CategoryItem.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class ActivityDetail extends StatefulWidget {
  ActivityDetail({Key key, this.activity}) : super(key: key);

  final Activity activity;

  @override
  _ActivityDetailState createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  final _formKey = GlobalKey<FormState>();
  final titleFieldController = TextEditingController();

  final _categoryFormKey = GlobalKey<FormState>();
  final categoryTitleFieldController = TextEditingController();
  FocusNode _categoryTitleFocusNode;

  List<Category> _categories;
  int _editingCategoryIndex;

  @override
  void initState() {
    if (widget.activity != null) {
      titleFieldController.text = widget.activity.title;
      _categories = widget.activity.categories;
    }

    _categoryTitleFocusNode = FocusNode();

    super.initState();
  }

  Widget _buildCategoryList(BuildContext context) {
    List<CategoryItem> categoryItems = _categories
        .map((data) => CategoryItem(
              category: data,
              editCallback: _editCategory,
              deleteCallback: _removeCategory,
            ))
        .toList();

    return categoryItems.length > 0
        ? ListView(
            children: categoryItems,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "There are no categories to display",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          );
  }

  void _editCategory(Category category) {
    int editIndex = _categories.indexWhere((cat) => cat == category);
    setState(() {
      _editingCategoryIndex = editIndex;
    });

    categoryTitleFieldController.text = category.title;
    _categoryTitleFocusNode.requestFocus();
  }

  void _removeCategory(Category category) {
    setState(() {
      _categories.remove(category);
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
                  title: BasicTitle(title: widget.activity != null ? widget.activity.title : "Activity"),
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
                    onPressed: widget.activity == null
                        ? () {
                            if (_formKey.currentState.validate()) {
                              FirebaseFirestore.instance.collection('activities').doc(user.uid).collection('activities').add(
                                    Activity(
                                      titleFieldController.text.toString().trim(),
                                      _categories,
                                      user.uid ?? null,
                                    ).toMap(),
                                  );

                              Navigator.of(context).pop();
                            }
                          }
                        : () {
                            if (_formKey.currentState.validate()) {
                              FirebaseFirestore.instance.runTransaction((transaction) async {
                                transaction.update(
                                  widget.activity.reference,
                                  Activity(
                                    titleFieldController.text.toString().trim(),
                                    _categories,
                                    user.uid ?? null,
                                  ).toMap(),
                                );

                                navigatorKey.currentState.pop();
                              });
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "Tap a category to edit",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Container(
                    child: Form(
                      key: _categoryFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter a category name';
                              } else if (!RegExp(r"^[a-zA-Z0-9 ]+$").hasMatch(value)) {
                                return 'No special characters are allowed';
                              }

                              return null;
                            },
                            controller: categoryTitleFieldController,
                            focusNode: _categoryTitleFocusNode,
                            cursorColor: Theme.of(context).colorScheme.onPrimary,
                            decoration: InputDecoration(
                                labelText: _editingCategoryIndex != null ? "Edit Category" : "Add Category",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 14,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _editingCategoryIndex != null ? Icons.check_circle : Icons.add_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    if (_categoryFormKey.currentState.validate()) {
                                      setState(() {
                                        if (_editingCategoryIndex != null) {
                                          _categories
                                              .replaceRange(_editingCategoryIndex, (_editingCategoryIndex + 1), [Category(categoryTitleFieldController.text.toString().trim())]);
                                          _editingCategoryIndex = null;
                                        } else {
                                          _categories.add(Category(categoryTitleFieldController.text.toString().trim()));
                                        }
                                      });

                                      categoryTitleFieldController.clear();
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                )),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: _buildCategoryList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleFieldController.dispose();
    categoryTitleFieldController.dispose();
    _categoryTitleFocusNode.dispose();
    super.dispose();
  }
}
