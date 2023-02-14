import 'package:bloc/bloc.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'list_collection_event.dart';
part 'list_collection_state.dart';

class ListCollectionBloc
    extends Bloc<ListCollectionEvent, ListCollectionState> {
  ListCollectionBloc({
    required LinksRepository linksRepository,
  })  : _linksRepository = linksRepository,
        super(const ListCollectionState()) {
    on<CollectionsOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<ListCollectionSubmitted>(_onSubmitted);
  }

  final LinksRepository _linksRepository;

  Future<void> _onSubscriptionRequested(
    CollectionsOverviewSubscriptionRequested event,
    Emitter<ListCollectionState> emit,
  ) async {
    emit(state.copyWith(status: ListCollectionStatus.loading));
    List<Collection> collections = await _linksRepository.getCollections();
    emit(state.copyWith(
      status: ListCollectionStatus.success,
      collections: () => collections,
    ));
  }

  Future<void> _onSubmitted(
    ListCollectionEvent event,
    Emitter<ListCollectionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ListCollectionStatus.loading));
      List<Collection> collections = await _linksRepository.getCollections();
      collections = await _linksRepository.getCollections();
      emit(state.copyWith(
        status: ListCollectionStatus.success,
        collections: () => collections,
      ));
    } catch (e) {
      emit(state.copyWith(status: ListCollectionStatus.failure));
    }
  }
}
