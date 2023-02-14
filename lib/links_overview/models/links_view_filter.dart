import 'package:links_repository/links_repository.dart';

enum LinksViewFilter { all }

extension LinksViewFilterX on LinksViewFilter {
  Iterable<Link> applyAll(Iterable<Link> links, String? title) {
    if (title != '' && title != null) {
      return links.where((x) => x.title.contains(title));
    } else {
      return links;
    }
  }
}
