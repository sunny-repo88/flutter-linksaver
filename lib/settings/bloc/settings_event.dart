part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsPageSubscriptionRequested extends SettingsEvent {
  const SettingsPageSubscriptionRequested();
}

class SettingsPageThemeSubmitted extends SettingsEvent {
  const SettingsPageThemeSubmitted(this.theme);

  final bool theme;

  @override
  List<Object> get props => [theme];
}
