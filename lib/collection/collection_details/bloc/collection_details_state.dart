part of 'collection_details_bloc.dart';

enum CollectionDetailsStatus {
  initial,
  loading,
  success,
  loadFailure,

  editLinkSuccess,
  editLinkFailure,

  editTitleSuccess,
  editTitleFailure,

  deleteLinkSuccess,
  deleteLinkFailure,

  deleteFolderSuccess,
  deleteFolderFailure,
}

extension CollectionDetailsStatusX on CollectionDetailsStatus {
  bool get isLoadingOrSuccess => [
        CollectionDetailsStatus.loading,
        CollectionDetailsStatus.success,
      ].contains(this);
}

class CollectionDetailsState extends Equatable {
  const CollectionDetailsState({
    this.status = CollectionDetailsStatus.initial,
    this.links = const [],
    this.allLinks = const [],
    this.lastDeletedLink,
    this.collection,
    this.title = "",
    this.filterTitle = "",
    this.editMode = false,
  });

  final CollectionDetailsStatus status;
  final List<Link> links;
  final List<Link> allLinks;
  final Link? lastDeletedLink;
  final Collection? collection;
  final String title;
  final String filterTitle;
  final bool editMode;

  Iterable<Link> get filteredLinks =>
      LinksViewFilter.all.applyAll(links, filterTitle);

  CollectionDetailsState copyWith({
    CollectionDetailsStatus Function()? status,
    List<Link> Function()? links,
    List<Link> Function()? allLinks,
    Link? Function()? lastDeletedLink,
    Collection? collection,
    String? title,
    String? filterTitle,
    bool? editMode,
  }) {
    return CollectionDetailsState(
      status: status != null ? status() : this.status,
      links: links != null ? links() : this.links,
      allLinks: allLinks != null ? allLinks() : this.allLinks,
      lastDeletedLink:
          lastDeletedLink != null ? lastDeletedLink() : this.lastDeletedLink,
      collection: collection ?? this.collection,
      title: title ?? this.title,
      filterTitle: filterTitle ?? this.filterTitle,
      editMode: editMode ?? this.editMode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        links,
        allLinks,
        lastDeletedLink,
        collection,
        title,
        filterTitle,
        editMode
      ];
}
