import 'package:image_picker/image_picker.dart';

final class ImagePickerService {
  const ImagePickerService();

  Future<XFile?> getImage([HImageSource source = HImageSource.gallery]) async {
    final picker = ImagePicker();
    return picker.pickImage(
      source: switch (source) {
        HImageSource.camera => ImageSource.camera,
        HImageSource.gallery => ImageSource.gallery,
      },
    );
  }
}

/// Specifies the source where the picked image should come from.
enum HImageSource {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,
}

extension HImageSourceX on HImageSource {
  String get name {
    return switch (this) {
      HImageSource.camera => 'Camera',
      HImageSource.gallery => 'Gallery',
    };
  }
}
