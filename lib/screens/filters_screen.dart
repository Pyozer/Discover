import 'package:discover/models/tags/tag.dart';
import 'package:discover/utils/providers/preferences_provider.dart';
import 'package:discover/widgets/tags/tags_selector.dart';
import 'package:discover/widgets/ui/custom_card.dart';
import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  FiltersScreen({Key key}) : super(key: key);

  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  double _distance;
  List<Tag> _selectedTags;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final prefs = PreferencesProvider.of(context);
    _distance = prefs.getFilterDistance();
    // Copy tag list object
    _selectedTags = prefs
        .getFilterTags()
        .map((t) => t.toRawJson())
        .map((tStr) => Tag.fromRawJson(tStr))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filters")),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Apply"),
        icon: const Icon(Icons.check),
        onPressed: () {
          final prefs = PreferencesProvider.of(context);
          prefs.setFilterDistance(_distance);
          prefs.setFilterTags(_selectedTags);
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: [
          CustomCard(
            padding: const EdgeInsets.all(16),
            radius: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TagsSelector(
                  selectedTags: _selectedTags,
                  onTagsChanged: (tags) {
                    setState(() => _selectedTags = tags);
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text("Maximum distance: ${_distance.toInt()}km"),
                const SizedBox(height: 12),
                Slider(
                  value: _distance,
                  onChanged: (value) => setState(() => _distance = value),
                  min: 1,
                  max: 300,
                  divisions: 30,
                  label: "Distance ${_distance.toInt()}km",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
