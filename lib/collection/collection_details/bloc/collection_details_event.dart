part of 'collection_details_bloc.dart';

@immutable
abstract class CollectionDetailsEvent {
  const CollectionDetailsEvent();

  @override
  List<Object> get props => [];
}

class CollectionDetailsSubscriptionRequested extends CollectionDetailsEvent {
  const CollectionDetailsSubscriptionRequested();
}

class CollectionDetailsLinkDeleted extends CollectionDetailsEvent {
  const CollectionDetailsLinkDeleted(this.link);

  final Link link;

  @override
  List<Object> get props => [link];
}

class CollectionDetailsUndoDeletionRequested extends CollectionDetailsEvent {
  const CollectionDetailsUndoDeletionRequested();
}

class CollectionDetailsTitleChanged extends CollectionDetailsEvent {
  const CollectionDetailsTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class CollectionDetailsAddLinksSubmitted extends CollectionDetailsEvent {
  const CollectionDetailsAddLinksSubmitted();

  @override
  List<Object> get props => [];
}

class CollectionDetailsTitleSubmitted extends CollectionDetailsEvent {
  const CollectionDetailsTitleSubmitted();

  @override
  List<Object> get props => [];
}

class CollectionDetailsDeleteFolderSubmitted extends CollectionDetailsEvent {
  const CollectionDetailsDeleteFolderSubmitted();

  @override
  List<Object> get props => [];
}

class CollectionDetailsDeleteLinkFromFolderSubmitted
    extends CollectionDetailsEvent {
  const CollectionDetailsDeleteLinkFromFolderSubmitted(this.link);

  final Link link;

  @override
  List<Object> get props => [link];
}

class CollectionDetailsFilterByTitleChanged extends CollectionDetailsEvent {
  const CollectionDetailsFilterByTitleChanged(this.filterTitle);

  final String filterTitle;

  @override
  List<Object> get props => [filterTitle];
}

class CollectionDetailsEditModeChanged extends CollectionDetailsEvent {
  const CollectionDetailsEditModeChanged(this.editMode);

  final bool editMode;

  @override
  List<Object> get props => [editMode];
}
