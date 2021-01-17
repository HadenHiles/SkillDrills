import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:skill_drills/main.dart';
import 'package:skill_drills/models/firestore/Activity.dart';
import 'package:skill_drills/models/firestore/Category.dart';
import 'package:skill_drills/models/firestore/Drill.dart';
import 'package:skill_drills/models/firestore/DrillType.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';
import 'package:skill_drills/services/dialogs.dart';
import 'package:skill_drills/widgets/BasicTitle.dart';
import 'package:skill_drills/services/utility.dart';

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
  final _timerTextController = TextEditingController();

  Drill _drill = Drill("", "", Activity("", null), null);

  List<Activity> _activities;
  Activity _activity = Activity("", null);
  bool _activityError = false;

  List<Category> _selectedCategories = [];
  bool _categoryError = false;

  List<DrillType> _drillTypes;
  DrillType _drillType;
  bool _drillTypeError = false;

  Widget _targetFields;
  Widget _preview;

  @override
  void initState() {
    if (widget.drill != null) {
      _drill = widget.drill;
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

    // Load the drill types
    FirebaseFirestore.instance.collection('drill_types').doc(auth.currentUser.uid).collection('drill_types').orderBy('order').get().then((snapshot) async {
      List<DrillType> drillTypes = [];
      if (snapshot.docs.length > 0) {
        await Future.forEach(snapshot.docs, (doc) async {
          DrillType dt = DrillType.fromSnapshot(doc);
          await _getMeasurements(doc.reference).then((measurements) {
            dt.measurements = measurements;
            drillTypes.add(dt);
          });
        }).then((_) {
          setState(() {
            _drillTypes = drillTypes;
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
                    onPressed: () {
                      bool hasErrors = false;
                      if (_activity.title.isEmpty) {
                        hasErrors = true;
                        setState(() {
                          _activityError = true;
                        });
                      }

                      if (_activity.title.isNotEmpty && _selectedCategories.length < 1) {
                        hasErrors = true;
                        setState(() {
                          _categoryError = true;
                        });
                      }

                      if (_drill.drillType == null) {
                        hasErrors = true;
                        setState(() {
                          _drillTypeError = true;
                        });
                      }

                      if (!hasErrors && widget.drill != null) {
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
                      } else if (!hasErrors) {
                        if (_formKey.currentState.validate()) {
                          // FirebaseFirestore.instance.collection('drills').doc(auth.currentUser.uid).collection('drills').add(
                          //       Drill(
                          //         titleFieldController.text.toString().trim(),
                          //       ).toMap(),
                          //     );

                          navigatorKey.currentState.pop();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ];
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              onChanged: (value) {
                                setState(() {
                                  _drill = Drill(value, _drill.description, _drill.activity, _drill.drillType);
                                });
                              },
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
                              onChanged: (value) {
                                setState(() {
                                  _drill = Drill(_drill.title, value, _drill.activity, _drill.drillType);
                                });
                              },
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
                            color: !_activityError ? Theme.of(context).colorScheme.onPrimary : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                  onLongPress: () {
                    setState(() {
                      _activityError = false;
                      _activity = Activity("", null);
                      _selectedCategories = [];

                      setState(() {
                        _drill = Drill(_drill.title, _drill.description, Activity("", null), _drill.drillType);
                      });
                    });
                  },
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
                                  _activityError = false;
                                  _activity = selected;
                                  _selectedCategories = [];

                                  setState(() {
                                    _drill = Drill(_drill.title, _drill.description, selected, _drill.drillType);
                                  });
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
                        leading: Text(_selectedCategories.length <= 1 ? "Skill" : "Skills", style: Theme.of(context).textTheme.bodyText1),
                        trailing: Text(
                          _selectedCategories.length > 0 ? _outputCategories() : "choose",
                          style: TextStyle(
                            color: !_categoryError ? Theme.of(context).colorScheme.onPrimary : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        onLongPress: () {
                          setState(() {
                            _categoryError = false;
                            _selectedCategories = [];
                            Activity a = Activity(_activity.title, null);
                            a.categories = [];
                            _drill = Drill(_drill.title, _drill.description, a, _drill.drillType);
                          });
                        },
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
                                _categoryError = false;
                                _selectedCategories = selected;
                                Activity a = Activity(_activity.title, null);
                                a.categories = selected;
                                _drill = Drill(_drill.title, _drill.description, a, _drill.drillType);
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
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  leading: Text("Type", style: Theme.of(context).textTheme.bodyText1),
                  trailing: _drillTypes == null
                      ? Container(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          _drillType != null ? _drillType.title : "choose",
                          style: TextStyle(
                            color: !_drillTypeError ? Theme.of(context).colorScheme.onPrimary : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                  onLongPress: () {
                    setState(() {
                      _drillTypeError = false;
                      _drillType = null;
                      _drill = Drill(_drill.title, _drill.description, _drill.activity, null);
                    });
                  },
                  onTap: _drillTypes == null
                      ? null
                      : () {
                          SelectDialog.showModal<DrillType>(
                            context,
                            label: "Choose Type",
                            items: _drillTypes,
                            showSearchBox: false,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            alwaysShowScrollBar: true,
                            selectedValue: _drillType,
                            itemBuilder: (BuildContext context, DrillType drillType, bool isSelected) {
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
                                    drillType.title ?? "",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  subtitle: Text(
                                    drillType.descriptor,
                                    style: Theme.of(context).textTheme.bodyText2,
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
                              setState(() {
                                _drillTypeError = false;
                                _drillType = selected;
                                _drill = Drill(_drill.title, _drill.description, _drill.activity, selected);
                                _preview = _buildPreview(_drill);
                                _targetFields = _buildDefaultTargetFields();
                              });
                            },
                          );
                        },
                ),
                _drillType?.timerInSeconds == null
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _timerTextController,
                              keyboardType: TextInputType.number,
                              scrollPadding: EdgeInsets.all(5),
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                labelText: "Default Duration",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                                hintStyle: Theme.of(context).textTheme.bodyText1,
                              ),
                              onTap: () {
                                const TextStyle suffixStyle = TextStyle(fontSize: 14, height: 1.5);
                                DurationPicker(
                                  adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                                    const NumberPickerColumn(begin: 0, end: 24, suffix: Text(' hrs', style: suffixStyle), jump: 1),
                                    const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' mins', style: suffixStyle), jump: 1),
                                    const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' secs', style: suffixStyle), jump: 5),
                                  ]),
                                  height: 200,
                                  backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                                  textStyle: Theme.of(context).textTheme.headline5,
                                  hideHeader: true,
                                  confirmText: 'Ok',
                                  confirmTextStyle: TextStyle(
                                    inherit: false,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: const Text('Select duration'),
                                  selectedTextStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onConfirm: (Picker picker, List<int> value) {
                                    // You get your duration here
                                    Duration _duration = Duration(hours: picker.getSelectedValues()[0], minutes: picker.getSelectedValues()[1], seconds: picker.getSelectedValues()[2]);

                                    _timerTextController.text = printDuration(_duration);
                                  },
                                ).showDialog(context);
                              },
                            ),
                          ),
                        ],
                      ),
                _drillType == null
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: _targetFields,
                      ),
              ],
            ),
            _preview == null
                ? Container()
                : ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    tileColor: Theme.of(context).colorScheme.primary,
                    title: Text(
                      "Preview",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    trailing: InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _preview = _buildPreview(_drill);
                      });
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                        builder: (BuildContext context) {
                          return _preview;
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

  Future<List<Measurement>> _getMeasurements(DocumentReference dtDoc) async {
    List<Measurement> measurements = [];
    return await dtDoc.collection('measurements').orderBy('order').get().then((measurementSnapshot) async {
      measurementSnapshot.docs.forEach((mDoc) {
        measurements.add(Measurement.fromSnapshot(mDoc));
      });
    }).then((_) => measurements);
  }

  String _outputCategories() {
    String catString = "";

    _selectedCategories.asMap().forEach((i, c) {
      catString += (i != _selectedCategories.length - 1 && _selectedCategories.length != 1) ? c.title + ", " : c.title;
    });

    return catString;
  }

  Widget _buildDefaultTargetFields() {
    Map<int, TextEditingController> targetTextControllers = {};
    List<Widget> targetFields = [];
    List<Measurement> targets = _drillType.measurements.where((m) => m.type == "target").toList();

    targets.asMap().forEach((i, t) {
      targetTextControllers.putIfAbsent(i, () => TextEditingController());

      switch (t.metric) {
        case "amount":
          targetFields.add(
            SizedBox(
              width: targets.length > 1 ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width,
              child: Container(
                child: TextField(
                  controller: targetTextControllers[i],
                  keyboardType: TextInputType.number,
                  scrollPadding: EdgeInsets.all(5),
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: t.label,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );

          break;
        case "duration":
          targetFields.add(
            SizedBox(
              width: targets.length > 1 ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width,
              child: Container(
                child: TextField(
                  controller: targetTextControllers[i],
                  keyboardType: TextInputType.number,
                  scrollPadding: EdgeInsets.all(5),
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: t.label,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  onTap: () {
                    const TextStyle suffixStyle = TextStyle(fontSize: 14, height: 1.5);
                    DurationPicker(
                      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                        const NumberPickerColumn(begin: 0, end: 24, suffix: Text(' hrs', style: suffixStyle), jump: 1),
                        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' mins', style: suffixStyle), jump: 1),
                        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' secs', style: suffixStyle), jump: 5),
                      ]),
                      height: 200,
                      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                      textStyle: Theme.of(context).textTheme.headline5,
                      hideHeader: true,
                      confirmText: 'Ok',
                      confirmTextStyle: TextStyle(
                        inherit: false,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Select duration'),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      onConfirm: (Picker picker, List<int> value) {
                        // You get your duration here
                        Duration _duration = Duration(hours: picker.getSelectedValues()[0], minutes: picker.getSelectedValues()[1], seconds: picker.getSelectedValues()[2]);

                        targetTextControllers[i].text = printDuration(_duration);
                      },
                    ).showDialog(context);
                  },
                ),
              ),
            ),
          );

          break;
        default:
      }
    });

    Widget defaultTargetFields = Column(
      children: [
        Wrap(
          direction: Axis.horizontal,
          children: targetFields,
        ),
      ],
    );

    return defaultTargetFields;
  }

  Widget _buildPreview(Drill drill) {
    Map<int, TextEditingController> measurementTextControllers = {};
    List<Widget> measurementFields = [];

    drill.drillType.measurements.asMap().forEach((i, m) {
      measurementTextControllers.putIfAbsent(i, () => TextEditingController());

      switch (m.metric) {
        case "amount":
          measurementFields.add(
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: measurementTextControllers[i],
                  keyboardType: TextInputType.number,
                  scrollPadding: EdgeInsets.all(5),
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: m.label,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );

          break;
        case "duration":
          measurementFields.add(
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: measurementTextControllers[i],
                  keyboardType: TextInputType.number,
                  scrollPadding: EdgeInsets.all(5),
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: m.label,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  onTap: () {
                    const TextStyle suffixStyle = TextStyle(fontSize: 14, height: 1.5);
                    DurationPicker(
                      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                        const NumberPickerColumn(begin: 0, end: 24, suffix: Text(' hrs', style: suffixStyle), jump: 1),
                        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' mins', style: suffixStyle), jump: 1),
                        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' secs', style: suffixStyle), jump: 5),
                      ]),
                      height: 200,
                      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                      textStyle: Theme.of(context).textTheme.headline5,
                      hideHeader: true,
                      confirmText: 'Ok',
                      confirmTextStyle: TextStyle(
                        inherit: false,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Select duration'),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      onConfirm: (Picker picker, List<int> value) {
                        // You get your duration here
                        Duration _duration = Duration(hours: picker.getSelectedValues()[0], minutes: picker.getSelectedValues()[1], seconds: picker.getSelectedValues()[2]);

                        measurementTextControllers[i].text = printDuration(_duration);
                      },
                    ).showDialog(context);
                  },
                ),
              ),
            ),
          );

          break;
        default:
      }
    });

    String drillTitle = drill.title.isNotEmpty ? drill.title : "(No Title)";

    Widget preview = AbsorbPointer(
      child: Container(
        height: 200,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Preview of \"$drillTitle\"", style: Theme.of(context).textTheme.headline6),
                Divider(height: 5),
                Text(drill.drillType.descriptor, style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            Divider(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  drillTitle,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  _outputCategories(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: measurementFields,
            ),
          ],
        ),
      ),
    );

    return preview;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleFieldController.dispose();
    super.dispose();
  }
}
