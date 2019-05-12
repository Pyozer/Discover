class SortMode {
  final String value;
  const SortMode._(this.value);

  static const DATE = SortMode._('date_post');
  static const LIKES = SortMode._('likes_post');
  static const COMMENTS = SortMode._('comments_post');

  static List<SortMode> get values => [DATE, LIKES, COMMENTS];

  static SortMode fromValue(String value) {
    return values.firstWhere(
      (r) => r.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => DATE,
    );
  }

  @override
  String toString() {
    if (this == COMMENTS) return "comments";
    if (this == LIKES) return "likes";
    return "date";
  }

  @override
  bool operator ==(dynamic other) => other is SortMode && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
