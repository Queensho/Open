import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushNotifications {
  PushNotifications._();
  static final instance = PushNotifications._();

  StreamSubscription<String>? _refreshSubscription;
  bool _started = false;

  Future<void> start() async {
    if (_started || kIsWeb) return;
    _started = true;
    try {
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      await _saveToken(await messaging.getToken());
      _refreshSubscription = messaging.onTokenRefresh.listen(_saveToken);
    } catch (_) {
      _started = false;
    }
  }

  Future<void> _saveToken(String? token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || token == null || token.isEmpty) return;
    await Supabase.instance.client.from('push_tokens').upsert({
      'user_id': user.id,
      'token': token,
      'platform': defaultTargetPlatform.name,
      'enabled': true,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id,token');
  }

  Future<void> stop() async {
    await _refreshSubscription?.cancel();
    _refreshSubscription = null;
    _started = false;
  }
}
