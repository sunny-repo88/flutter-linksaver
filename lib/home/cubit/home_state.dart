part of 'home_cubit.dart';

enum HomeTab { links, category, settings }

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.links,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
