import 'package:flutter/material.dart';
import 'package:multiple_themes_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeData = themeProvider.themeData;

    return MaterialApp(
      title: 'Theme Example',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: MyScreen(themeProvider: themeProvider),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({
    super.key,
    required this.themeProvider,
  });

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(provider: themeProvider),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, world!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              child: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }

  AppBar myAppBar({required ThemeProvider provider}) {
    return AppBar(
      title: const Text('Theme Example'),
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                value: provider.darkTheme,
                child: const Text("Dark Theme"),
              ),
              PopupMenuItem(
                value: provider.lightTheme,
                child: const Text("Light Theme"),
              ),
              PopupMenuItem(
                value: provider.navyBlue,
                child: const Text("Custom Theme"),
              ),
            ];
          },
          onSelected: (value) => provider.setTheme(theme: value),
        ),
      ],
    );
  }
}
