class PostsLocationPayload {
  double latitude;
  double longitude;
  int distance;
  List<String> tags;

  PostsLocationPayload({
    this.latitude,
    this.longitude,
    this.distance,
    this.tags,
  });

  Map<String, String> toJson() => {
        "latitude_user": latitude?.toString(),
        "longitude_user": longitude?.toString(),
        "distance": distance?.toString(),
        "tags": (tags?.isEmpty ?? true) ? "-1" : tags.join(','),
      };
}
