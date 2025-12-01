import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_shared/services/image_picker_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ImageSourceModal extends StatelessWidget {
  const ImageSourceModal._();

  static Future<HImageSource?> show(BuildContext context) {
    return showModalBottomSheet<HImageSource?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => const ImageSourceModal._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const sources = HImageSource.values;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20).r,
      shrinkWrap: true,
      itemCount: sources.length,
      itemBuilder: (context, index) {
        final source = sources[index];

        return ListTile(
          leading: Icon(icon(source)),
          title: Text(description(source)),
          onTap: () => context.pop(source),
        );
      },
    );
  }

  IconData icon(HImageSource source) => switch (source) {
    HImageSource.camera => PhosphorIconsFill.camera,
    HImageSource.gallery => PhosphorIconsFill.images,
  };

  String description(HImageSource source) => switch (source) {
    HImageSource.camera => 'Take a picture',
    HImageSource.gallery => 'Select from gallery',
  };
}
