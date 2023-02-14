part of 'edit_link_bloc.dart';

abstract class EditLinkEvent extends Equatable {
  const EditLinkEvent();

  @override
  List<Object> get props => [];
}

class EditLinkTitleChanged extends EditLinkEvent {
  const EditLinkTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class EditLinkLinkChanged extends EditLinkEvent {
  const EditLinkLinkChanged(this.link);

  final String link;

  @override
  List<Object> get props => [link];
}

class EditLinkIsPrivateChanged extends EditLinkEvent {
  const EditLinkIsPrivateChanged(this.isPrivate);

  final int isPrivate;

  @override
  List<Object> get props => [isPrivate];
}

class EditLinkIsCollectionsChanged extends EditLinkEvent {
  const EditLinkIsCollectionsChanged(this.ownCollections);

  final List<int>? ownCollections;

  @override
  List<Object> get props => [ownCollections!];
}

class EditLinkSubmitted extends EditLinkEvent {
  const EditLinkSubmitted();
}

class EditLinkAddCollection extends EditLinkEvent {
  const EditLinkAddCollection();
}

class EditLinkCollectionNameChanged extends EditLinkEvent {
  const EditLinkCollectionNameChanged(this.collectionName);

  final String collectionName;

  @override
  List<Object> get props => [collectionName];
}

class EditLinkSubscriptionRequested extends EditLinkEvent {
  const EditLinkSubscriptionRequested();
}
