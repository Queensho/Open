import 'package:supabase_flutter/supabase_flutter.dart';

class OpenBackend {
  OpenBackend._();
  static final instance = OpenBackend._();
  final SupabaseClient client = Supabase.instance.client;

  String? get userId => client.auth.currentUser?.id;
  bool get isAuthenticated => userId != null;

  Future<AuthResponse> registerEmail(String email, String password) => client.auth.signUp(email: email.trim(), password: password);
  Future<AuthResponse> loginEmail(String email, String password) => client.auth.signInWithPassword(email: email.trim(), password: password);
  Future<void> sendPhoneOtp(String phone) async {}
  String _mockPhoneEmail(String phone) { final digits = phone.replaceAll(RegExp(r'\D'), ''); return 'phone_$digits@mock.open.local'; }
  String _mockPhonePassword(String phone) { final digits = phone.replaceAll(RegExp(r'\D'), ''); return 'OpenMock!$digits#123456'; }
  Future<AuthResponse> verifyPhoneOtp(String phone, String token) async {if(token.trim()!='123456')throw const AuthException('Mock kod hatalı');final email=_mockPhoneEmail(phone),password=_mockPhonePassword(phone);try{return await client.auth.signInWithPassword(email:email,password:password);}on AuthException catch(e){final m=e.message.toLowerCase();if(!m.contains('invalid login credentials')&&!m.contains('invalid credentials'))rethrow;}final response=await client.functions.invoke('mock-phone-auth',body:{'phone':phone.trim(),'token':token.trim()});if(response.status<200||response.status>=300)throw AuthException('Mock telefon hesabı oluşturulamadı: ${response.data}');return client.auth.signInWithPassword(email:email,password:password);}
  Future<AuthResponse> startMockPhoneSession()=>client.auth.signInAnonymously();
  Future<bool> hasCompletedProfile()async{final id=userId;if(id==null)return false;final row=await client.from('profiles').select('profile_complete').eq('id',id).maybeSingle();return row!=null&&row['profile_complete']==true;}
  Future<bool> hasProfile()async{final id=userId;if(id==null)return false;final row=await client.from('profiles').select('id').eq('id',id).maybeSingle();return row!=null;}
  Future<void> signOut()=>client.auth.signOut();
  Future<void> saveProfile(String name,String city,String gender)async{final cleanName=name.trim(),cleanCity=city.trim();if(cleanName.isEmpty||cleanCity.isEmpty)throw ArgumentError('Ad ve konum zorunlu');final id=_uid();await client.from('profiles').upsert({'id':id,'display_name':cleanName,'city':cleanCity,'gender':gender});}
  Future<List<Map<String,dynamic>>> saveLockQuestions(List<String> questions)async{final id=_uid();final clean=questions.map((q)=>q.trim()).toList();if(clean.length!=3||clean.any((q)=>q.isEmpty))throw ArgumentError('3 geçerli soru seçilmeli');final rows=await client.from('profile_questions').upsert([for(var i=0;i<clean.length;i++){'profile_id':id,'question':clean[i],'position':i+1}],onConflict:'profile_id,position').select('id,question,position').order('position');await client.from('profiles').update({'profile_complete':true}).eq('id',id);return List<Map<String,dynamic>>.from(rows);}

  int _age(dynamic birthDate){if(birthDate==null)return -1;final d=DateTime.tryParse(birthDate.toString());if(d==null)return -1;final now=DateTime.now();var age=now.year-d.year;if(now.month<d.month||(now.month==d.month&&now.day<d.day))age--;return age;}
  bool _genderMatches(String pref,dynamic gender){final p=pref.trim().toLowerCase(),g=(gender??'').toString().trim().toLowerCase();if(p.isEmpty||p=='herkes')return true;if(p.startsWith('kad'))return g.startsWith('kad')||g=='female'||g=='woman';if(p.startsWith('erk'))return g.startsWith('erk')||g=='male'||g=='man';return true;}
  Future<List<Map<String,dynamic>>> discover()async{
    final id=_uid();
    final settingRows=await client.from('user_settings').select('looking_for,min_age,max_age,max_distance_km,discover_city').eq('user_id',id).limit(1);
    final s=settingRows.isEmpty?<String,dynamic>{}:Map<String,dynamic>.from(settingRows.first);
    final lookingFor=(s['looking_for']??'Herkes').toString();
    final minAge=(s['min_age'] as num?)?.toInt()??18,maxAge=(s['max_age'] as num?)?.toInt()??80;
    final discoverCity=(s['discover_city']??'').toString().trim().toLowerCase();
    final data=await client.from('profiles').select('id,display_name,birth_date,bio,city,gender,avatar_url,gallery_urls,interests,is_online,is_verified,account_paused,profile_questions(id,question,position)').eq('profile_complete',true).neq('id',id).limit(100);
    final rows=List<Map<String,dynamic>>.from(data);
    return rows.where((p){
      if(p['account_paused']==true)return false;
      if(!_genderMatches(lookingFor,p['gender']))return false;
      final age=_age(p['birth_date']);
      if(age>=0&&(age<minAge||age>maxAge))return false;
      if(discoverCity.isNotEmpty){final city=(p['city']??'').toString().trim().toLowerCase();if(city!=discoverCity)return false;}
      return true;
    }).take(30).toList();
  }

  Future<void> sendKey(String receiverId,String questionId,String answer)async{final cleanAnswer=answer.trim();if(cleanAnswer.isEmpty)throw ArgumentError('Cevap boş olamaz');await client.from('key_requests').insert({'sender_id':_uid(),'receiver_id':receiverId,'question_id':questionId,'answer':cleanAnswer});}
  Future<List<Map<String,dynamic>>> incomingKeys()async{final data=await client.from('key_requests').select('id,sender_id,answer,status,created_at,profiles!key_requests_sender_id_fkey(display_name,avatar_url),profile_questions(question)').eq('receiver_id',_uid()).order('created_at',ascending:false);return List<Map<String,dynamic>>.from(data);}
  Future<void> rejectKey(String requestId)async{final me=_uid();await client.from('key_requests').update({'status':'rejected','responded_at':DateTime.now().toUtc().toIso8601String()}).eq('id',requestId).eq('receiver_id',me).eq('status','pending');}
  Future<String> acceptKey(String requestId)async{final me=_uid();final request=await client.from('key_requests').select('sender_id,status').eq('id',requestId).eq('receiver_id',me).single();final senderId=request['sender_id'].toString();final existing=await client.from('matches').select('id').or('and(user_a.eq.$senderId,user_b.eq.$me),and(user_a.eq.$me,user_b.eq.$senderId)').eq('active',true).maybeSingle();if(request['status']=='pending'){await client.from('key_requests').update({'status':'accepted','responded_at':DateTime.now().toUtc().toIso8601String()}).eq('id',requestId).eq('receiver_id',me).eq('status','pending');}else if(request['status']!='accepted'){throw StateError('Anahtar kabul edilebilir durumda değil');}if(existing!=null)return existing['id'] as String;try{final match=await client.from('matches').insert({'user_a':senderId,'user_b':me,'key_request_id':requestId}).select('id').single();return match['id'] as String;}on PostgrestException catch(e){if(e.code!='23505')rethrow;final match=await client.from('matches').select('id').or('and(user_a.eq.$senderId,user_b.eq.$me),and(user_a.eq.$me,user_b.eq.$senderId)').eq('active',true).single();return match['id'] as String;}}
  Future<List<Map<String,dynamic>>> activeMatches()async{final me=_uid();final data=await client.from('matches').select('id,user_a,user_b,created_at').or('user_a.eq.$me,user_b.eq.$me').eq('active',true).order('created_at',ascending:false);return List<Map<String,dynamic>>.from(data);}
  Stream<List<Map<String,dynamic>>> messageStream(String matchId)=>client.from('messages').stream(primaryKey:['id']).eq('match_id',matchId).order('created_at').map((rows)=>List<Map<String,dynamic>>.from(rows));
  Future<void> sendMessage(String matchId,String text)async{final body=text.trim();if(body.isEmpty)throw ArgumentError('Mesaj boş olamaz');await client.from('messages').insert({'match_id':matchId,'sender_id':_uid(),'body':body});}
  String _uid(){final id=userId;if(id==null)throw StateError('Supabase oturumu gerekli');return id;}
}
