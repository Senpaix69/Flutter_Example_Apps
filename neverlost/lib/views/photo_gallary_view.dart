import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neverlost/bloc/app_bloc.dart';
import 'package:neverlost/bloc/app_event.dart';
import 'package:neverlost/bloc/app_state.dart';
import 'package:neverlost/views/pop_up_menu.dart';
import 'package:neverlost/views/storage_image_view.dart';

class PhotoGallaryView extends HookWidget {
  const PhotoGallaryView({super.key});
  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Gallary"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              }
              // ignore: use_build_context_synchronously
              context.read<AppBloc>().add(
                    AppEventUploadImage(
                      path: image.path,
                    ),
                  );
            },
            icon: const Icon(Icons.upload),
          ),
          const PopUpMenu(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images
            .map(
              (image) => StorageImageView(image: image),
            )
            .toList(),
      ),
    );
  }
}
