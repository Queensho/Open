import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart' as app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tlwjymvhotnruumoyrit.supabase.co',
    anonKey: 'sb_publishable_XjKr2o2fUIEz9mxaIPHHSg_0wKSDhjk',
  );

  runApp(const app.OpenApp());
}
