import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:initiative/localization/delegate.dart';
import 'package:initiative/model/battle.dart';
import 'package:initiative/model/groups.dart';
import 'package:initiative/model/storage.dart';
import 'package:initiative/screens/battle.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final battle = BattleModel();
  final groups = GroupsModel();

  runApp(
    ScopedModel<BattleModel>(
      model: battle,
      child: ScopedModel<GroupsModel>(
        model: groups,
        child: const InitiativeApp(),
      ),
    ),
  );

  final storage = Storage(await SharedPreferences.getInstance());
  battle.addParticipants(await storage.loadBattle());
  groups.addItems(await storage.loadGroups());

  battle.addListener(() => storage.saveBattle(battle.participants));
  groups.addListener(() => storage.saveGroups(groups.items));
}

class InitiativeApp extends StatelessWidget {
  const InitiativeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationsDelegate.delegate,
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
      title: 'Initiative!',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BattleScreen(),
    );
  }
}
