import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:link_saver/links_overview/links_overview.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';

part '../../links_overview/bloc/links_overview_event.dart';
part '../../links_overview/bloc/links_overview_state.dart';

class LinksOverviewBloc extends Bloc<LinksOverviewEvent, LinksOverviewState> {
  LinksOverviewBloc({
    required LinksRepository linksRepository,
  })  : _linksRepository = linksRepository,
        super(const LinksOverviewState()) {
    on<LinksOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<LinksOverviewLinkDeleted>(_onLinkDeleted);
    on<LinksOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<LinksOverviewFilterByTitleChanged>(_onFilterByTitleChanged);
    on<LinksOverviewSortChanged>(_onGetLinksSortOptionChanged);
  }

  final LinksRepository _linksRepository;

  Future<void> _onSubscriptionRequested(
    LinksOverviewSubscriptionRequested event,
    Emitter<LinksOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => LinksOverviewStatus.loading));
    try {
      final links = await _linksRepository.getLinks(LinksViewsSort.byNewest);
      final collections = await _linksRepository.getCollections();
      emit(state.copyWith(
        status: () => LinksOverviewStatus.success,
        links: () => links,
        collections: collections,
      ));
    } catch (e) {
      emit(state.copyWith(status: () => LinksOverviewStatus.failure));
    }
  }

  Future<void> _onGetLinksSortOptionChanged(
    LinksOverviewSortChanged event,
    Emitter<LinksOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => LinksOverviewStatus.loading));
    try {
      final links = await _linksRepository.getLinks(event.sort);
      // final collections = await _linksRepository.getCollections();
      emit(state.copyWith(
        status: () => LinksOverviewStatus.success,
        links: () => links,
        sort: () => event.sort,
        // collections: collections,
      ));
    } catch (e) {
      emit(state.copyWith(status: () => LinksOverviewStatus.failure));
    }
  }

  Future<void> _onLinkDeleted(
    LinksOverviewLinkDeleted event,
    Emitter<LinksOverviewState> emit,
  ) async {
    try {
      emit(state.copyWith(
          lastDeletedLink: () => event.link,
          status: () => LinksOverviewStatus.deleteLoading));
      await _linksRepository.deleteLink(event.link.id);
      emit(state.copyWith(lastDeletedLink: () => event.link));
      emit(state.copyWith(
          lastDeletedLink: () => event.link,
          status: () => LinksOverviewStatus.deleteSuccess));
    } catch (e) {
      emit(state.copyWith(status: () => LinksOverviewStatus.deleteFailure));
    }
  }

  Future<void> _onUndoDeletionRequested(
    LinksOverviewUndoDeletionRequested event,
    Emitter<LinksOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedLink != null,
      'Last deleted link can not be null.',
    );

    final link = state.lastDeletedLink!;
    emit(state.copyWith(lastDeletedLink: () => null));
    // await _linksRepository.saveLink(link, state.ownCollections);
  }

  void _onFilterByTitleChanged(
    LinksOverviewFilterByTitleChanged event,
    Emitter<LinksOverviewState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }
}
