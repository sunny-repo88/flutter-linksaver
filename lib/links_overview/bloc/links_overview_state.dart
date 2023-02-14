part of 'links_overview_bloc.dart';

enum LinksOverviewStatus {
  initial,
  loading,
  success,
  failure,

  deleteLoading,
  deleteSuccess,
  deleteFailure
}

class LinksOverviewState extends Equatable {
  const LinksOverviewState({
    this.status = LinksOverviewStatus.initial,
    this.links = const [],
    this.filter = LinksViewFilter.all,
    this.lastDeletedLink,
    this.title = '',
    this.collections = const [],
    this.sort = LinksViewsSort.byNewest,
  });

  final LinksOverviewStatus status;
  final List<Link> links;
  final List<Collection> collections;
  final LinksViewFilter filter;
  final Link? lastDeletedLink;
  final String? title;
  final LinksViewsSort sort;

  Iterable<Link> get filteredLinks =>
      LinksViewFilter.all.applyAll(links, title);

  LinksOverviewState copyWith({
    LinksOverviewStatus Function()? status,
    List<Link> Function()? links,
    LinksViewFilter Function()? filter,
    LinksViewsSort Function()? sort,
    Link? Function()? lastDeletedLink,
    String? title,
    List<Collection>? collections,
  }) {
    return LinksOverviewState(
      status: status != null ? status() : this.status,
      links: links != null ? links() : this.links,
      filter: filter != null ? filter() : this.filter,
      sort: sort != null ? sort() : this.sort,
      lastDeletedLink:
          lastDeletedLink != null ? lastDeletedLink() : this.lastDeletedLink,
      title: title ?? this.title,
      collections: collections != null ? collections : this.collections,
    );
  }

  @override
  List<Object?> get props => [
        status,
        links,
        filter,
        sort,
        lastDeletedLink,
        title,
        collections,
      ];
}
