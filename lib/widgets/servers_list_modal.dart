import 'dart:io';

import 'package:droid_hole/widgets/add_server_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:droid_hole/widgets/servers_list.dart';

import 'package:droid_hole/models/server.dart';
import 'package:droid_hole/providers/servers_provider.dart';

class ServersListModal extends StatefulWidget {
  final double statusBarHeight;

  const ServersListModal({
    Key? key,
    required this.statusBarHeight
  }) : super(key: key);

  @override
  State<ServersListModal> createState() => _ServersListModalState();
}

class _ServersListModalState extends State<ServersListModal> {
  List<int> expandedCards = [];
  List<int> showButtons = [];

  List<ExpandableController> expandableControllerList = [];

  void _expandOrContract(int index) async {
    expandableControllerList[index].expanded = !expandableControllerList[index].expanded;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    
    final serversProvider = Provider.of<ServersProvider>(context);
    for (var i = 0; i < serversProvider.getServersList.length; i++) {
      expandableControllerList.add(ExpandableController());
    }

    void _openAddServerBottomSheet({Server? server}) async {
      await Future.delayed(const Duration(seconds: 0), (() => {
        Navigator.push(context, MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => AddServerFullscreen(server: server)
        ))
      }));
    }

    return Container(
      height: serversProvider.getServersList.length > 4 
        ? height-widget.statusBarHeight
        : height < (Platform.isIOS ? 620 : 600) 
          ? height-widget.statusBarHeight
          : (Platform.isIOS ? 620 : 600) ,
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Icon(
              Icons.storage_rounded,
              size: 26,
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.piHoleServers,
                style: const TextStyle(
                  fontSize: 24
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
              ),
              child:  ServersList(
                context: context,
                controllers: expandableControllerList,
                onChange: _expandOrContract
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: Platform.isIOS ? 20 : 0
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _openAddServerBottomSheet(), 
                        child: Text(AppLocalizations.of(context)!.add),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context), 
                        child: Text(AppLocalizations.of(context)!.close),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )
    );    
  }
}