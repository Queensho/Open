import 'package:flutter/material.dart';

import 'data/open_backend.dart';
import 'main.dart' as ui;
import 'real_social_flow.dart';

class RealAppShell extends StatefulWidget {
  const RealAppShell({super.key, this.onSignedOut});
  final VoidCallback? onSignedOut;
  @override
  State<RealAppShell> createState() => _RealAppShellState();
}

class _RealAppShellState extends State<RealAppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const RealDiscoverScreen(),
      const RealKeysScreen(),
      const RealMessagesScreen(),
      _RealProfileScreen(onSignedOut: widget.onSignedOut),
    ];
    final icons = [
      [ui.AppIcons.navHome, ui.AppIcons.navHomeActive],
      [ui.AppIcons.navKey, ui.AppIcons.navKeyActive],
      [ui.AppIcons.navMessages, ui.AppIcons.navMessagesActive],
      [ui.AppIcons.navProfile, ui.AppIcons.navProfileActive],
    ];
    final labels = ['Keşfet', 'Anahtarlar', 'Mesajlar', 'Profil'];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 24, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => index = i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ui.AppSvg(index == i ? icons[i][1] : icons[i][0], size: 27),
                        const SizedBox(height: 3),
                        Text(labels[i], style: TextStyle(fontSize: 11, fontWeight: index == i ? FontWeight.w800 : FontWeight.w600, color: index == i ? ui.OpenApp.ink : ui.OpenApp.muted)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _RealProfileScreen extends StatefulWidget {
  const _RealProfileScreen({this.onSignedOut});
  final VoidCallback? onSignedOut;
  @override
  State<_RealProfileScreen> createState() => _RealProfileScreenState();
}

class _RealProfileScreenState extends State<_RealProfileScreen> {
  bool busy = false;

  Future<void> signOut() async {
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
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Çıkış yapılamadı: $e')));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ui.PageTitle('Profilin', 'Kilit sorularını ve profilini buradan yönet.'),
              const SizedBox(height: 28),
              const ui.AppSvg(ui.AppIcons.profile, size: 110, card: true),
              const SizedBox(height: 18),
              const Text('Profil hazır', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const Text('3 kilit sorusu aktif', style: TextStyle(color: ui.OpenApp.muted)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: busy ? null : signOut,
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(busy ? 'Çıkış yapılıyor...' : 'Çıkış yap'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade100),
                    minimumSize: const Size.fromHeight(56),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class RealDiscoverScreen extends StatefulWidget {
  const RealDiscoverScreen({super.key});
  @override
  State<RealDiscoverScreen> createState() => _RealDiscoverScreenState();
}

class _RealDiscoverScreenState extends State<RealDiscoverScreen> {
  late Future<List<Map<String, dynamic>>> future;
  int cardIndex = 0;

  @override
  void initState() {
    super.initState();
    future = OpenBackend.instance.discover();
  }

  void reload() => setState(() {
        cardIndex = 0;
        future = OpenBackend.instance.discover();
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Merhaba 👋', style: TextStyle(color: ui.OpenApp.muted, fontWeight: FontWeight.w600)), SizedBox(height: 2), Text('Keşfet ✨', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, letterSpacing: -1))])),
              IconButton(onPressed: reload, icon: const Icon(Icons.refresh_rounded)),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return _StateCard(title: 'Keşfet yüklenemedi', subtitle: '${snapshot.error}', action: reload);
                  final profiles = snapshot.data ?? const <Map<String, dynamic>>[];
                  if (profiles.isEmpty) return _StateCard(title: 'Henüz keşfedecek profil yok.', subtitle: 'Yeni profiller tamamlandığında burada görünecek.', action: reload);
                  if (cardIndex >= profiles.length) return _StateCard(title: 'Şimdilik bu kadar ✨', subtitle: 'Yeni profiller için tekrar kontrol edebilirsin.', action: reload);
                  final profile = profiles[cardIndex];
                  return _ProfileCard(profile: profile, onSkip: () => setState(() => cardIndex++), onKey: () => _answer(profile));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _answer(Map<String, dynamic> profile) async {
    final raw = profile['profile_questions'];
    final questions = raw is List ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : <Map<String, dynamic>>[];
    questions.sort((a, b) => ((a['position'] as num?)?.toInt() ?? 0).compareTo((b['position'] as num?)?.toInt() ?? 0));
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bu profilin kilit sorusu bulunamadı.')));
      return;
    }
    final sent = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => RealAnswerScreen(profile: profile, questions: questions)));
    if (sent == true && mounted) setState(() => cardIndex++);
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onSkip, required this.onKey});
  final Map<String, dynamic> profile;
  final VoidCallback onSkip;
  final VoidCallback onKey;

  @override
  Widget build(BuildContext context) {
    final name = (profile['display_name'] ?? 'Open kullanıcısı').toString();
    final city = (profile['city'] ?? '').toString();
    final bio = (profile['bio'] ?? '').toString();
    final avatar = profile['avatar_url']?.toString();
    final interests = profile['interests'] is List ? List<String>.from(profile['interests']) : <String>[];
    final hasAvatar = avatar != null && avatar.isNotEmpty;
    return Column(children: [
      Expanded(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(34), color: ui.OpenApp.soft, image: hasAvatar ? DecorationImage(image: NetworkImage(avatar), fit: BoxFit.cover) : null),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(34), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: hasAvatar ? .78 : .12)])),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              Text(name, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: hasAvatar ? Colors.white : ui.OpenApp.ink)),
              if (city.isNotEmpty) Text(city, style: TextStyle(fontSize: 16, color: hasAvatar ? Colors.white70 : ui.OpenApp.muted)),
              if (bio.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: hasAvatar ? Colors.white : ui.OpenApp.ink))),
              if (interests.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Wrap(spacing: 7, runSpacing: 7, children: interests.take(3).map((e) => Chip(label: Text(e))).toList())),
            ]),
          ),
        ),
      ),
      const SizedBox(height: 14),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _CircleAction(icon: Icons.close_rounded, onTap: onSkip),
        const SizedBox(width: 20),
        InkWell(onTap: onKey, borderRadius: BorderRadius.circular(40), child: Container(width: 70, height: 70, decoration: const BoxDecoration(color: ui.OpenApp.lime, shape: BoxShape.circle), child: const Center(child: ui.AppSvg(ui.AppIcons.key, size: 36)))),
        const SizedBox(width: 20),
        _CircleAction(icon: Icons.favorite_border_rounded, onTap: onKey),
      ]),
      const SizedBox(height: 8),
      const Text('Kilidi açmak için bir soruyu cevapla', style: TextStyle(color: ui.OpenApp.muted, fontSize: 12.5)),
    ]);
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(40), child: Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 18)]), child: Icon(icon, size: 29)));
}

class RealAnswerScreen extends StatefulWidget {
  const RealAnswerScreen({super.key, required this.profile, required this.questions});
  final Map<String, dynamic> profile;
  final List<Map<String, dynamic>> questions;
  @override
  State<RealAnswerScreen> createState() => _RealAnswerScreenState();
}

class _RealAnswerScreenState extends State<RealAnswerScreen> {
  int selected = 0;
  final answer = TextEditingController();
  bool busy = false;
  String? error;

  Future<void> send() async {
    if (answer.text.trim().isEmpty) {
      setState(() => error = 'Önce cevabını yaz.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      final q = widget.questions[selected];
      await OpenBackend.instance.sendKey(widget.profile['id'].toString(), q['id'].toString(), answer.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anahtar gönderildi 🔑')));
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = 'Anahtar gönderilemedi: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 26),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ui.PageTitle('${widget.profile['display_name']} için bir soru seç.', 'Cevabın anahtar isteği olarak karşı tarafa gidecek.'),
            const SizedBox(height: 20),
            ...List.generate(widget.questions.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 9), child: ChoiceChip(label: Text(widget.questions[i]['question'].toString()), selected: selected == i, selectedColor: ui.OpenApp.lime, onSelected: (_) => setState(() => selected = i)))),
            const SizedBox(height: 18),
            TextField(controller: answer, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Cevabın', hintText: 'Kendin gibi cevapla...')),
            if (error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(error!, style: const TextStyle(color: Colors.red))),
            const Spacer(),
            FilledButton(onPressed: busy ? null : send, child: Text(busy ? 'Gönderiliyor...' : 'Anahtarı gönder')),
          ]),
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.title, required this.subtitle, required this.action});
  final String title;
  final String subtitle;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(color: ui.OpenApp.soft, borderRadius: BorderRadius.circular(28)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ui.AppSvg(ui.AppIcons.lock, size: 64),
          const SizedBox(height: 18),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: ui.OpenApp.muted)),
          const SizedBox(height: 18),
          TextButton(onPressed: action, child: const Text('Tekrar kontrol et')),
        ]),
      ),
    );
  }
}
