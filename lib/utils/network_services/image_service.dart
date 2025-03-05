import 'dart:io';
import 'package:aws_client/s3_2006_03_01.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '/secrets.dart';

class ImageService{


  static Future<String> uploadImage(XFile image) async {

    String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
    final credentials = AwsClientCredentials(accessKey: AWS_ACCESS_KEY, secretKey: AWS_SECRET_KEY);
    final api = S3(region: 'ap-south-1', credentials: credentials);
    await api.putObject(
      bucket: 'club-app',
      key: filename,
      body: File(image.path).readAsBytesSync(),
    );
    api.close();
    if (kDebugMode) {
      print("https://club-app.s3.ap-south-1.amazonaws.com/$filename");
    }
    return "https://club-app.s3.ap-south-1.amazonaws.com/$filename";
  }

}