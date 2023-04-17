import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;

class ImageInput extends StatefulWidget {
  final Function? onSelectImage;

  const ImageInput(this.onSelectImage, {super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? _storedImage;

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 600,
    );

    if (imageFile == null) return;

    setState(() => _storedImage = XFile(imageFile.path));

    final appDir = await sys_path.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    await imageFile.saveTo('${appDir.path}/$fileName');
    widget.onSelectImage!(File(imageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  File(_storedImage!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No image taken',
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt,
            ),
            onPressed: () => _takePicture(),
          ),
        ),
      ],
    );
  }
}
