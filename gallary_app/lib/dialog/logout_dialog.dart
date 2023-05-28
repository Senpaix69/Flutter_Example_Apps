import 'package:flutter/material.dart' show BuildContext;
import 'package:neverlost/dialog/generic_dialog.dart';

Future<bool> showLogOutDialog({
  required BuildContext context,
}) =>
    showGenericDialog(
        context: context,
        title: "Logout",
        content: "Are you sure you want to logout?",
        optionsBuilder: () => {'Cancel': false, 'Logout': true}).then(
      (value) => value ?? false,
    );
