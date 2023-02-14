part of 'list_collection_bloc.dart';

enum ListCollectionStatus { initial, loading, success, failure }

extension ListCollectionStatusX on ListCollectionStatus {
  bool get isLoadingOrSuccess => [
        ListCollectionStatus.loading,
        ListCollectionStatus.success,
      ].contains(this);
}

class ListCollectionState extends Equatable {
  const ListCollectionState({
    this.status = ListCollectionStatus.initial,
    this.collections = const [],
  });

  final ListCollectionStatus status;
  final List<Collection> collections;

  Iterable<Collection> get filteredCollections => collections;

  ListCollectionState copyWith({
    ListCollectionStatus? status,
    List<Collection> Function()? collections,
  }) {
    return ListCollectionState(
      status: status != null ? status : this.status,
      collections: collections != null ? collections() : this.collections,
    );
  }

  @override
  List<Object?> get props => [
        status,
        collections,
      ];
}
