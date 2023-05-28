import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neverlost/bloc/app_bloc.dart';
import 'package:neverlost/bloc/app_event.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: "senpai331.rb@gmail.com");
    final passwordController = useTextEditingController(text: "Huraira@1122");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Login"),
      ),
      body: GestureDetector(
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Enter email here...",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.dark,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: "Enter password here...",
                  ),
                  obscureText: true,
                  // obscuringCharacter: '*',
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    context.read<AppBloc>().add(
                          AppEventLogIn(
                            email: email,
                            password: password,
                          ),
                        );
                  },
                  child: const Text("LogIn"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<AppBloc>()
                        .add(const AppEventGotoRegistration());
                  },
                  child: const Text("Not registered yet? Register here!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
