// ignore_for_file: use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:droid_hole/screens/domains.dart';
import 'package:droid_hole/screens/unlock.dart';
import 'package:droid_hole/screens/connect.dart';
import 'package:droid_hole/screens/home.dart';
import 'package:droid_hole/screens/logs.dart';
import 'package:droid_hole/screens/settings.dart';
import 'package:droid_hole/screens/statistics.dart';

import 'package:droid_hole/widgets/add_domain_modal.dart';
import 'package:droid_hole/widgets/start_warning_modal.dart';
import 'package:droid_hole/widgets/disable_modal.dart';
import 'package:droid_hole/widgets/add_server_fullscreen.dart';
import 'package:droid_hole/widgets/bottom_nav_bar.dart';

import 'package:droid_hole/constants/app_screens.dart';
import 'package:droid_hole/classes/process_modal.dart';
import 'package:droid_hole/services/http_requests.dart';
import 'package:droid_hole/functions/server_management.dart';
import 'package:droid_hole/providers/app_config_provider.dart';
import 'package:droid_hole/providers/domains_list_provider.dart';
import 'package:droid_hole/providers/servers_provider.dart';


class Base extends StatefulWidget {
  final String? passCode;
  final void Function(bool) setAppUnlocked;

  const Base({
    Key? key,
    required this.passCode,
    required this.setAppUnlocked,
  }) : super(key: key); 

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> with WidgetsBindingObserver {
  final List<Widget> pages = [
    const Home(),
    const Statistics(),
    const Logs(),
    const DomainLists(),
    const Settings()
  ];

  final List<Widget> pagesNotSelected = [
    const Connect(),
    const Settings()
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
      if (appConfigProvider.importantInfoReaden == false) {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) => const ImportantInfoModal()
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && widget.passCode != null) {
      widget.setAppUnlocked(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);
    final domainsListProvider = Provider.of<DomainsListProvider>(context, listen: false);

    void _enableDisableServer() async {
      if (
        serversProvider.isServerConnected == true &&
        serversProvider.selectedServer != null
      ) {
        if (serversProvider.selectedServer?.enabled == true) {
          showModalBottomSheet(
            context: context, 
            isScrollControlled: true,
            builder: (_) => DisableModal(
              onDisable: (time) => disableServer(time, context)
            ),
            backgroundColor: Colors.transparent,
            isDismissible: true,
            enableDrag: true,
          );
        }
        else {
          enableServer(context);
        }
      }
    }

    void _addServerModal() async {
      await Future.delayed(const Duration(seconds: 0), (() => {
        Navigator.push(context, MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => const AddServerFullscreen()
        ))
      }));
    }

    void openModalAddDomainToList() {
      showModalBottomSheet(
        context: context, 
        builder: (ctx) => AddDomainModal(
          selectedlist: domainsListProvider.selectedTab == null || domainsListProvider.selectedTab == 0
            ? 'whitelist'
            : 'blacklist',
          addDomain: (value) async {
            final ProcessModal process = ProcessModal(context: context);
            process.open(AppLocalizations.of(context)!.addingDomain);

            final result = await addDomainToList(
              server: serversProvider.selectedServer!, 
              domainData: value
            );

            process.close();

            if (result['result'] == 'success') {
              domainsListProvider.fetchDomainsList(serversProvider.selectedServer!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.domainAdded),
                  backgroundColor: Colors.green,
                )
              );
            }
            else if (result['result'] == 'already_added') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.domainAlreadyAdded),
                  backgroundColor: Colors.orange,
                )
              );
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.cannotAddDomain),
                  backgroundColor: Colors.red,
                )
              );
            } 
          },
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true
      );
    }

    Widget generateFab(int screen) {
      switch (screen) {
        case 0:
          return FloatingActionButton(
            onPressed: _enableDisableServer,
            child: const Icon(Icons.shield_rounded),
          );

        case 3:
          return FloatingActionButton(
            onPressed: openModalAddDomainToList,
            child: const Icon(Icons.add),
          );

        default:
          return const SizedBox();
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.light
          : Brightness.dark,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      ),
      child: Scaffold(
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (
            (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
              animation: primaryAnimation, 
              secondaryAnimation: secondaryAnimation,
              child: child,
            )
          ),
          child: appConfigProvider.appUnlocked == false
            ? const Unlock()
            : serversProvider.selectedServer != null
              ? pages[appConfigProvider.selectedTab]
              : pagesNotSelected[appConfigProvider.selectedTab > 1 ? 0 : appConfigProvider.selectedTab]
        ),
        bottomNavigationBar: appConfigProvider.appUnlocked == false
          ? null
          : BottomNavBar(
              screens: serversProvider.selectedServer != null
                ? appScreens
                : appScreensNotSelected,
              selectedScreen: serversProvider.selectedServer != null
                ? appConfigProvider.selectedTab
                : appConfigProvider.selectedTab > 1 ? 0 : appConfigProvider.selectedTab,
              onChange: (selected) {
                if (selected != 3) {
                  domainsListProvider.setSelectedTab(null);
                }
                appConfigProvider.setSelectedTab(selected);
              },
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: appConfigProvider.appUnlocked == true
          ? serversProvider.selectedServer != null
            ? serversProvider.isServerConnected == true
              ? generateFab(appConfigProvider.selectedTab)
              : null
            : appConfigProvider.selectedTab == 0 && serversProvider.getServersList.isNotEmpty
              ? FloatingActionButton(
                  onPressed: _addServerModal,
                  child: const Icon(Icons.add),
                )
              : null
          : null,
      ),
    );
  }
}