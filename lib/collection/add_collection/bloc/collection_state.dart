part of 'collection_bloc.dart';

enum EditCollectionStatus {
  initial,
  saveLoading,
  saveSuccess,
  failure,
  loadingLinkFailure,
  addingLinks,
  completeAddingLinks,
  allLinks
}

extension EditCollectionStatusX on EditCollectionStatus {
  bool get isSaveLoadingOrSuccess => [
        EditCollectionStatus.saveLoading,
        EditCollectionStatus.saveSuccess,
      ].contains(this);
}

class EditCollectionState extends Equatable {
  EditCollectionState({
    this.status = EditCollectionStatus.initial,
    this.title = '',
    this.filterTitle = '',
    this.allLinks = const [],
    this.addLinks = const [],
  });

  final EditCollectionStatus status;
  final String title;
  final String filterTitle;

  final List<CollectionLink> allLinks;
  final List<Link> addLinks;

  Iterable<CollectionLink> get filteredCollectionLinks =>
      allLinks.where((x) => x.title.contains(filterTitle));

  EditCollectionState copyWith({
    EditCollectionStatus? status,
    String? title,
    String? filterTitle,
    List<CollectionLink>? allLinks,
    List<Link>? addLinks,
  }) {
    return EditCollectionState(
      status: status ?? this.status,
      title: title ?? this.title,
      filterTitle: filterTitle ?? this.filterTitle,
      allLinks: allLinks ?? this.allLinks,
      addLinks: addLinks ?? this.addLinks,
    );
  }

  @override
  List<Object?> get props => [status, title, filterTitle, allLinks, addLinks];
}

class CollectionLink extends Equatable {
  CollectionLink({
    required this.id,
    required this.title,
    required this.filterTitle,
    required this.link,
    required this.isChecked,
  });

  int id;
  String title;
  String filterTitle;
  String link;
  bool isChecked;

  @override
  List<Object?> get props => [id, title, filterTitle, link, isChecked];
}
