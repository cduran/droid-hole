// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:droid_hole/providers/app_config_provider.dart';

class RemovePasscodeModal extends StatelessWidget {
  const RemovePasscodeModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    void _removePasscode() async {
      final deleted = await appConfigProvider.setPassCode(null);
      if (deleted == true) {
        Navigator.pop(context);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.connectionCannotBeRemoved),
            backgroundColor: Colors.red,
          )
        );
      }
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      title: Column(
        children: [
          const Icon(
            Icons.delete,
            size: 26,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              AppLocalizations.of(context)!.removePasscode,
              style: const TextStyle(
                fontSize: 24
              ),
            ),
          ),
        ],
      ),
      content:Text(
        AppLocalizations.of(context)!.areSureRemovePasscode
      ),
      actions: [
        TextButton(
          onPressed: () => {
            Navigator.pop(context)
          }, 
          child: Text(AppLocalizations.of(context)!.cancel)
        ),
        TextButton(
          onPressed: _removePasscode,
          child: Text(AppLocalizations.of(context)!.remove),
        ),
      ],
    );
  }
}