import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';

import '../../../../../core/constants/assets_const.dart';

class VerificationStart extends StatefulWidget {
  const VerificationStart({super.key});

  @override
  VerificationStartState createState() => VerificationStartState();
}

class VerificationStartState extends State<VerificationStart> {
  Future<void> _startDelay() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(googleVerificationProcess, width: 200),
            FutureBuilder<void>(
              future: _startDelay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Text(
                      localization.googleStartVer,
                      style: AppTextStyles(context).bodyText1,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
