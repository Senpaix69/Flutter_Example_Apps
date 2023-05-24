import 'package:firebase_storage/firebase_storage.dart' show Reference;
import 'package:flutter/material.dart';

class StorageImageView extends StatelessWidget {
  final Reference image;
  const StorageImageView({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: image.getData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return circularIndication();
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Image.memory(
                data,
                fit: BoxFit.cover,
              );
            }
            return circularIndication();
        }
      },
    );
  }

  Center circularIndication() => const Center(
        child: CircularProgressIndicator(),
      );
}
