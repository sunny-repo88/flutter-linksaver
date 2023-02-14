part of 'collection_bloc.dart';

abstract class EditCollectionEvent {
  const EditCollectionEvent();

  @override
  List<Object> get props => [];
}

class EditCollectionSubmitted extends EditCollectionEvent {
  const EditCollectionSubmitted();

  @override
  List<Object> get props => [];
}

class EditCollectionTitleChanged extends EditCollectionEvent {
  const EditCollectionTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class AddLinkstoCollectionSubscriptionRequested extends EditCollectionEvent {
  const AddLinkstoCollectionSubscriptionRequested();
}

class AddLinksToCollectionChanged extends EditCollectionEvent {
  const AddLinksToCollectionChanged(this.link, this.isChecked);

  final CollectionLink link;
  final bool isChecked;

  @override
  List<Object> get props => [link, isChecked];
}

class EditCollectionFilterByTitleChanged extends EditCollectionEvent {
  const EditCollectionFilterByTitleChanged(this.filterTitle);

  final String filterTitle;

  @override
  List<Object> get props => [filterTitle];
}
