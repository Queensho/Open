import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/open_backend.dart';
import 'direct_app.dart';
import 'main.dart' as ui;
import 'real_app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tlwjymvhotnruumoyrit.supabase.co',
    publishableKey: 'sb_publishable_XjKr2o2fUIEz9mxaIPHHSg_0wKSDhjk',
  );

  final backend = OpenBackend.instance;
  if (backend.isAuthenticated && await backend.hasCompletedProfile()) {
    runApp(const _ReturningUserApp());
  } else {
    runApp(const DirectOpenApp());
  }
}

class _ReturningUserApp extends StatelessWidget {
  const _ReturningUserApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Open',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: ui.OpenApp.lime),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: ui.OpenApp.soft,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: ui.OpenApp.lime, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: ui.OpenApp.lime,
              foregroundColor: ui.OpenApp.ink,
              minimumSize: const Size.fromHeight(58),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        home: const RealAppShell(),
      );
}
