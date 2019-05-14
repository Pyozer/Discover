import 'dart:io';

import 'package:discover/models/custom_error.dart';
import 'package:discover/models/posts/request/post_payload.dart';
import 'package:discover/models/tags/tag.dart';
import 'package:discover/screens/post_screen.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/utils/keys/asset_key.dart';
import 'package:discover/utils/keys/string_key.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/utils/translations.dart';
import 'package:discover/widgets/place_selector.dart';
import 'package:discover/widgets/tags/tags_selector.dart';
import 'package:discover/widgets/ui/custom_card.dart';
import 'package:discover/widgets/ui/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_amazon_s3/flutter_amazon_s3.dart';
import 'package:uuid/uuid.dart';

enum Position { GPS, CUSTOM }

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key key}) : super(key: key);

  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File _image;
  String _description = "";
  String _additionalInfo = "";
  Position _positionType = Position.GPS;
  List<Tag> _selectedTags = [];
  bool _isLoading = false;
  Geolocator.Position _postPos;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currUserPos = PreferencesProvider.of(context).getUserPos();
    _postPos ??= Geolocator.Position(
      latitude: currUserPos.latitude,
      longitude: currUserPos.longitude,
    );
  }

  Future<String> _uploadImage() async {
    String uploadedImageUrl = await FlutterAmazonS3.uploadImage(
      _image.path,
      'discoverstorage',
      'eu-west-1:19e56073-5b37-4cdf-bdcd-215edbf2c1d1',
      "${Uuid().v1()}.jpg",
    );
    if (!uploadedImageUrl.contains("s3-eu-west-1"))
      throw CustomError(i18n.text(StrKey.errorSendingImage));
    return uploadedImageUrl;
  }

  Future<void> _sendPost() async {
    if ((_image?.path ?? null) == null) {
      return showErrorDialog(context, i18n.text(StrKey.errorEmptyImage));
    }
    if (_description.trim().isEmpty) {
      return showErrorDialog(context, i18n.text(StrKey.errorEmptyDescription));
    }
    if (_selectedTags.length < 1) {
      return showErrorDialog(context, i18n.text(StrKey.errorMinimumOneTag));
    }

    try {
      setState(() => _isLoading = true);
      String imageUrl = await _uploadImage();
      final prefs = PreferencesProvider.of(context);
      final response = await Api().addPost(
        PostPayload(
          imageUrl: imageUrl,
          content: _description,
          infos: _additionalInfo,
          latitude: prefs.getUserPos().latitude,
          longitude: prefs.getUserPos().longitude,
          tags: _selectedTags,
        ),
        prefs.getUser()?.token,
      );
      if ((response.posts?.first?.id ?? null) != null)
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => PostScreen(postId: response.posts.first.id),
        ));
      else
        Navigator.of(context).pop();
    } catch (e) {
      showErrorDialog(context, e);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future _openGalleryCamera() async {
    ImageSource source = await showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomDialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(i18n.text(StrKey.camera)),
                onTap: () {
                  Navigator.of(dialogContext).pop(ImageSource.camera);
                },
              ),
              ListTile(
                title: Text(i18n.text(StrKey.gallery)),
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(i18n.text(StrKey.addPost)),
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
                                AssetKey.placeholderPost,
                                fit: BoxFit.cover,
                              )
                            : Image.file(_image, fit: BoxFit.cover),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            heroTag: "AddCamera",
                            child: const Icon(Icons.add_a_photo),
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
                      Text(i18n.text(StrKey.description),
                          style: textTheme.caption),
                      TextField(
                        maxLines: 7,
                        minLines: 4,
                        keyboardType: TextInputType.multiline,
                        maxLength: 1000,
                        maxLengthEnforced: false,
                        onChanged: (value) {
                          setState(() => _description = value);
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        i18n.text(StrKey.additionalInfo),
                        style: textTheme.caption,
                      ),
                      TextField(
                        maxLines: 6,
                        minLines: 2,
                        keyboardType: TextInputType.multiline,
                        maxLength: 500,
                        maxLengthEnforced: false,
                        onChanged: (value) {
                          setState(() => _additionalInfo = value);
                        },
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
                          i18n.text(StrKey.postLocation),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      RadioListTile<Position>(
                        title: Text(
                          i18n.text(StrKey.customPosition),
                          style: const TextStyle(fontSize: 15),
                        ),
                        value: Position.CUSTOM,
                        groupValue: _positionType,
                        onChanged: (checked) async {
                          final userPos = await showDialog(
                            context: context,
                            builder: (dialogCtx) {
                              return PlaceSelector(
                                onDone: Navigator.of(dialogCtx).pop,
                              );
                            },
                          );
                          if (userPos != null) {
                            _postPos = userPos;
                            setState(() => _positionType = Position.CUSTOM);
                          } else {
                            _postPos =
                                PreferencesProvider.of(context).getUserPos();
                            setState(() => _positionType = Position.GPS);
                          }
                        },
                      ),
                      RadioListTile<Position>(
                        title: Text(
                          i18n.text(StrKey.actualPosition),
                          style: const TextStyle(fontSize: 15),
                        ),
                        value: Position.GPS,
                        groupValue: _positionType,
                        onChanged: (checked) {
                          _postPos =
                              PreferencesProvider.of(context).getUserPos();
                          setState(() => _positionType = Position.GPS);
                        },
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TagsSelector(
                    selectedTags: _selectedTags,
                    onTagsChanged: (tags) {
                      setState(() => _selectedTags = tags);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _sendPost,
        backgroundColor: _isLoading ? Colors.grey[600] : null,
        icon: _isLoading
            ? SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.send),
        label: Text(i18n.text(StrKey.sendPost)),
      ),
    );
  }
}
