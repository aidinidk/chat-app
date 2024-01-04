import 'dart:convert';
import 'dart:io';

import 'package:chat/data/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  final imagePicker = ImagePicker();

  Future<void> uploadImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/api/users/photo'),
    );
    request.headers['Authorization'] = 'Bearer ${user['token']}';
    request.headers['Accept'] = 'application/json';

    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        _selectedImage!.path,
        contentType: MediaType('image',
            'jpeg'), // Adjust the content type based on your file type.
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      //  Saving Network Image Path
      const baseUrl = '10.0.2.2:8000';
      final header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user['token']}',
      };
      var url = Uri.http(baseUrl, 'api/users');

      var response = await http.get(url, headers: header);

      var parsed = jsonDecode(response.body);
      setState(() {
        user.update('photo', (value) => parsed['photo']);
      });
      // Handle the response as needed
    } else {}
    _selectedImage = null;
  }

  void askFileOrCamera() async {
    showModalBottomSheet(
        context: context,
        builder: (context) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: _takePicture,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('camera')),
                TextButton.icon(
                    onPressed: _pickPicture,
                    icon: const Icon(Icons.photo_size_select_large_outlined),
                    label: const Text('gallery')),
              ],
            ));
  }

  void _takePicture() async {
    Navigator.of(context).pop();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 100);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  void _pickPicture() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 100);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GestureDetector(
      onTap: askFileOrCamera,
      child: Image.asset('assets/images/profile-create.png'),
    );

    if (user['photo'] != null) {
      content = GestureDetector(
          onTap: askFileOrCamera,
          child:
              Image.network('http://10.0.2.2:8000/storage/${user['photo']!}'));
    }
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: askFileOrCamera,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: Stack(
        children: [
          content,
          if (_selectedImage != null)
            Positioned(
              right: 10,
              bottom: 10,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      uploadImage(_selectedImage!);
                    });
                  },
                  icon: const Icon(
                    Icons.save,
                    size: 50,
                  )),
            ),
        ],
      ),
    );
  }
}
