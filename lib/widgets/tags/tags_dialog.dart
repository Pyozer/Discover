import 'package:discover/models/tags/tag.dart';
import 'package:discover/utils/keys/string_key.dart';
import 'package:discover/utils/translations.dart';
import 'package:discover/widgets/ui/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class TagsDialog extends StatefulWidget {
  final List<Tag> tags;
  final List<Tag> selectedTags;

  TagsDialog({
    Key key,
    @required this.selectedTags,
    @required this.tags,
  }) : super(key: key);

  _TagsDialogState createState() => _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog> {
  List<Tag> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = widget.selectedTags;
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: i18n.text(StrKey.chooseTags),
      contentPadding: false,
      content: Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: widget.tags.length,
          itemBuilder: (_, i) {
            final tag = widget.tags[i];
            return CheckboxListTile(
              onChanged: (checked) {
                setState(() {
                  if (checked)
                    _selectedTags.add(tag);
                  else
                    _selectedTags.remove(tag);
                });
              },
              value: _selectedTags.contains(tag),
              title: Text(tag.name),
            );
          },
        ),
      ),
      positiveBtn: i18n.text(StrKey.save),
      onPositive: () => Navigator.of(context).pop(_selectedTags),
      negativeBtn: i18n.text(StrKey.cancel),
      onNegative: Navigator.of(context).pop,
    );
  }
}
