import 'dart:io';

import 'package:discover/widgets/post/tags_dialog.dart';
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
  List<String> _tags = ["Cascade", "Monument", "Plage", "Nature"];
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
    showDialog(
        context: context,
        builder: (_) => TagsDialog(
              tags: _tags,
              selectedTags: _selectedTags,
              onTagChanged: (tag, checked) {
                setState(() {
                  if (checked)
                    _selectedTags.add(tag);
                  else
                    _selectedTags.remove(tag);
                });
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Add post")),
          body: ListView(
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
                        onPressed: _openGalleryCamera,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey[300],
                      width: 60,
                      child: InkWell(
                        onTap: _openTagDialog,
                        child: Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8.0),
                          itemBuilder: (_, i) {
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
                          itemCount: _selectedTags.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Content of post",
                  ),
                  maxLines: 6,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  maxLength: 1000,
                  maxLengthEnforced: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Additional info of place",
                  ),
                  maxLines: 6,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  maxLength: 500,
                  maxLengthEnforced: false,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton.extended(
            onPressed: () {
              // TODO: Send post
            },
            icon: const Icon(Icons.send),
            label: Text("Add post"),
          ),
        ),
      ],
    );
  }
}
