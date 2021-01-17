import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Dialog;
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/PickerLocalizations.dart';
import 'package:skill_drills/models/SkillDrillsDialog.dart';

void dialog(BuildContext context, SkillDrillsDialog dialog) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      dialog.cancelText ?? "Cancel",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    ),
    onPressed: dialog.cancelCallback ?? () {},
  );
  Widget continueButton = FlatButton(
    child: Text(
      dialog.continueText ?? "Continue",
      style: TextStyle(color: Colors.red),
    ),
    onPressed: dialog.continueCallback ?? () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      dialog.title ?? "Are you sure?",
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
      ),
    ),
    backgroundColor: Theme.of(context).backgroundColor,
    content: dialog.body != null
        ? dialog.body
        : Text(
            "This action cannot be undone.",
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

class DurationPicker extends Picker {
  static const double DefaultTextSize = 20.0;

  /// Index of currently selected items
  List<int> selecteds;

  /// Picker adapter, Used to provide data and generate widgets
  final PickerAdapter adapter;

  /// insert separator before picker columns
  final List<PickerDelimiter> delimiter;

  final VoidCallback onCancel;
  final PickerSelectedCallback onSelect;
  final PickerConfirmCallback onConfirm;

  /// When the previous level selection changes, scroll the child to the first item.
  final changeToFirst;

  /// Specify flex for each column
  final List<int> columnFlex;

  final Widget title;
  final Widget cancel;
  final Widget confirm;
  final String cancelText;
  final String confirmText;

  final double height;

  /// Height of list item
  final double itemExtent;

  final TextStyle textStyle, cancelTextStyle, confirmTextStyle, selectedTextStyle;
  final TextAlign textAlign;

  /// Text scaling factor
  final double textScaleFactor;

  final EdgeInsetsGeometry columnPadding;
  final Color backgroundColor, headercolor, containerColor;

  /// Hide head
  final bool hideHeader;

  /// Show pickers in reversed order
  final bool reversedOrder;

  /// Generate a custom header， [hideHeader] = true
  final WidgetBuilder builderHeader;

  /// List item loop
  final bool looping;

  /// Delay generation for smoother animation, This is the number of milliseconds to wait. It is recommended to > = 200
  final int smooth;

  final Widget footer;

  final Decoration headerDecoration;

  final double magnification;
  final double diameterRatio;
  final double squeeze;

  DurationPicker({
    this.adapter,
    this.delimiter,
    this.selecteds,
    this.height = 150.0,
    this.itemExtent = 28.0,
    this.columnPadding,
    this.textStyle,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.selectedTextStyle,
    this.textAlign = TextAlign.start,
    this.textScaleFactor,
    this.title,
    this.cancel,
    this.confirm,
    this.cancelText,
    this.confirmText,
    this.backgroundColor = Colors.white,
    this.containerColor,
    this.headercolor,
    this.builderHeader,
    this.changeToFirst = false,
    this.hideHeader = false,
    this.looping = false,
    this.reversedOrder = false,
    this.headerDecoration,
    this.columnFlex,
    this.footer,
    this.smooth,
    this.magnification = 1.0,
    this.diameterRatio = 1.1,
    this.squeeze = 1.45,
    this.onCancel,
    this.onSelect,
    this.onConfirm,
  }) : super(
          adapter: adapter,
          delimiter: delimiter,
          selecteds: selecteds,
          height: height,
          itemExtent: itemExtent,
          columnPadding: columnPadding,
          textStyle: textStyle,
          cancelTextStyle: cancelTextStyle,
          confirmTextStyle: confirmTextStyle,
          selectedTextStyle: selectedTextStyle,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          title: title,
          cancel: cancel,
          confirm: confirm,
          cancelText: cancelText,
          confirmText: confirmText,
          backgroundColor: backgroundColor,
          containerColor: containerColor,
          headercolor: headercolor,
          builderHeader: builderHeader,
          changeToFirst: changeToFirst,
          hideHeader: hideHeader,
          looping: looping,
          reversedOrder: reversedOrder,
          headerDecoration: headerDecoration,
          columnFlex: columnFlex,
          footer: footer,
          smooth: smooth,
          magnification: magnification,
          diameterRatio: diameterRatio,
          squeeze: squeeze,
          onCancel: onCancel,
          onSelect: onSelect,
          onConfirm: onConfirm,
        );

  /// show duration dialog picker
  Future<List<int>> showDialog(BuildContext context, {bool barrierDismissible = true, Key key}) {
    return Dialog.showDialog<List<int>>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          List<Widget> actions = [];

          if (cancel == null) {
            String _cancelText = cancelText ?? PickerLocalizations.of(context).cancelText;
            if (_cancelText != null && _cancelText != "") {
              actions.add(FlatButton(
                  onPressed: () {
                    Navigator.pop<List<int>>(context, null);
                    if (onCancel != null) onCancel();
                  },
                  child: cancelTextStyle == null ? Text(_cancelText) : DefaultTextStyle(child: Text(_cancelText), style: cancelTextStyle)));
            }
          } else {
            actions.add(cancel);
          }

          if (confirm == null) {
            String _confirmText = confirmText ?? PickerLocalizations.of(context).confirmText;
            if (_confirmText != null && _confirmText != "") {
              actions.add(FlatButton(
                  onPressed: () {
                    Navigator.pop<List<int>>(context, selecteds);
                    if (onConfirm != null) onConfirm(this, selecteds);
                  },
                  child: confirmTextStyle == null ? Text(_confirmText) : DefaultTextStyle(child: Text(_confirmText), style: confirmTextStyle)));
            }
          } else {
            actions.add(confirm);
          }

          return AlertDialog(
            key: key ?? Key('picker-dialog'),
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            title: title,
            actions: actions,
            titlePadding: EdgeInsets.all(20),
            contentPadding: EdgeInsets.all(20),
            insetPadding: EdgeInsets.all(0),
            content: makePicker(),
          );
        });
  }
}
