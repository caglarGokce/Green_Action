import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:greenaction/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploader {
  File _image;
  Future galeridenSec() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    File fileImage = File(image.path);
    return fileImage;
  }

  Future uploadPic(image) async {
    String fileName = basename(CustomAuthentication().getUID());
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    await uploadTask;
    await downloadPic();
  }

  Future uploadProjectPic(image, String imageuid) async {
    String fileName = imageuid;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    await uploadTask;
  }

  Future downloadPic() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile =
        File('${appDocDir.path}/${CustomAuthentication().getUID()}.jpg');
    try {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref(CustomAuthentication().getUID());
      DownloadTask downloadTask =
          firebaseStorageRef.writeToFile(downloadToFile);
      await downloadTask;
      return downloadToFile;
    } catch (e) {
      return null;
    }
  }

  Future downloadProjectPic(imageid) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (await File('${appDocDir.path}/$imageid.jpg').exists()) {
      print('project pic exists');
      return File('${appDocDir.path}/$imageid.jpg');
    }
    File downloadToFile = File('${appDocDir.path}/$imageid.jpg');

    try {
      print('no doesnt exist');
      Reference firebaseStorageRef = FirebaseStorage.instance.ref('$imageid');
      DownloadTask downloadTask =
          firebaseStorageRef.writeToFile(downloadToFile);
      await downloadTask;
      return downloadToFile;
    } catch (e) {
      return null;
    }
  }

  Future<Image> directoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    if (await File('${appDocDir.path}/${CustomAuthentication().getUID()}.jpg')
        .exists()) {
      _image = File('${appDocDir.path}/${CustomAuthentication().getUID()}.jpg');
      print('file path exists');

      return await convertFileToImage(_image);
    } else {
      _image = await downloadPic();
      if (_image != null) {
        print('filepath doesnt exist condition');

        return await convertFileToImage(_image);
      }
      print('filepath doesnt exist');

      return Image(image: AssetImage('lib/assets/images/cat.png'));
    }
  }

  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }
}
