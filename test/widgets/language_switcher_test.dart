import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/ui/elements/language_switcher.dart';
import 'package:vegawallet/features/localization/presentation/bloc/locale_bloc.dart';

class MockLocaleBloc extends Mock implements LocaleBloc {}

class FakeLocaleChanged extends Fake implements LocaleChanged {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLocaleChanged());
  });

  testWidgets('LanguageSwitcher changes language when a menu item is selected', (WidgetTester tester) async {
    final mockLocaleBloc = MockLocaleBloc();

    when(() => mockLocaleBloc.stream).thenAnswer((_) => const Stream<LocaleState>.empty());
    when(() => mockLocaleBloc.state).thenReturn(const LocaleState(Locale('en')));
    when(() => mockLocaleBloc.close()).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LocaleBloc>(
          create: (context) => mockLocaleBloc,
          child: Scaffold(
            appBar: AppBar(
              actions: const [
                LanguageSwitcher(),
              ],
            ),
          ),
        ),
      ),
    );

    // Open the PopupMenuButton
    await tester.tap(find.byType(PopupMenuButton<Locale>));
    await tester.pumpAndSettle();

    // Verify the menu items are displayed
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Srpski'), findsOneWidget);

    // Select the English language
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Verify that LocaleChanged event is added with Locale('en')
    verify(() => mockLocaleBloc.add(const LocaleChanged(Locale('en')))).called(1);

    // Open the PopupMenuButton again
    await tester.tap(find.byType(PopupMenuButton<Locale>));
    await tester.pumpAndSettle();

    // Select the Serbian language
    await tester.tap(find.text('Srpski'));
    await tester.pumpAndSettle();

    // Verify that LocaleChanged event is added with Locale('sr'))
    verify(() => mockLocaleBloc.add(const LocaleChanged(Locale('sr')))).called(1);
  });
}
