import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<LocaleChanged>(_onLocaleChanged);
  }

  FutureOr<void> _onLocaleChanged(LocaleChanged event, Emitter<LocaleState> emit) {
    emit(LocaleState(event.locale));
  }
}