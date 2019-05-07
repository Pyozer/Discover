import 'dart:io';

import 'package:discover/widgets/post/tags_dialog.dart';
import 'package:discover/widgets/ui/btn_colored.dart';
import 'package:discover/widgets/ui/custom_card.dart';
import 'package:discover/widgets/ui/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_amazon_s3/flutter_amazon_s3.dart';

enum Position { GPS, CUSTOM }

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key key}) : super(key: key);

  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File _image;
  List<String> _tags = [];
  List<String> _selectedTags = [];
  Position _positionType = Position.GPS;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTags();
  }

  void _fetchTags() async {
    setState(() {
      _tags = [
        "Cascade",
        "Monument",
        "Plage",
        "Nature",
        "Musée",
        "Bibliothèque",
        "Statue",
        "Lieu culte",
        "Mairie",
        "Château",
        "Ruine",
        "Boutique",
        "Restaurant",
      ];
    });
  }

  Future<String> _uploadImage() async {
    /*String uploadedImageUrl = await FlutterAmazonS3.uploadImage(
      _image.path,
      BUCKET_NAME,
      IDENTITY_POOL_ID,
    );*/
    return "http://images.unsplash.com/photo-1555985202-12975b0235dc";
  }

  Future<void> _sendPost() async {
    String imageUrl = await _uploadImage();
  }

  Future _openGalleryCamera() async {
    ImageSource source = await showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomDialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("Camera"),
                onTap: () {
                  Navigator.of(dialogContext).pop(ImageSource.camera);
                },
              ),
              ListTile(
                title: Text("Gallery"),
                onTap: () {
                  Navigator.of(dialogContext).pop(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
    if (source == null) return;

    final image = await ImagePicker.pickImage(source: source);
    setState(() => _image = image);
  }

  Future _openTagDialog() async {
    List<String> newTags = await showDialog<List<String>>(
      context: context,
      builder: (_) => TagsDialog(tags: _tags, selectedTags: _selectedTags),
    );
    if (newTags != null) setState(() => _selectedTags = newTags);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Add post"),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(color: Theme.of(context).primaryColor, height: 60),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                CustomCard(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    height: screenSize.height / 3.5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _image == null
                            ? Image.asset(
                                "assets/images/placeholder_post.png",
                                fit: BoxFit.cover,
                              )
                            : Image.file(_image, fit: BoxFit.cover),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            heroTag: "AddCamera",
                            child: Icon(Icons.add_a_photo),
                            onPressed: _openGalleryCamera,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                CustomCard(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Description",
                          style: Theme.of(context).textTheme.caption),
                      TextField(
                        maxLines: 7,
                        minLines: 4,
                        keyboardType: TextInputType.multiline,
                        maxLength: 1000,
                        maxLengthEnforced: false,
                      ),
                      const SizedBox(height: 10),
                      Text("Additional informations",
                          style: Theme.of(context).textTheme.caption),
                      TextField(
                        maxLines: 6,
                        minLines: 2,
                        keyboardType: TextInputType.multiline,
                        maxLength: 500,
                        maxLengthEnforced: false,
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 6),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Post location",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      RadioListTile<Position>(
                        title: Text(
                          "Custom position",
                          style: const TextStyle(fontSize: 15),
                        ),
                        value: Position.CUSTOM,
                        groupValue: _positionType,
                        onChanged: (checked) {
                          setState(() => _positionType = Position.CUSTOM);
                        },
                      ),
                      RadioListTile<Position>(
                        title: Text(
                          "My actual position",
                          style: const TextStyle(fontSize: 15),
                        ),
                        value: Position.GPS,
                        groupValue: _positionType,
                        onChanged: (checked) {
                          setState(() => _positionType = Position.GPS);
                        },
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Tags", style: Theme.of(context).textTheme.caption),
                      const SizedBox(height: 10.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: -6.0,
                        children: List.generate(
                          _selectedTags.length,
                          (i) {
                            return Chip(
                              label: Text(
                                _selectedTags[i],
                                style: const TextStyle(color: Colors.white),
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedTags.remove(_selectedTags[i]);
                                });
                              },
                              deleteIcon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.grey[600],
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: BtnColored(
                          text: "Edit tags",
                          onPressed: _openTagDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Send post
        },
        icon: const Icon(Icons.send),
        label: Text("Send post"),
      ),
    );
  }
}
