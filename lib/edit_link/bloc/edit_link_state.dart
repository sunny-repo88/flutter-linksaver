part of 'edit_link_bloc.dart';

enum EditLinkStatus {
  initial,
  loading,
  success,
  loadFailure,
  editLinkfailure,

  addNewFolderFailure,
  addNewFolderSuccess,

  addNewLinkSuccess,
  editLinkSuccess,
}

extension EditLinkStatusX on EditLinkStatus {
  bool get isLoadingOrSuccess => [
        EditLinkStatus.loading,
        EditLinkStatus.success,
      ].contains(this);
}

class EditLinkState extends Equatable {
  const EditLinkState({
    this.status = EditLinkStatus.initial,
    this.initialLink,
    this.title = '',
    this.link = '',
    this.isPrivate = 0,
    this.collections = const [],
    this.ownCollections = const [],
    this.collectionName = "",
  });

  final EditLinkStatus status;
  final Link? initialLink;
  final String title;
  final String link;
  final int isPrivate;
  final List<Collection> collections;
  final List<int> ownCollections;
  final String collectionName;

  bool get isNewLink => initialLink == null;

  EditLinkState copyWith({
    EditLinkStatus? status,
    Link? initialLink,
    String? title,
    String? link,
    int? isPrivate,
    List<Collection>? collections,
    List<int>? ownCollections,
    String? collectionName,
  }) {
    return EditLinkState(
      status: status ?? this.status,
      initialLink: initialLink ?? this.initialLink,
      title: title ?? this.title,
      link: link ?? this.link,
      isPrivate: isPrivate ?? this.isPrivate,
      collections: collections ?? this.collections,
      ownCollections: ownCollections ?? this.ownCollections,
      collectionName: collectionName ?? this.collectionName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialLink,
        title,
        link,
        isPrivate,
        collections,
        ownCollections,
        collectionName
      ];
}
