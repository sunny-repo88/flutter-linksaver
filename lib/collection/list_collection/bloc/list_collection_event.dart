part of 'list_collection_bloc.dart';

abstract class ListCollectionEvent {
  const ListCollectionEvent();

  @override
  List<Object> get props => [];
}

class CollectionsOverviewSubscriptionRequested extends ListCollectionEvent {
  const CollectionsOverviewSubscriptionRequested();
}

class ListCollectionSubmitted extends ListCollectionEvent {
  const ListCollectionSubmitted();

  @override
  List<Object> get props => [];
}
