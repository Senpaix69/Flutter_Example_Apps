import 'dart:io' show File;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:neverlost/auth/auth_errors.dart';
import 'package:neverlost/bloc/app_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neverlost/bloc/app_state.dart';
import 'package:neverlost/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    on<AppEventGotoRegistration>(
      (event, emit) async {
        emit(
          const AppStateInRegisterScreenView(isLoading: false),
        );
      },
    );

    on<AppEventLogIn>(
      (event, emit) async {
        emit(const AppStateLoggedOut(isLoading: true));
        final email = event.email;
        final password = event.password;

        try {
          final credintials =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = credintials.user!;
          final images = await _getImages(user.uid);
          emit(AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ));
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateInRegisterScreenView(
                isLoading: false, authError: AuthError.from(e)),
          );
        }
      },
    );

    on<AppEventGotoLogin>(
      (event, emit) {
        emit(const AppStateLoggedOut(isLoading: false));
      },
    );

    on<AppEventRegister>((event, emit) async {
      emit(const AppStateInRegisterScreenView(isLoading: true));
      final email = event.email;
      final password = event.password;

      try {
        final credintials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        emit(AppStateLoggedIn(
          isLoading: false,
          user: credintials.user!,
          images: const [],
        ));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateInRegisterScreenView(
              isLoading: false, authError: AuthError.from(e)),
        );
      }
    });

    on<AppEventInitialize>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(const AppStateLoggedOut(isLoading: false));
          return;
        }
        final images = await _getImages(user.uid);

        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ));
      },
    );

    on<AppEventLogOut>(
      (event, emit) async {
        emit(const AppStateLoggedOut(isLoading: true));
        await FirebaseAuth.instance.signOut();
        emit(const AppStateLoggedOut(isLoading: false));
      },
    );

    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }
        emit(AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ));

        try {
          final folder = await FirebaseStorage.instance.ref(user.uid).listAll();

          // deleteing items
          for (final item in folder.items) {
            await item.delete().catchError((_) {});
          }

          // deleting folder
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          // deleting user
          await user.delete().catchError((_) {});
          await FirebaseAuth.instance.signOut();
          emit(const AppStateLoggedOut(isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
          ));
        } on FirebaseException {
          emit(const AppStateLoggedOut(isLoading: false));
        }
      },
    );

    on<AppEventUploadImage>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }
        emit(AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ));

        final file = File(event.path);
        await uploadImage(file: file, userId: user.uid);
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ));
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance.ref(userId).list().then(
            (res) => res.items,
          );
}
