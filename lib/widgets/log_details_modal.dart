import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:droid_hole/widgets/log_status.dart';

import 'package:droid_hole/models/log.dart';
import 'package:droid_hole/functions/format.dart';

class LogDetailsModal extends StatelessWidget {
  final Log log;
  final double statusBarHeight;
  final void Function(String, Log) whiteBlackList;

  const LogDetailsModal({
    Key? key,
    required this.log,
    required this.statusBarHeight,
    required this.whiteBlackList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget _item(IconData icon, String label, Widget value) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: mediaQuery.size.width - 114,
                  child: value,
                )
              ],
            )
          ],
        ),
      );  
    }

    Widget _blackWhiteListButton() {
      if (
        log.status == '2' ||
        log.status == '3' ||
        log.status == '12' ||
        log.status == '13' ||
        log.status == '14'
      ) {
        return TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            whiteBlackList('black', log);
          }, 
          icon: const Icon(Icons.block_rounded), 
          label: Text(AppLocalizations.of(context)!.blacklist),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.red),
            overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.1))
          ),
        );
      }
      else {
        return TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            whiteBlackList('white', log);
          },
          icon: const Icon(Icons.check), 
          label: Text(AppLocalizations.of(context)!.whitelist),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.green),
            overlayColor: MaterialStateProperty.all(Colors.green.withOpacity(0.1))
          ),
        );
      }
    }

    return Container(
      height: log.status == '2' && log.answeredBy != null
        ? (mediaQuery.size.height-statusBarHeight) > 666
          ? 666
          : mediaQuery.size.height - (statusBarHeight+15)
        : (mediaQuery.size.height-statusBarHeight) > 610
          ? 596
          : mediaQuery.size.height - (statusBarHeight+15),
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: Platform.isIOS ? 30 : 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).dialogBackgroundColor,
      ),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                AppLocalizations.of(context)!.logDetails,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: log.status == '2' && log.answeredBy != null
              ? (mediaQuery.size.height-statusBarHeight) > 666
                ? 535
                : mediaQuery.size.height - (statusBarHeight+146)
              : (mediaQuery.size.height-statusBarHeight) > 610
                ? 465
                : mediaQuery.size.height - (statusBarHeight+146),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _item(Icons.link, AppLocalizations.of(context)!.url, Text(
                    log.url,
                    overflow: TextOverflow.ellipsis,
                  )),
                  const SizedBox(height: 20),
                  _item(Icons.http_rounded, AppLocalizations.of(context)!.type, Text(log.type)),
                  const SizedBox(height: 20),
                  _item(Icons.phone_android_rounded, AppLocalizations.of(context)!.device, Text(
                    log.device,
                    overflow: TextOverflow.ellipsis,
                  )),
                  const SizedBox(height: 20),
                  _item(Icons.access_time_outlined, AppLocalizations.of(context)!.time, Text(formatTimestamp(log.dateTime, 'HH:mm:ss'))),
                  const SizedBox(height: 20),
                  _item(Icons.shield_outlined, AppLocalizations.of(context)!.status, LogStatus(status: log.status, showIcon: false)),
                  const SizedBox(height: 20),
                  if (log.status == '2' && log.answeredBy != null) ...[
                    _item(Icons.domain, AppLocalizations.of(context)!.answeredBy, Text(
                      log.answeredBy!,
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(height: 20),
                  ],
                  _item(Icons.system_update_alt_outlined, AppLocalizations.of(context)!.reply, Text("${log.replyType} (${(log.replyTime/10)} ms)")),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _blackWhiteListButton(),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.close),
                  label: Text(AppLocalizations.of(context)!.close),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}