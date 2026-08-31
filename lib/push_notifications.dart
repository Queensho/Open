import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> openFirebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotifications {
  PushNotifications._();
  static final instance = PushNotifications._();

  static const _channel=AndroidNotificationChannel('open_notifications','Open bildirimleri',description:'Anahtar, eşleşme ve mesaj bildirimleri',importance:Importance.high);
  final _local=FlutterLocalNotificationsPlugin();
  final _openedController=StreamController<Map<String,dynamic>>.broadcast();
  Stream<Map<String,dynamic>> get opened=>_openedController.stream;
  StreamSubscription<String>? _refreshSubscription;
  StreamSubscription<RemoteMessage>? _tapSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  bool _started=false;
  Map<String,dynamic>? _pendingData;

  Map<String,dynamic>? takePendingData(){final m=_pendingData;_pendingData=null;return m;}

  Future<void> start({bool askPermission=false}) async {
    if(_started||kIsWeb)return;
    _started=true;
    try{
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(openFirebaseBackgroundHandler);
      const init=InitializationSettings(android:AndroidInitializationSettings('@mipmap/ic_launcher'));
      await _local.initialize(init,onDidReceiveNotificationResponse:(r){final p=r.payload;if(p==null||p.isEmpty)return;try{_openedController.add(Map<String,dynamic>.from(jsonDecode(p) as Map));}catch(_){}});
      await _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);
      final messaging=FirebaseMessaging.instance;
      if(askPermission)await messaging.requestPermission(alert:true,badge:true,sound:true);
      await _saveToken(await messaging.getToken());
      _refreshSubscription=messaging.onTokenRefresh.listen(_saveToken);
      _tapSubscription=FirebaseMessaging.onMessageOpenedApp.listen((m)=>_openedController.add(Map<String,dynamic>.from(m.data)));
      _foregroundSubscription=FirebaseMessaging.onMessage.listen(_showForeground);
      final initial=await messaging.getInitialMessage();
      if(initial!=null)_pendingData=Map<String,dynamic>.from(initial.data);
      final localLaunch=await _local.getNotificationAppLaunchDetails();
      final payload=localLaunch?.notificationResponse?.payload;
      if(payload!=null&&payload.isNotEmpty){try{_pendingData=Map<String,dynamic>.from(jsonDecode(payload) as Map);}catch(_){}}
    }catch(_){_started=false;}
  }

  Future<void> _showForeground(RemoteMessage m)async{
    final n=m.notification;
    final title=n?.title??m.data['title']?.toString()??'Open';
    final body=n?.body??m.data['body']?.toString()??'';
    await _local.show(m.hashCode,title,body,NotificationDetails(android:AndroidNotificationDetails(_channel.id,_channel.name,channelDescription:_channel.description,importance:Importance.high,priority:Priority.high)),payload:jsonEncode(m.data));
  }

  Future<void> requestPermission()async{
    if(kIsWeb)return;
    try{await Firebase.initializeApp();final m=FirebaseMessaging.instance;await m.requestPermission(alert:true,badge:true,sound:true);await _saveToken(await m.getToken());}catch(_){}
  }

  Future<void> _saveToken(String? token)async{
    final user=Supabase.instance.client.auth.currentUser;
    if(user==null||token==null||token.isEmpty)return;
    await Supabase.instance.client.from('push_tokens').upsert({'user_id':user.id,'token':token,'platform':defaultTargetPlatform.name,'enabled':true,'updated_at':DateTime.now().toUtc().toIso8601String()},onConflict:'user_id,token');
  }

  Future<void> disableCurrentUserTokens()async{
    final user=Supabase.instance.client.auth.currentUser;
    if(user==null)return;
    try{await Supabase.instance.client.from('push_tokens').update({'enabled':false,'updated_at':DateTime.now().toUtc().toIso8601String()}).eq('user_id',user.id);}catch(_){}
  }

  Future<void> stop()async{
    await _refreshSubscription?.cancel();await _tapSubscription?.cancel();await _foregroundSubscription?.cancel();
    _refreshSubscription=null;_tapSubscription=null;_foregroundSubscription=null;_started=false;
  }
}
