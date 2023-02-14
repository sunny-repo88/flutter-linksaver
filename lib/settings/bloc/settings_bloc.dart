import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:link_saver/helpers/LocalStorageLinkSaver.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required LocalStorageLinkSaver localStorageLinkSaver,
  })  : _localStorageLinkSaver = localStorageLinkSaver,
        super(const SettingsState()) {
    on<SettingsPageSubscriptionRequested>(_onSubscriptionRequested);
    on<SettingsPageThemeSubmitted>(_onThemeSubmitted);
  }

  final LocalStorageLinkSaver _localStorageLinkSaver;

  Future<void> _onSubscriptionRequested(
    SettingsPageSubscriptionRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.loading));
      bool theme = await _localStorageLinkSaver.getTheme();
      emit(state.copyWith(theme: theme, status: SettingsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.loadFailure));
    }
  }

  Future<void> _onThemeSubmitted(
    SettingsPageThemeSubmitted event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _localStorageLinkSaver.saveTheme(event.theme);
      emit(
        state.copyWith(
            theme: event.theme, status: SettingsStatus.switchThemeSuccess),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SettingsStatus.switchThemeFailure),
      );
    }
  }
}
