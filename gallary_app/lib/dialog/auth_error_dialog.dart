import 'package:flutter/material.dart' show BuildContext;
import 'package:neverlost/auth/auth_errors.dart';
import 'package:neverlost/dialog/generic_dialog.dart';

Future<void> showAuthErrorDialog({
  required AuthError authError,
  required BuildContext context,
}) =>
    showGenericDialog(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionsBuilder: () => {'OK': true},
    );
