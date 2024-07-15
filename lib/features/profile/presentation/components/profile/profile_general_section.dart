import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Widget profileGeneralSection(UserProfileInformation user,BuildContext context) {
  final localization = AppLocalizations.of(context)!;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12,),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(16),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localization.general ,style: AppTextStyles(context).headline4,),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:12),
            child: Row(
              children: [
                const Icon(Icons.account_circle_outlined),
                const SizedBox(width: 8,),
                Text(user.nameAndSurname,style: AppTextStyles(context).headline3,),
              ],
            ),
          ),
          const Divider(
            color: Colors.black12,
            height: 3,
          ),
           Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.mail_outline_rounded),
                const SizedBox(width: 8,),
                Text(user.email,style: AppTextStyles(context).headline3),
              ],
            ),
          ),
          const Divider(
            color: Colors.black12,
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.phone_android_outlined),
                const SizedBox(width: 8,),
                Text(
                  user.phoneNumber ?? localization.noNumber,
                  style: AppTextStyles(context).headline3,
                )
          ],
            ),
          ),
          const Divider(
            color: Colors.black12,
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.messenger_outline),
                const SizedBox(width: 8,),
                Text(localization.feedback,style: AppTextStyles(context).headline3,),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
