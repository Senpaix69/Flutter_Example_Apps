import 'package:flutter/material.dart' show BuildContext;
import 'package:neverlost/dialog/generic_dialog.dart';

Future<bool> showDeleteAccountDialog({
  required BuildContext context,
}) =>
    showGenericDialog(
        context: context,
        title: "Delete Account",
        content:
            "Are you sure you want to delete your account? You cannot undo this operation!",
        optionsBuilder: () => {'Cancel': false, 'Delete Account': true}).then(
      (value) => value ?? false,
    );
