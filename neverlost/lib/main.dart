import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neverlost/bloc/app_bloc.dart';
import 'package:neverlost/bloc/app_event.dart';
import 'package:neverlost/bloc/app_state.dart';
import 'package:neverlost/dialog/auth_error_dialog.dart';
import 'package:neverlost/firebase_options.dart';
import 'package:neverlost/loading/loading_screen.dart';
import 'package:neverlost/views/login_view.dart';
import 'package:neverlost/views/photo_gallary_view.dart';
import 'package:neverlost/views/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photo Library',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: "Loading...",
              );
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = state.authError;
            if (authError != null) {
              showAuthErrorDialog(
                authError: authError,
                context: context,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedIn) {
              return const PhotoGallaryView();
            }
            if (state is AppStateLoggedOut) {
              return const LoginView();
            }
            if (state is AppStateInRegisterScreenView) {
              return const RegisterView();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
