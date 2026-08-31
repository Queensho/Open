import 'package:flutter/material.dart';
import 'data/open_backend.dart';
import 'main.dart' as ui;
import 'real_social_flow.dart';

class FixedRealKeysScreen extends StatefulWidget {
  const FixedRealKeysScreen({super.key});
  @override
  State<FixedRealKeysScreen> createState() => _FixedRealKeysScreenState();
}

class _FixedRealKeysScreenState extends State<FixedRealKeysScreen> {
  bool outgoing = false;
  late Future<List<Map<String, dynamic>>> future;
  late Future<List<Map<String, dynamic>>> approvals;
  String? busyId;

  @override
  void initState() {
    super.initState();
    future = OpenBackend.instance.incomingKeys();
    approvals = _loadApprovals();
  }

  Future<List<Map<String, dynamic>>> _loadApprovals() async {
    final b = OpenBackend.instance;
    final me = b.userId;
    if (me == null) return [];
    final ms = List<Map<String, dynamic>>.from(await b.client
        .from('matches')
        .select('id,key_request_id,unlock_requested_by,unlock_requested_at')
        .eq('active', true)
        .not('unlock_requested_by', 'is', null));
    final out = <Map<String, dynamic>>[];
    for (final m in ms) {
      final kr = await b.client
          .from('key_requests')
          .select('sender_id,receiver_id')
          .eq('id', m['key_request_id'])
          .single();
      if (kr['receiver_id'] != me || m['unlock_requested_by'] != kr['sender_id']) {
        continue;
      }
      final p = await b.client
          .from('profiles')
          .select('id,display_name,avatar_url')
          .eq('id', kr['sender_id'])
          .maybeSingle();
      final ans = List<Map<String, dynamic>>.from(
          await b.unlockAnswers(m['id'].toString()));
      out.add({
        ...m,
        'profile': p,
        'answers': ans.where((a) => a['user_id'] == kr['sender_id']).toList(),
      });
    }
    return out;
  }

  void reload() {
    final next = outgoing
        ? OpenBackend.instance.outgoingKeys()
        : OpenBackend.instance.incomingKeys();
    if (!mounted) return;
    setState(() {
      future = next;
      approvals = _loadApprovals();
    });
  }

  String status(String s) => s == 'accepted'
      ? 'İlk kilit açıldı'
      : s == 'rejected'
          ? 'Reddedildi'
          : 'Bekliyor';

  Future<void> accept(Map<String, dynamic> item) async {
    final id = item['id'].toString();
    if (busyId != null) return;
    setState(() => busyId = id);
    try {
      final senderId = item['sender_id'].toString();
      final p = await OpenBackend.instance.client
          .from('profiles')
          .select('id,display_name,avatar_url,city,birth_date,bio,interests')
          .eq('id', senderId)
          .maybeSingle();
      final match = await OpenBackend.instance.acceptKey(id);
      if (!mounted) return;
      await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => RealMatchScreen(
          matchId: match,
          otherProfile: p == null
              ? <String, dynamic>{}
              : Map<String, dynamic>.from(p),
        ),
      ));
      if (mounted) reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Kabul edilemedi: $e')));
      }
    } finally {
      if (mounted) setState(() => busyId = null);
    }
  }

  Future<void> reject(String id) async {
    setState(() => busyId = id);
    try {
      await OpenBackend.instance.rejectKey(id);
      if (mounted) reload();
    } finally {
      if (mounted) setState(() => busyId = null);
    }
  }

  Future<void> respond(String matchId, bool yes) async {
    if (busyId != null) return;
    setState(() => busyId = matchId);
    try {
      await OpenBackend.instance.client.rpc('respond_unlock_request', params: {
        'p_match_id': matchId,
        'p_accept': yes,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(yes
              ? '🔓 Sohbet ikiniz için sınırsız açıldı.'
              : 'İstek reddedildi.'),
        ));
        reload();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => busyId = null);
    }
  }

  int? age(dynamic v) {
    final d = DateTime.tryParse(v?.toString() ?? '');
    if (d == null) return null;
    final n = DateTime.now();
    var a = n.year - d.year;
    if (n.month < d.month || (n.month == d.month && n.day < d.day)) a--;
    return a;
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Expanded(
                    child: ui.PageTitle('Anahtarlar', 'Profili ve cevapları incele.')),
                IconButton(onPressed: reload, icon: const Icon(Icons.refresh_rounded)),
              ]),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ui.OpenApp.soft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(children: [
                  _tab('Gelen', !outgoing),
                  _tab('Gönderilen', outgoing),
                ]),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: future,
                  builder: (c, s) {
                    if (s.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (s.hasError) return Center(child: Text('${s.error}'));
                    final items = s.data ?? [];
                    return ListView(children: [
                      if (!outgoing)
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: approvals,
                          builder: (c, a) {
                            final list = a.data ?? [];
                            return Column(
                                children: [for (final x in list) _approvalCard(x)]);
                          },
                        ),
                      if (items.isEmpty && outgoing)
                        const Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Center(
                            child: Text('Henüz anahtar göndermedin.',
                                style: TextStyle(color: ui.OpenApp.muted)),
                          ),
                        ),
                      if (items.isEmpty && !outgoing)
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: approvals,
                          builder: (c, a) => (a.data ?? []).isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 80),
                                  child: Center(
                                    child: Text('Henüz gelen anahtar yok.',
                                        style: TextStyle(color: ui.OpenApp.muted)),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      for (final x in items) _keyCard(x),
                    ]);
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _approvalCard(Map<String, dynamic> x) {
    final p = x['profile'] is Map
        ? Map<String, dynamic>.from(x['profile'])
        : <String, dynamic>{};
    final answers = List<Map<String, dynamic>>.from(x['answers'] ?? []);
    final id = x['id'].toString();
    final avatar = (p['avatar_url'] ?? '').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ui.OpenApp.lime.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: ui.OpenApp.lime, width: 2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text((p['display_name'] ?? 'Open kullanıcısı').toString(),
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const Text('Son 2 anahtarı gönderdi 🔑🔑',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        for (final a in answers)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                ((a['profile_questions'] as Map?)?['question'] ?? 'Soru').toString(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text('“${a['answer'] ?? ''}”'),
            ]),
          ),
        const SizedBox(height: 5),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: busyId == id ? null : () => respond(id, false),
              child: const Text('Reddet'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              onPressed: busyId == id ? null : () => respond(id, true),
              child: const Text('Kilidi Aç 🔓'),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _keyCard(Map<String, dynamic> x) {
    final p = x['profiles'] is Map
        ? Map<String, dynamic>.from(x['profiles'])
        : <String, dynamic>{};
    final q = x['profile_questions'] is Map
        ? Map<String, dynamic>.from(x['profile_questions'])
        : <String, dynamic>{};
    final st = (x['status'] ?? 'pending').toString();
    final pending = st == 'pending';
    final id = x['id'].toString();
    final avatar = p['avatar_url']?.toString();
    final a = age(p['birth_date']);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
          color: ui.OpenApp.soft, borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 210,
          width: double.infinity,
          color: Colors.white,
          child: avatar != null && avatar.isNotEmpty
              ? Image.network(avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.person_rounded, size: 72)))
              : const Center(child: Icon(Icons.person_rounded, size: 72)),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  '${(p['display_name'] ?? 'Open kullanıcısı')}${a == null ? '' : ', $a'}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
              Text(status(st),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text((q['question'] ?? 'Kilit sorusu').toString(),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text('“${(x['answer'] ?? '').toString()}”',
                    style: const TextStyle(fontSize: 16)),
              ]),
            ),
            if (!outgoing && pending) ...[
              const SizedBox(height: 15),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: busyId == id ? null : () => reject(id),
                    child: const Text('Reddet'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: busyId == id ? null : () => accept(x),
                    child: const Text('İlk kilidi aç 🔑'),
                  ),
                ),
              ]),
            ],
          ]),
        ),
      ]),
    );
  }

  Widget _tab(String text, bool active) => Expanded(
        child: InkWell(
          onTap: () {
            if (active) return;
            outgoing = !outgoing;
            reload();
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: active ? ui.OpenApp.ink : ui.OpenApp.muted)),
          ),
        ),
      );
}
