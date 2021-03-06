import 'package:discover/models/tags/tag.dart';

import '../sort_mode.dart';

class PostsLocationPayload {
  SortMode sortMode;
  double latitude;
  double longitude;
  int distance;
  List<Tag> tags;

  PostsLocationPayload({
    this.sortMode,
    this.latitude,
    this.longitude,
    this.distance,
    this.tags,
  });

  Map<String, String> toJson() => {
        "sort": sortMode?.value,
        "latitude_user": latitude?.toString(),
        "longitude_user": longitude?.toString(),
        "distance": distance?.toString(),
        "tags": tags?.map((t) => t.id)?.join(','),
      }..removeWhere((_, val) => val == null);
}
