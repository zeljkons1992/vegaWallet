import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_event.dart';
part 'locale_state.dart';

@Injectable()
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<GetInitialLocale>(_onGetInitialLocale);
    on<LocaleChanged>(_onLocaleChanged);
  }

  Future<FutureOr<void>> _onLocaleChanged(LocaleChanged event, Emitter<LocaleState> emit) async {
    emit(LocaleState(event.locale));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', event.locale.languageCode);
  }

  Future<FutureOr<void>> _onGetInitialLocale(GetInitialLocale event, Emitter<LocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString('locale') ?? 'en';
    final locale = Locale(localeString);
    await prefs.setString('locale', localeString);
    emit(LocaleState(locale));
  }
}