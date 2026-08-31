import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushNotifications {
  PushNotifications._();
  static final instance = PushNotifications._();

  final _openedController=StreamController<Map<String,dynamic>>.broadcast();
  Stream<Map<String,dynamic>> get opened=>_openedController.stream;
  StreamSubscription<String>? _refreshSubscription;
  StreamSubscription<RemoteMessage>? _tapSubscription;
  bool _started = false;
  Map<String,dynamic>? _pendingData;

  Map<String,dynamic>? takePendingData(){final m=_pendingData;_pendingData=null;return m;}

  Future<void> start({bool askPermission=false}) async {
    if (_started || kIsWeb) return;
    _started = true;
    try {
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;
      if(askPermission){await messaging.requestPermission(alert:true,badge:true,sound:true);}
      await _saveToken(await messaging.getToken());
      _refreshSubscription = messaging.onTokenRefresh.listen(_saveToken);
      _tapSubscription = FirebaseMessaging.onMessageOpenedApp.listen((m)=>_openedController.add(Map<String,dynamic>.from(m.data)));
      final initial=await messaging.getInitialMessage();
      if(initial!=null)_pendingData=Map<String,dynamic>.from(initial.data);
    } catch (_) {
      _started = false;
    }
  }

  Future<void> requestPermission() async {
    if(kIsWeb)return;
    try{
      await Firebase.initializeApp();
      final messaging=FirebaseMessaging.instance;
      await messaging.requestPermission(alert:true,badge:true,sound:true);
      await _saveToken(await messaging.getToken());
    }catch(_){}
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
    await _tapSubscription?.cancel();
    _refreshSubscription = null;
    _tapSubscription = null;
    _started = false;
  }
}
