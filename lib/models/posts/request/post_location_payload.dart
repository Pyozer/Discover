class PostsLocationPayload {
  double latitudeUser;
  double longitudeUser;
  int distanceUser;
  List<String> tags;

  PostsLocationPayload({
    this.latitudeUser,
    this.longitudeUser,
    this.distanceUser,
    this.tags,
  });

  Map<String, dynamic> toJson() => {
        "latitude_user": latitudeUser,
        "longitude_user": longitudeUser,
        "distance_user": distanceUser,
        "tags": tags.isEmpty ? ["-1"] : tags,
      };
}
