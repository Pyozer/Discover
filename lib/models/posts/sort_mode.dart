import 'package:discover/utils/keys/string_key.dart';
import 'package:discover/utils/translations.dart';

class SortMode {
  final String value;
  const SortMode._(this.value);

  static const DISTANCE = SortMode._('distance');
  static const DATE = SortMode._('date_post');
  static const LIKES = SortMode._('likes_post');
  static const COMMENTS = SortMode._('comments_post');

  static List<SortMode> get values => [DISTANCE, DATE, LIKES, COMMENTS];

  static SortMode fromValue(String value) {
    return values.firstWhere(
      (r) => r.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => DISTANCE,
    );
  }

  @override
  String toString() {
    if (this == DATE) return i18n.text(StrKey.sortDate);
    if (this == COMMENTS) return i18n.text(StrKey.sortComments);
    if (this == LIKES) return i18n.text(StrKey.sortLikes);
    return i18n.text(StrKey.sortDistance);
  }

  @override
  bool operator ==(dynamic other) => other is SortMode && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
