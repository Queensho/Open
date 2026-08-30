import 'package:flutter/material.dart';

import 'data/open_backend.dart';
import 'main.dart' as ui;

class RealProfileScreen extends StatefulWidget {
  const RealProfileScreen({super.key, this.onSignedOut});

  final VoidCallback? onSignedOut;

  @override
  State<RealProfileScreen> createState() => _RealProfileScreenState();
}

class _RealProfileScreenState extends State<RealProfileScreen> {
  bool busy = false;
  bool loading = true;
  Map<String, dynamic> profile = const {};
  List<Map<String, dynamic>> questions = const [];
  int matchCount = 0;
  int keyCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = OpenBackend.instance.userId;
    if (id == null) return;
    setState(() => loading = true);
    try {
      final p = await OpenBackend.instance.client
          .from('profiles')
          .select('id,display_name,birth_date,bio,city,avatar_url,is_online,is_verified')
          .eq('id', id)
          .maybeSingle();
      final q = await OpenBackend.instance.client
          .from('profile_questions')
          .select('id,question,position')
          .eq('profile_id', id)
          .order('position');
      final matches = await OpenBackend.instance.activeMatches();
      final keys = await OpenBackend.instance.client
          .from('key_requests')
          .select('id')
          .eq('receiver_id', id);
      if (!mounted) return;
      setState(() {
        profile = p == null ? <String, dynamic>{} : Map<String, dynamic>.from(p);
        questions = List<Map<String, dynamic>>.from(q);
        matchCount = matches.length;
        keyCount = (keys as List).length;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profil yüklenemedi: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  int? _age() {
    final raw = profile['birth_date']?.toString();
    if (raw == null || raw.isEmpty) return null;
    final birth = DateTime.tryParse(raw);
    if (birth == null) return null;
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) age--;
    return age;
  }

  Future<void> _editQuestions() async {
    final current = List<String>.generate(3, (i) {
      if (i < questions.length) return questions[i]['question']?.toString() ?? '';
      return '';
    });
    final controllers = current.map(TextEditingController.new).toList();
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(22, 22, 22, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(child: Text('Sorularını düzenle', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
              IconButton(onPressed: () => Navigator.pop(context, false), icon: const Icon(Icons.close_rounded)),
            ]),
            const SizedBox(height: 8),
            const Text('Profil kilidini açmak için karşı taraf bu 3 sorudan birini cevaplar.', style: TextStyle(color: ui.OpenApp.muted)),
            const SizedBox(height: 18),
            for (var i = 0; i < 3; i++) ...[
              TextField(
                controller: controllers[i],
                maxLength: 90,
                decoration: InputDecoration(labelText: '${i + 1}. soru', prefixIcon: const Icon(Icons.lock_outline_rounded)),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (controllers.any((c) => c.text.trim().isEmpty)) return;
                  Navigator.pop(context, true);
                },
                child: const Text('Soruları kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
    if (saved != true) return;
    setState(() => busy = true);
    try {
      await OpenBackend.instance.saveLockQuestions(controllers.map((c) => c.text.trim()).toList());
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Soruların güncellendi 🔐')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sorular kaydedilemedi: $e')));
    } finally {
      for (final c in controllers) c.dispose();
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış yapılsın mı?'),
        content: const Text('Hesabından çıkış yapacaksın. Tekrar giriş yapmak için e-posta veya telefonunu kullanabilirsin.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Vazgeç')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Çıkış yap')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => busy = true);
    try {
      await OpenBackend.instance.signOut();
      if (!mounted) return;
      widget.onSignedOut?.call();
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const SafeArea(child: Center(child: CircularProgressIndicator()));
    final name = (profile['display_name'] ?? 'Open kullanıcısı').toString();
    final city = (profile['city'] ?? '').toString();
    final avatar = profile['avatar_url']?.toString();
    final hasAvatar = avatar != null && avatar.isNotEmpty;
    final age = _age();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 12),
          children: [
            Row(
              children: [
                Container(width: 46, height: 46, decoration: _circleDecoration(), child: const Icon(Icons.auto_awesome_rounded, color: ui.OpenApp.lime)),
                const Spacer(),
                Container(width: 46, height: 46, decoration: _circleDecoration(), child: IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined))),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 188,
                    height: 188,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: ui.OpenApp.lime.withValues(alpha: .20), blurRadius: 38, spreadRadius: 7)],
                    ),
                    child: CircleAvatar(
                      backgroundColor: ui.OpenApp.soft,
                      backgroundImage: hasAvatar ? NetworkImage(avatar) : null,
                      child: hasAvatar ? null : const Icon(Icons.person_rounded, size: 82, color: ui.OpenApp.ink),
                    ),
                  ),
                  Positioned(
                    right: 3,
                    bottom: 8,
                    child: InkWell(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fotoğraf yükleme sıradaki adımda bağlanacak.'))),
                      child: Container(width: 54, height: 54, decoration: BoxDecoration(color: ui.OpenApp.lime, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)), child: const Icon(Icons.camera_alt_outlined)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$name${age == null ? '' : ', $age'}', style: const TextStyle(fontSize: 34, height: 1, fontWeight: FontWeight.w900, letterSpacing: -1)),
                  if (profile['is_verified'] == true) ...[const SizedBox(width: 7), const Icon(Icons.verified_rounded, color: ui.OpenApp.lime, size: 24)],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Text('${city.isEmpty ? 'Konum ekle' : city}  ·  ${profile['is_online'] == true ? 'Aktif' : 'Profilin'}', style: const TextStyle(color: ui.OpenApp.muted, fontSize: 15))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundAction(icon: Icons.settings_outlined, label: 'Ayarlar', onTap: () {}),
                const SizedBox(width: 34),
                _RoundAction(icon: Icons.add_a_photo_outlined, label: 'Medya Ekle', large: true, onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medya yükleme sıradaki adımda bağlanacak.')))),
                const SizedBox(width: 34),
                _RoundAction(icon: Icons.shield_outlined, label: 'Güvenlik', onTap: () {}),
              ],
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .055), blurRadius: 25, offset: const Offset(0, 8))]),
              child: Column(
                children: [
                  Row(children: [
                    const Text('Soruların ✨', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: -.5)),
                    const Spacer(),
                    TextButton.icon(onPressed: busy ? null : _editQuestions, icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Düzenle')),
                  ]),
                  const SizedBox(height: 6),
                  if (questions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: TextButton(onPressed: _editQuestions, child: const Text('3 kilit sorunu oluştur')),
                    )
                  else
                    for (var i = 0; i < questions.length; i++) ...[
                      _QuestionTile(question: questions[i]['question']?.toString() ?? '', onEdit: _editQuestions),
                      if (i != questions.length - 1) const SizedBox(height: 9),
                    ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _StatCard(icon: Icons.people_alt_outlined, label: 'Eşleşme', value: '$matchCount')),
                const SizedBox(width: 9),
                Expanded(child: _StatCard(icon: Icons.key_outlined, label: 'Anahtarlar', value: '$keyCount')),
                const SizedBox(width: 9),
                const Expanded(child: _StatCard(icon: Icons.trending_up_rounded, label: 'Cevap Oranı', value: '—')),
              ],
            ),
            const SizedBox(height: 16),
            TextButton.icon(onPressed: busy ? null : _signOut, icon: const Icon(Icons.logout_rounded), label: const Text('Çıkış yap'), style: TextButton.styleFrom(foregroundColor: Colors.red.shade700)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _circleDecoration() => BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .07), blurRadius: 16)]);
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.label, required this.onTap, this.large = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool large;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(60),
            child: Container(
              width: large ? 92 : 64,
              height: large ? 92 : 64,
              decoration: BoxDecoration(color: large ? ui.OpenApp.lime : Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: (large ? ui.OpenApp.lime : Colors.black).withValues(alpha: large ? .24 : .07), blurRadius: 24)]),
              child: Icon(icon, size: large ? 39 : 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: large ? 16 : 13, fontWeight: large ? FontWeight.w800 : FontWeight.w600)),
        ],
      );
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({required this.question, required this.onEdit});
  final String question;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(color: ui.OpenApp.soft, borderRadius: BorderRadius.circular(21)),
        child: Row(
          children: [
            Container(width: 43, height: 43, decoration: BoxDecoration(color: ui.OpenApp.lime.withValues(alpha: .18), shape: BoxShape.circle), child: const Icon(Icons.format_quote_rounded)),
            const SizedBox(width: 12),
            Expanded(child: Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, height: 1.25))),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 21)),
          ],
        ),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .045), blurRadius: 18)]),
        child: Row(
          children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: ui.OpenApp.lime.withValues(alpha: .18), shape: BoxShape.circle), child: Icon(icon, size: 20)),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 10.5, color: ui.OpenApp.muted)), Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900))])),
          ],
        ),
      );
}
