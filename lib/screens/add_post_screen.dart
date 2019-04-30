import 'dart:io';

import 'package:discover/widgets/post/tags_dialog.dart';
import 'package:discover/widgets/ui/btn_colored.dart';
import 'package:discover/widgets/ui/custom_card.dart';
import 'package:discover/widgets/ui/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key key}) : super(key: key);

  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File _image;
  List<String> _tags = ["Cascade", "Monument", "Plage", "Nature", "Musée", "Bibliothèque", "Statue", "Lieu culte", "Mairie", "Château", "Ruine", "Boutique", "Restaurant"];
  List<String> _selectedTags = [];

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
      builder: (_) => TagsDialog(
            tags: _tags,
            selectedTags: _selectedTags,
          ),
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
        actions: [
          FlatButton(
            textColor: Colors.white,
            child: Text("PUBLISH"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            onPressed: () {
              // TODO: Send post
            },
          ),
        ],
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
              padding: const EdgeInsets.all(16.0),
              children: [
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
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
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
                            onPressed: _openGalleryCamera,
                          ),
                        )
                      ],
                    ),
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
                              deleteIcon:
                                  const Icon(Icons.close, color: Colors.white),
                              backgroundColor: Colors.grey[600],
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: BtnColored(
                          text: "Add tag",
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
    );
  }
}
