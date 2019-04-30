import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key key}) : super(key: key);

  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Add post")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: screenSize.height / 3.5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _image == null
                    ? Image.network(
                        "http://www.independentmediators.co.uk/wp-content/uploads/2016/02/placeholder-image.jpg",
                        fit: BoxFit.cover,
                      )
                    : Image.file(_image, fit: BoxFit.cover),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: "AddCamera",
                    child: Icon(Icons.add_a_photo),
                    onPressed: getImage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Send post
        },
        icon: Icon(Icons.send),
        label: Text("Add post"),
      ),
    );
  }
}
