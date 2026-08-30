import 'package:supabase_flutter/supabase_flutter.dart';

class OpenRepository {
  OpenRepository._();
  static final instance = OpenRepository._();
  SupabaseClient get db => Supabase.instance.client;
  String? get userId => db.auth.currentUser?.id;

  Future<AuthResponse> signUpWithEmail(String email, String password) =>
      db.auth.signUp(email: email.trim(), password: password);

  Future<AuthResponse> signInWithEmail(String email, String password) =>
      db.auth.signInWithPassword(email: email.trim(), password: password);

  Future<void> signOut() => db.auth.signOut();

  Future<void> saveProfile({
    required String name,
    required String city,
    required String gender,
    String bio = '',
    List<String> interests = const [],
  }) async {
    final id = _requireUser();
    await db.from('profiles').upsert({
      'id': id,
      'display_name': name.trim(),
      'city': city.trim(),
      'gender': gender,
      'bio': bio.trim(),
      'interests': interests,
    });
  }

  Future<void> saveQuestions(List<String> questions) async {
    final id = _requireUser();
    if (questions.length != 3) throw ArgumentError('Exactly 3 questions are required.');
    await db.from('profile_questions').delete().eq('profile_id', id);
    await db.from('profile_questions').insert(List.generate(3, (i) => {
      'profile_id': id,
      'question': questions[i],
      'position': i + 1,
    }));
    await db.from('profiles').update({'profile_complete': true}).eq('id', id);
  }

  Future<List<Map<String, dynamic>>> discoverProfiles() async {
    final id = _requireUser();
    final rows = await db
        .from('profiles')
        .select('id,display_name,birth_date,bio,city,avatar_url,interests,is_online,is_verified,profile_questions(id,question,position)')
        .eq('profile_complete', true)
        .neq('id', id)
        .limit(30);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> sendKey({required String receiverId, required String questionId, required String answer}) async {
    final sender = _requireUser();
    final value = answer.trim();
    if (value.isEmpty) throw ArgumentError('Answer cannot be empty.');
    await db.from('key_requests').insert({
      'sender_id': sender,
      'receiver_id': receiverId,
      'question_id': questionId,
      'answer': value,
    });
  }

  Future<List<Map<String, dynamic>>> incomingKeys() async {
    final id = _requireUser();
    final rows = await db.from('key_requests').select('id,sender_id,receiver_id,answer,status,created_at,profiles!key_requests_sender_id_fkey(display_name,avatar_url),profile_questions(question)').eq('receiver_id', id).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<String> acceptKey(String keyRequestId) async {
    final me = _requireUser();
    final key = await db.from('key_requests').select('id,sender_id,receiver_id,status').eq('id', keyRequestId).eq('receiver_id', me).single();
    if (key['status'] != 'pending') throw StateError('Key is no longer pending.');
    await db.from('key_requests').update({'status': 'accepted', 'responded_at': DateTime.now().toUtc().toIso8601String()}).eq('id', keyRequestId).eq('receiver_id', me);
    final inserted = await db.from('matches').insert({'user_a': key['sender_id'], 'user_b': me, 'key_request_id': keyRequestId}).select('id').single();
    return inserted['id'] as String;
  }

  Future<void> rejectKey(String keyRequestId) async {
    final me = _requireUser();
    await db.from('key_requests').update({'status': 'rejected', 'responded_at': DateTime.now().toUtc().toIso8601String()}).eq('id', keyRequestId).eq('receiver_id', me);
  }

  Future<List<Map<String, dynamic>>> matches() async {
    final id = _requireUser();
    final rows = await db.from('matches').select().or('user_a.eq.$id,user_b.eq.$id').eq('active', true).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  Stream<List<Map<String, dynamic>>> messages(String matchId) => db
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('match_id', matchId)
      .order('created_at')
      .map((rows) => List<Map<String, dynamic>>.from(rows));

  Future<void> sendMessage(String matchId, String body) async {
    final sender = _requireUser();
    final value = body.trim();
    if (value.isEmpty) return;
    await db.from('messages').insert({'match_id': matchId, 'sender_id': sender, 'body': value});
  }

  String _requireUser() {
    final id = userId;
    if (id == null) throw StateError('Authentication required.');
    return id;
  }
}
