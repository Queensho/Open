import 'package:flutter/material.dart';

import 'data/open_backend.dart';
import 'main.dart' as ui;

class DirectOpenApp extends StatelessWidget {
  const DirectOpenApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Open',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: ui.OpenApp.lime),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: ui.OpenApp.soft,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: ui.OpenApp.lime, width: 2)),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: ui.OpenApp.lime,
              foregroundColor: ui.OpenApp.ink,
              minimumSize: const Size.fromHeight(58),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        home: const _DirectEntry(),
      );
}

class _DirectEntry extends StatefulWidget {
  const _DirectEntry();
  @override
  State<_DirectEntry> createState() => _DirectEntryState();
}

class _DirectEntryState extends State<_DirectEntry> {
  String? error;
  bool busy = false;

  Future<void> start() async {
    setState(() { busy = true; error = null; });
    try {
      if (!OpenBackend.instance.isAuthenticated) {
        await OpenBackend.instance.startMockPhoneSession();
      }
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const _ProfileScreen()));
    } catch (e) {
      if (mounted) setState(() => error = 'Oturum açılamadı: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              const ui.AppSvg(ui.AppIcons.splash, size: 92, card: true),
              const SizedBox(height: 28),
              const Text('Open', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),
              const Text('Kaydırma.\nÖnce kilidimi aç.', style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              const Text('Gerçek bağlantılar burada başlar.', style: TextStyle(fontSize: 17, color: ui.OpenApp.muted)),
              const Spacer(),
              if (error != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
              FilledButton(onPressed: busy ? null : start, child: Text(busy ? 'Hazırlanıyor...' : 'Başlayalım')),
            ]),
          ),
        ),
      );
}

class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen();
  @override
  State<_ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  final name = TextEditingController();
  final city = TextEditingController();
  String gender = 'Kadın';
  bool busy = false;
  String? error;

  Future<void> next() async {
    if (name.text.trim().length < 2 || city.text.trim().length < 2) {
      setState(() => error = 'Adını ve konumunu doldur.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      await OpenBackend.instance.saveProfile(name.text, city.text, gender);
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const _QuestionsScreen()));
    } catch (e) {
      if (mounted) setState(() => error = 'Profil kaydedilemedi: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 4, 26, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const ui.StepHeader(step: 1, total: 2),
            const SizedBox(height: 24),
            const ui.PageTitle('Seni tanıyalım.', 'Profilin kilitli başlayacak. Temel bilgilerini ekle.'),
            const SizedBox(height: 24),
            Container(height: 170, width: double.infinity, decoration: BoxDecoration(color: ui.OpenApp.soft, borderRadius: BorderRadius.circular(30)), child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [ui.AppSvg(ui.AppIcons.camera, size: 52), SizedBox(height: 10), Text('Fotoğraf ekle', style: TextStyle(fontWeight: FontWeight.w800))]))),
            const SizedBox(height: 16),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Adın')),
            const SizedBox(height: 14),
            TextField(controller: city, decoration: const InputDecoration(labelText: 'Konum')),
            const SizedBox(height: 18),
            Wrap(spacing: 8, runSpacing: 8, children: ['Kadın', 'Erkek', 'Belirtmek istemiyorum'].map((item) => ChoiceChip(label: Text(item), selected: gender == item, selectedColor: ui.OpenApp.lime, onSelected: (_) => setState(() => gender = item))).toList()),
            if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 24),
            FilledButton(onPressed: busy ? null : next, child: Text(busy ? 'Kaydediliyor...' : 'Kilit sorularına geç')),
          ]),
        )),
      );
}

class _QuestionsScreen extends StatefulWidget {
  const _QuestionsScreen();
  @override
  State<_QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<_QuestionsScreen> {
  final selected = <int>{};
  bool busy = false;
  String? error;
  final questions = const [
    'Bir pazar sabahı seni nerede bulurum?',
    'Seni güldüren küçük şey ne?',
    'Birine hemen güvenmeni sağlayan şey?',
    'Hayalindeki plansız gün nasıl geçer?',
    'Bir şarkı seni hangi ana götürür?',
    'İlk buluşmada en çok neye dikkat edersin?',
  ];

  Future<void> finish() async {
    if (selected.length != 3) return;
    setState(() { busy = true; error = null; });
    try {
      final chosen = selected.toList()..sort();
      await OpenBackend.instance.saveLockQuestions(chosen.map((i) => questions[i]).toList());
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const ui.AppShell()), (_) => false);
    } catch (e) {
      if (mounted) setState(() => error = 'Sorular kaydedilemedi: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 4, 26, 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const ui.StepHeader(step: 2, total: 2),
            const SizedBox(height: 24),
            const ui.PageTitle('3 kilit sorunu seç.', 'Seni keşfetmek isteyen kişi önce bu sorulardan birini cevaplayacak.'),
            const SizedBox(height: 18),
            Expanded(child: ListView.separated(
              itemCount: questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final active = selected.contains(i);
                return InkWell(
                  onTap: busy ? null : () => setState(() { if (active) { selected.remove(i); } else if (selected.length < 3) { selected.add(i); } }),
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: active ? ui.OpenApp.lime.withValues(alpha: .16) : ui.OpenApp.soft, borderRadius: BorderRadius.circular(22), border: Border.all(color: active ? ui.OpenApp.lime : Colors.transparent, width: 2)),
                    child: Row(children: [Expanded(child: Text(questions[i], style: const TextStyle(fontWeight: FontWeight.w700))), ui.AppSvg(active ? ui.AppIcons.unlock : ui.AppIcons.lock, size: 28)]),
                  ),
                );
              },
            )),
            if (error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(error!, style: const TextStyle(color: Colors.red))),
            FilledButton(onPressed: selected.length == 3 && !busy ? finish : null, child: Text(busy ? 'Kaydediliyor...' : (selected.length == 3 ? 'Profili tamamla' : '${selected.length}/3 soru seçildi'))),
          ]),
        )),
      );
}
