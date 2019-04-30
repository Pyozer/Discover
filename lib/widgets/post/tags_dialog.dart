import 'package:discover/widgets/ui/btn_colored.dart';
import 'package:discover/widgets/ui/custom_dialog.dart';
import 'package:discover/widgets/ui/flat_btn_rounded.dart';
import 'package:flutter/material.dart';

class TagsDialog extends StatefulWidget {
  final List<String> tags;
  final List<String> selectedTags;

  TagsDialog({
    Key key,
    @required this.selectedTags,
    @required this.tags,
  }) : super(key: key);

  _TagsDialogState createState() => _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog> {
  List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = widget.selectedTags;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Choose tags",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
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
                title: Text(tag),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatBtnRounded(
                  text: "Cancel",
                  onPressed: Navigator.of(context).pop,
                ),
                const SizedBox(width: 12.0),
                BtnColored(
                  text: "Save",
                  onPressed: () {
                    Navigator.of(context).pop(_selectedTags);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
