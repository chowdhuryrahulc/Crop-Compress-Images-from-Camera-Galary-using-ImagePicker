// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    var xFileImage = await ImagePicker().pickImage(
      source: source,
      // imageQuality: 50
    );
    // imageQuality present in pickImage.
    // But cant replace, as imageSize of croppedImage is same.

    //Cropping the image

    File? croppedFile = await ImageCropper.cropImage(
        // no need to use the 'flutter_image_compress' plugin as
        // 'image_cropper' plugin already provides a compressQuality
        // parameter under the cropImage method.
        sourcePath: xFileImage!.path,
        aspectRatio: CropAspectRatio(ratioX: 829, ratioY: 985),
        maxWidth: 512,
        maxHeight: 512,
        compressQuality: 50 // Working
        );

    // print('Image Cropped');
    // print(croppedFile?.lengthSync()); // 54000 => 18000
    setState(() {
      _image = croppedFile;
    });

    //Compress the image
    //? Useful if you want to compress without cropping

    // var result = await FlutterImageCompress.compressAndGetFile(
    //   croppedFile!.path, // path
    //   xFileImage.path, // Target Path
    //   quality: 50, // 34313 => 13762
    // );

    // setState(() {
    //   _image = result;
    //   print('Image After');
    //   print(result?.lengthSync());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Click | Pick | Crop | Compress"),
      ),
      body: Center(
        child: _image == null
            ? Text("Image")
            : Image.file(
                _image!,
                height: 200,
                width: 200,
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text("Camera"),
            onPressed: () => getImageFile(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            label: Text("Gallery"),
            onPressed: () => getImageFile(ImageSource.gallery),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          )
        ],
      ),
    );
  }
}
