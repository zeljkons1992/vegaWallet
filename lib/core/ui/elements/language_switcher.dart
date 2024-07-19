import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../features/localization/presentation/bloc/locale_bloc.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      color: Theme.of(context).colorScheme.surface,
      icon: SvgPicture.asset(
        _getFlagIcon(Localizations.localeOf(context)),
        fit: BoxFit.cover,
        width: 24,
        height: 24,
      ),
      onSelected: (Locale locale) {
        context.read<LocaleBloc>().add(LocaleChanged(locale));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/img/flag_of_uk.svg',
                fit: BoxFit.cover,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('sr'),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/img/flag_of_serbia.svg',
                fit: BoxFit.cover,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              const Text('Srpski'),
            ],
          ),
        ),
      ],
    );
  }

  String _getFlagIcon(Locale locale) {
    switch (locale.languageCode) {
      case 'sr':
        return 'assets/img/flag_of_serbia.svg';
      case 'en':
      default:
        return 'assets/img/flag_of_uk.svg';
    }
  }
}
