import 'package:flutter/material.dart';

class SkillDrillsDialog {
  final String title;
  final Widget body;
  final String cancelText;
  final Function cancelCallback;
  final String continueText;
  final Function continueCallback;

  SkillDrillsDialog(this.title, this.body, this.cancelText, this.cancelCallback, this.continueText, this.continueCallback);
}
