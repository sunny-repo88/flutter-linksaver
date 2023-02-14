import 'package:bloc/bloc.dart';
import 'package:link_saver/links_overview/links_overview.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'collection_details_event.dart';
part 'collection_details_state.dart';

class CollectionDetailsBloc
    extends Bloc<CollectionDetailsEvent, CollectionDetailsState> {
  CollectionDetailsBloc({
    required LinksRepository linksRepository,
    required Collection collection,
  })  : _linksRepository = linksRepository,
        _collection = collection,
        super(const CollectionDetailsState()) {
    on<CollectionDetailsSubscriptionRequested>(_onSubscriptionRequested);
    on<CollectionDetailsLinkDeleted>(_onLinkDeleted);
    on<CollectionDetailsTitleChanged>(_onTitleChanged);
    on<CollectionDetailsFilterByTitleChanged>(_onFilterByTitleChanged);
    on<CollectionDetailsEditModeChanged>(_onEditModeChanged);
    on<CollectionDetailsAddLinksSubmitted>(_onAddLinksSubmitted);
    on<CollectionDetailsTitleSubmitted>(_onTitleSubmitted);

    on<CollectionDetailsDeleteFolderSubmitted>(_onDeleteFolderSubmitted);
    on<CollectionDetailsDeleteLinkFromFolderSubmitted>(
        _onDeleteLinkFromFolderSubmitted);
  }

  final LinksRepository _linksRepository;
  final Collection _collection;

  Future<void> _onSubscriptionRequested(
    CollectionDetailsSubscriptionRequested event,
    Emitter<CollectionDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: () => CollectionDetailsStatus.loading));
      List<Link> links =
          await _linksRepository.getCollectionLinks(_collection.id!);
      List<Link> allLinks =
          await _linksRepository.getLinks(LinksViewsSort.byNewest);
      emit(
        state.copyWith(
          links: () => links,
          allLinks: () => allLinks,
          collection: _collection,
          status: () => CollectionDetailsStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => CollectionDetailsStatus.loadFailure));
    }
  }

  Future<void> _onLinkDeleted(
    CollectionDetailsLinkDeleted event,
    Emitter<CollectionDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(
          lastDeletedLink: () => event.link,
          status: () => CollectionDetailsStatus.loading));
      await _linksRepository.deleteLink(event.link.id);
      emit(state.copyWith(
          status: () => CollectionDetailsStatus.deleteLinkSuccess));
    } catch (e) {
      emit(state.copyWith(
          status: () => CollectionDetailsStatus.deleteLinkFailure));
      emit(state.copyWith(status: () => CollectionDetailsStatus.initial));
    }
  }

  void _onTitleChanged(CollectionDetailsTitleChanged event,
      Emitter<CollectionDetailsState> emit) {
    emit(state.copyWith(status: () => CollectionDetailsStatus.initial));
    emit(state.copyWith(title: event.title));
  }

  Future<void> _onAddLinksSubmitted(
    CollectionDetailsAddLinksSubmitted event,
    Emitter<CollectionDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: () => CollectionDetailsStatus.loading));
      final collection = Collection(name: '').copyWith(
          id: state.collection?.id, name: state.title, links: state.links);
      await _linksRepository.saveCollection(collection);
      emit(state.copyWith(
          collection: collection,
          status: () => CollectionDetailsStatus.editLinkSuccess));
    } catch (e) {
      emit(state.copyWith(
          status: () => CollectionDetailsStatus.editLinkFailure));
      emit(state.copyWith(status: () => CollectionDetailsStatus.initial));
    }
  }

  Future<void> _onTitleSubmitted(
    CollectionDetailsTitleSubmitted event,
    Emitter<CollectionDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: () => CollectionDetailsStatus.loading));
      final collection = Collection(name: '').copyWith(
          id: state.collection?.id, name: state.title, links: state.links);
      await _linksRepository.editCollectionTitle(
        collection.name,
        collection.id ?? 0,
      );
      emit(state.copyWith(
        collection: collection,
        status: () => CollectionDetailsStatus.editTitleSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: () => CollectionDetailsStatus.editTitleFailure));
    }
  }

  Future<void> _onDeleteFolderSubmitted(
    CollectionDetailsDeleteFolderSubmitted event,
    Emitter<CollectionDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: () => CollectionDetailsStatus.loading));
      final collection = Collection(name: '').copyWith(
          id: state.collection?.id, name: state.title, links: state.links);
      await _linksRepository.deleteCollection(collection.id!);
      emit(state.copyWith(
          collection: collection,
          status: () => CollectionDetailsStatus.deleteFolderSuccess));
    } catch (e) {
      emit(state.copyWith(
          status: () => CollectionDetailsStatus.deleteFolderFailure));
      emit(state.copyWith(status: () => CollectionDetailsStatus.initial));
    }
  }

  Future<void> _onDeleteLinkFromFolderSubmitted(
    CollectionDetailsDeleteLinkFromFolderSubmitted event,
    Emitter<CollectionDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: () => CollectionDetailsStatus.loading));

      await _linksRepository.deleteLinkFromCollection(
          event.link.id, state.collection?.id ?? 0);
      emit(state.copyWith(
          status: () => CollectionDetailsStatus.deleteLinkSuccess));
    } catch (e) {
      emit(state.copyWith(
          status: () => CollectionDetailsStatus.deleteLinkFailure));
      emit(state.copyWith(status: () => CollectionDetailsStatus.initial));
    }
  }

  void _onFilterByTitleChanged(
    CollectionDetailsFilterByTitleChanged event,
    Emitter<CollectionDetailsState> emit,
  ) {
    emit(state.copyWith(filterTitle: event.filterTitle));
  }

  void _onEditModeChanged(
    CollectionDetailsEditModeChanged event,
    Emitter<CollectionDetailsState> emit,
  ) {
    emit(state.copyWith(editMode: event.editMode));
  }
}
