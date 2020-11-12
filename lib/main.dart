import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  String _imgServerPath;

  void _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        child: ListView(
          children: [
            FlatButton(
              onPressed: () {
                _getImageFromGallery();
              },
              child: Text('打开相册'),
            ),
            SizedBox(height: 10),
            _image == null
                ? Center(
                    child: Text('没有选择图片'),
                  )
                : Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 10),
            FlatButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text('上传图片到服务器'),
            ),
            SizedBox(height: 10),
            _imgServerPath == null
                ? Center(
                    child: Text('没有上传图片'),
                  )
                : Image.network(_imgServerPath),
          ],
        ),
      ),
    );
  }

  void _uploadImage() async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_image.path, filename: 'image.png'),
    });
    Response response =
        await Dio().post('https://gekongfei.cn/upload', data: formData);
    setState(() {
      _imgServerPath = response.data;
    });
  }
}
