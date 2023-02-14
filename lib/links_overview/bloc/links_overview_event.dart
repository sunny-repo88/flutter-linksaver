part of 'links_overview_bloc.dart';

abstract class LinksOverviewEvent extends Equatable {
  const LinksOverviewEvent();

  @override
  List<Object> get props => [];
}

class LinksOverviewSubscriptionRequested extends LinksOverviewEvent {
  const LinksOverviewSubscriptionRequested();
}

class LinksOverviewLinkCompletionToggled extends LinksOverviewEvent {
  const LinksOverviewLinkCompletionToggled({
    required this.link,
    required this.isCompleted,
  });

  final Link link;
  final bool isCompleted;

  @override
  List<Object> get props => [link, isCompleted];
}

class LinksOverviewLinkDeleted extends LinksOverviewEvent {
  const LinksOverviewLinkDeleted(this.link);

  final Link link;

  @override
  List<Object> get props => [link];
}

class LinksOverviewUndoDeletionRequested extends LinksOverviewEvent {
  const LinksOverviewUndoDeletionRequested();
}

class LinksOverviewFilterChanged extends LinksOverviewEvent {
  const LinksOverviewFilterChanged(this.filter);

  final LinksViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class LinksOverviewFilterByTitleChanged extends LinksOverviewEvent {
  const LinksOverviewFilterByTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class LinksOverviewSortChanged extends LinksOverviewEvent {
  const LinksOverviewSortChanged(this.sort);

  final LinksViewsSort sort;

  @override
  List<Object> get props => [sort];
}

class LinksOverviewToggleAllRequested extends LinksOverviewEvent {
  const LinksOverviewToggleAllRequested();
}

class LinksOverviewClearCompletedRequested extends LinksOverviewEvent {
  const LinksOverviewClearCompletedRequested();
}
