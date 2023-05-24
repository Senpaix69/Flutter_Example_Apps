import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neverlost/bloc/app_bloc.dart';
import 'package:neverlost/bloc/app_event.dart';
import 'package:neverlost/dialog/delete_account_dialog.dart';
import 'package:neverlost/dialog/logout_dialog.dart';

enum MenuAction {
  deleteAcount,
  logOut,
}

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logOut:
            final logOut = await showLogOutDialog(context: context);
            if (logOut) {
              // ignore: use_build_context_synchronously
              context.read<AppBloc>().add(const AppEventLogOut());
            }
            break;
          case MenuAction.deleteAcount:
            final del = await showDeleteAccountDialog(context: context);
            if (del) {
              // ignore: use_build_context_synchronously
              context.read<AppBloc>().add(const AppEventDeleteAccount());
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logOut,
            child: Text("LogOut"),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logOut,
            child: Text("Delete Account"),
          )
        ];
      },
    );
  }
}
