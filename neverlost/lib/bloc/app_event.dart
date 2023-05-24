import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventUploadImage implements AppEvent {
  final String path;
  const AppEventUploadImage({required this.path});
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventLogIn implements AppEvent {
  final String email;
  final String password;
  const AppEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;
  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGotoRegistration implements AppEvent {
  const AppEventGotoRegistration();
}

@immutable
class AppEventGotoLogin implements AppEvent {
  const AppEventGotoLogin();
}
