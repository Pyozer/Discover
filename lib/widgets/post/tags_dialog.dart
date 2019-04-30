import 'package:discover/widgets/ui/custom_dialog.dart';
import 'package:flutter/material.dart';

typedef OnTagChange(String tag, bool checked);

class TagsDialog extends StatelessWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final OnTagChange onTagChanged;

  TagsDialog({
    Key key,
    @required this.onTagChanged,
    @required this.selectedTags,
    @required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tags.length,
        itemBuilder: (_, i) => CheckboxListTile(
              onChanged: (checked) {
                onTagChanged(tags[i], checked);
              },
              value:  selectedTags.contains(tags[i]),
              title: Text(tags[i]),
            ),
      ),
    );
  }
}
