import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';

part 'edit_link_event.dart';
part 'edit_link_state.dart';

class EditLinkBloc extends Bloc<EditLinkEvent, EditLinkState> {
  EditLinkBloc({
    required LinksRepository linksRepository,
    required Link? initialLink,
  })  : _linksRepository = linksRepository,
        super(
          EditLinkState(
            initialLink: initialLink,
            title: initialLink?.title ?? '',
            link: initialLink?.link ?? '',
            isPrivate: initialLink?.isPrivate ?? 0,
          ),
        ) {
    on<EditLinkSubscriptionRequested>(_onSubscriptionRequested);
    on<EditLinkTitleChanged>(_onTitleChanged);
    on<EditLinkLinkChanged>(_onLinkChanged);
    on<EditLinkIsPrivateChanged>(_onPrivateChanged);
    on<EditLinkIsCollectionsChanged>(_onCollectionsChanged);
    on<EditLinkCollectionNameChanged>(_onCollectionNameChanged);
    on<EditLinkSubmitted>(_onSubmitted);
    on<EditLinkAddCollection>(_onAddCollection);
  }

  final LinksRepository _linksRepository;

  Future<void> _onSubscriptionRequested(
    EditLinkSubscriptionRequested event,
    Emitter<EditLinkState> emit,
  ) async {
    try {
      List<Collection> ownCollections = await _linksRepository
          .getCollectionsByLinkId(state.initialLink?.id ?? 0);
      List<Collection> collections = await _linksRepository.getCollections();

      emit(
        state.copyWith(
          ownCollections:
              ownCollections.map((e) => int.parse(e.id.toString())).toList(),
          collections: collections,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: EditLinkStatus.loadFailure));
    }
  }

  void _onTitleChanged(
    EditLinkTitleChanged event,
    Emitter<EditLinkState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onLinkChanged(
    EditLinkLinkChanged event,
    Emitter<EditLinkState> emit,
  ) {
    emit(state.copyWith(link: event.link));
  }

  void _onPrivateChanged(
    EditLinkIsPrivateChanged event,
    Emitter<EditLinkState> emit,
  ) {
    emit(state.copyWith(isPrivate: event.isPrivate));
  }

  void _onCollectionsChanged(
    EditLinkIsCollectionsChanged event,
    Emitter<EditLinkState> emit,
  ) {
    emit(state.copyWith(ownCollections: event.ownCollections));
  }

  Future<void> _onSubmitted(
    EditLinkSubmitted event,
    Emitter<EditLinkState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditLinkStatus.loading));
      final link = (state.initialLink ?? Link(title: '')).copyWith(
        title: state.title,
        link: state.link,
        isPrivate: state.isPrivate,
      );

      await _linksRepository.saveLink(link, state.ownCollections);
      if (state.initialLink == null) {
        emit(state.copyWith(status: EditLinkStatus.addNewLinkSuccess));
      } else {
        emit(state.copyWith(status: EditLinkStatus.editLinkSuccess));
      }
    } catch (e) {
      emit(state.copyWith(status: EditLinkStatus.editLinkfailure));
    }
  }

  Future<void> _onAddCollection(
    EditLinkAddCollection event,
    Emitter<EditLinkState> emit,
  ) async {
    emit(
      state.copyWith(status: EditLinkStatus.loading),
    );
    final collection =
        Collection(name: '').copyWith(name: state.collectionName, links: []);

    try {
      int newCollectionId = await _linksRepository.saveCollection(collection);
      List<Collection> collections = await _linksRepository.getCollections();

      state.ownCollections.add(newCollectionId);

      emit(state.copyWith(
          collections: collections,
          ownCollections: state.ownCollections,
          status: EditLinkStatus.addNewFolderSuccess));
    } catch (e) {
      emit(state.copyWith(status: EditLinkStatus.addNewFolderFailure));
    }
    emit(state.copyWith(status: EditLinkStatus.initial));
  }

  void _onCollectionNameChanged(
    EditLinkCollectionNameChanged event,
    Emitter<EditLinkState> emit,
  ) {
    emit(state.copyWith(collectionName: event.collectionName));
  }
}
