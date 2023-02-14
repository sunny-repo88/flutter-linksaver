import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class EditCollectionBloc
    extends Bloc<EditCollectionEvent, EditCollectionState> {
  EditCollectionBloc({
    required LinksRepository linksRepository,
  })  : _linksRepository = linksRepository,
        super(EditCollectionState()) {
    on<EditCollectionSubmitted>(_onSubmitted);
    on<EditCollectionTitleChanged>(_onTitleChanged);
    on<EditCollectionFilterByTitleChanged>(_onFilterByTitleChanged);
    on<AddLinkstoCollectionSubscriptionRequested>(_onSubscriptionRequested);
    on<AddLinksToCollectionChanged>(_onAddLinksToCollectionRequested);
  }
  final LinksRepository _linksRepository;

  void _onTitleChanged(
      EditCollectionTitleChanged event, Emitter<EditCollectionState> emit) {
    emit(state.copyWith(title: event.title));
  }

  Future<void> _onSubmitted(
    EditCollectionSubmitted event,
    Emitter<EditCollectionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditCollectionStatus.saveLoading));
      List<Link> collectionLinks = [];
      for (CollectionLink link in state.allLinks) {
        if (link.isChecked) {
          Link collectionLink =
              Link(id: link.id, title: link.title, link: link.link);
          collectionLinks.add(collectionLink);
        }
      }
      final collection = Collection(name: '')
          .copyWith(name: state.title, links: collectionLinks);

      await _linksRepository.saveCollection(collection);
      emit(state.copyWith(
        status: EditCollectionStatus.saveSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(status: EditCollectionStatus.failure));
    }
  }

  Future<void> _onSubscriptionRequested(
    AddLinkstoCollectionSubscriptionRequested event,
    Emitter<EditCollectionState> emit,
  ) async {
    try {
      List<Link> links =
          await _linksRepository.getLinks(LinksViewsSort.byNewest);
      List<CollectionLink> aa = [];
      for (Link link in links) {
        CollectionLink a = new CollectionLink(
          id: link.id,
          title: link.title,
          link: link.link,
          isChecked: false,
          filterTitle: '',
        );
        aa.add(a);
      }
      emit(state.copyWith(
        allLinks: aa,
      ));
    } catch (e) {
      emit(state.copyWith(status: EditCollectionStatus.loadingLinkFailure));
    }
  }

  void _onAddLinksToCollectionRequested(
    AddLinksToCollectionChanged event,
    Emitter<EditCollectionState> emit,
  ) {
    emit(state.copyWith(status: EditCollectionStatus.addingLinks));

    try {
      List<CollectionLink> list1 = List.from(state.allLinks);
      CollectionLink item =
          list1.where((link) => link.id == event.link.id).first;
      item.isChecked = event.isChecked;

      List<Link> collectionLinks = [];
      for (CollectionLink link in state.allLinks) {
        if (link.isChecked) {
          Link collectionLink =
              Link(id: link.id, title: link.title, link: link.link);
          collectionLinks.add(collectionLink);
        }
      }

      emit(state.copyWith(
          allLinks: list1,
          addLinks: collectionLinks,
          status: EditCollectionStatus.allLinks));
    } catch (e) {
      emit(state.copyWith(status: EditCollectionStatus.failure));
    }
  }

  void _onFilterByTitleChanged(
    EditCollectionFilterByTitleChanged event,
    Emitter<EditCollectionState> emit,
  ) {
    emit(state.copyWith(filterTitle: event.filterTitle));
  }
}
