import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' show Reference;
import 'package:flutter/material.dart' show immutable;
import 'package:neverlost/auth/auth_errors.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  const AppStateLoggedIn({
    required bool isLoading,
    required this.user,
    required this.images,
    AuthError? authError,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );

  @override
  bool operator ==(other) {
    if (other is AppStateLoggedIn) {
      return isLoading == other.isLoading &&
          user.uid == other.user.uid &&
          images.length == other.images.length;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return 'AppStateLoggedIn: images: $images';
  }

  @override
  int get hashCode => Object.hash(user.uid, images);
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );

  @override
  String toString() {
    return "AppStateLoggedOut: loding: $isLoading, authError: $authError";
  }
}

@immutable
class AppStateInRegisterScreenView extends AppState {
  const AppStateInRegisterScreenView({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );
}

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    }
    return null;
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    }
    return null;
  }
}
