part of 'settings_bloc.dart';

enum SettingsStatus {
  initial,
  loading,
  success,
  loadFailure,
  switchThemeSuccess,
  switchThemeFailure
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.theme = true,
  });

  final bool theme;
  final SettingsStatus status;

  SettingsState copyWith({
    bool? theme,
    SettingsStatus? status,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [theme, status];
}
