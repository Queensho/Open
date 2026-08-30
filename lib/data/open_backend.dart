import 'package:supabase_flutter/supabase_flutter.dart';

class OpenBackend {
  OpenBackend._();
  static final instance = OpenBackend._();
  final SupabaseClient client = Supabase.instance.client;

  String? get userId => client.auth.currentUser?.id;
  bool get isAuthenticated => userId != null;

  Future<AuthResponse> registerEmail(String email, String password) =>
      client.auth.signUp(email: email.trim(), password: password);

  Future<AuthResponse> loginEmail(String email, String password) =>
      client.auth.signInWithPassword(email: email.trim(), password: password);

  Future<void> saveProfile(String name, String city, String gender) async {
    final id = _uid();
    await client.from('profiles').upsert({
      'id': id,
      'display_name': name.trim(),
      'city': city.trim(),
      'gender': gender,
    });
  }

  Future<void> saveLockQuestions(List<String> questions) async {
    final id = _uid();
    if (questions.length != 3) throw ArgumentError('3 soru seçilmeli');
    await client.from('profile_questions').delete().eq('profile_id', id);
    await client.from('profile_questions').insert([
      for (var i = 0; i < questions.length; i++)
        {'profile_id': id, 'question': questions[i], 'position': i + 1},
    ]);
    await client.from('profiles').update({'profile_complete': true}).eq('id', id);
  }

  Future<List<Map<String, dynamic>>> discover() async {
    final id = _uid();
    final data = await client
        .from('profiles')
        .select('id,display_name,birth_date,bio,city,avatar_url,interests,is_online,is_verified,profile_questions(id,question,position)')
        .eq('profile_complete', true)
        .neq('id', id)
        .limit(30);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> sendKey(String receiverId, String questionId, String answer) async {
    await client.from('key_requests').insert({
      'sender_id': _uid(),
      'receiver_id': receiverId,
      'question_id': questionId,
      'answer': answer.trim(),
    });
  }

  Future<List<Map<String, dynamic>>> incomingKeys() async {
    final data = await client
        .from('key_requests')
        .select('id,sender_id,answer,status,created_at,profiles!key_requests_sender_id_fkey(display_name,avatar_url),profile_questions(question)')
        .eq('receiver_id', _uid())
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> rejectKey(String requestId) async {
    final me = _uid();
    await client.from('key_requests').update({
      'status': 'rejected',
      'responded_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', requestId).eq('receiver_id', me).eq('status', 'pending');
  }

  Future<String> acceptKey(String requestId) async {
    final me = _uid();
    final request = await client
        .from('key_requests')
        .select('sender_id,status')
        .eq('id', requestId)
        .eq('receiver_id', me)
        .single();
    if (request['status'] != 'pending') throw StateError('Anahtar beklemede değil');
    await client.from('key_requests').update({
      'status': 'accepted',
      'responded_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', requestId).eq('receiver_id', me);
    final match = await client.from('matches').insert({
      'user_a': request['sender_id'],
      'user_b': me,
      'key_request_id': requestId,
    }).select('id').single();
    return match['id'] as String;
  }

  Future<List<Map<String, dynamic>>> activeMatches() async {
    final me = _uid();
    final data = await client
        .from('matches')
        .select('id,user_a,user_b,created_at')
        .or('user_a.eq.$me,user_b.eq.$me')
        .eq('active', true)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Stream<List<Map<String, dynamic>>> messageStream(String matchId) => client
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('match_id', matchId)
      .order('created_at')
      .map((rows) => List<Map<String, dynamic>>.from(rows));

  Future<void> sendMessage(String matchId, String text) async {
    final body = text.trim();
    if (body.isEmpty) return;
    await client.from('messages').insert({
      'match_id': matchId,
      'sender_id': _uid(),
      'body': body,
    });
  }

  String _uid() {
    final id = userId;
    if (id == null) throw StateError('Supabase oturumu gerekli');
    return id;
  }
}
