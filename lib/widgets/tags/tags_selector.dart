import 'package:discover/models/tags/tag.dart';
import 'package:discover/utils/api/api.dart';
import 'package:discover/utils/functions.dart';
import 'package:discover/widgets/tags/tags_dialog.dart';
import 'package:discover/widgets/ui/btn_colored.dart';
import 'package:flutter/material.dart';

class TagsSelector extends StatefulWidget {
  final ValueChanged<List<Tag>> onTagsChanged;
  final List<Tag> selectedTags;

  TagsSelector({
    Key key,
    @required this.onTagsChanged,
    @required this.selectedTags,
  }) : super(key: key);

  _TagsSelectorState createState() => _TagsSelectorState();
}

class _TagsSelectorState extends State<TagsSelector> {
  List<Tag> _allTags = [];

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  void _fetchTags() async {
    try {
      final tagsRes = await Api().getTags();
      setState(() => _allTags = tagsRes.tags);
    } catch (e) {
      showErrorDialog(context, e);
    }
  }

  Future _openTagDialog() async {
    List<Tag> newTags = await showDialog<List<Tag>>(
      context: context,
      builder: (_) =>
          TagsDialog(tags: _allTags, selectedTags: widget.selectedTags),
    );
    if (newTags != null) widget.onTagsChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Tags", style: Theme.of(context).textTheme.caption),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: -6.0,
          children: List.generate(
            widget.selectedTags.length,
            (i) {
              return Chip(
                label: Text(
                  widget.selectedTags[i].name,
                  style: const TextStyle(color: Colors.white),
                ),
                elevation: 3,
                labelPadding: const EdgeInsets.only(left: 10),
                onDeleted: () {
                  setState(
                      () => widget.selectedTags.remove(widget.selectedTags[i]));
                },
                deleteIcon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
                backgroundColor: Colors.grey[600],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: BtnColored(
            text: "Select tags",
            onPressed: _openTagDialog,
          ),
        ),
      ],
    );
  }
}
