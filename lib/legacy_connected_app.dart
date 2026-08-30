import 'package:flutter/material.dart';

import 'data/open_backend.dart';
import 'main.dart' as ui;

class LegacyConnectedApp extends StatelessWidget {
  const LegacyConnectedApp({super.key});

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
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
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
        home: const _EntryScreen(),
      );
}

class _EntryScreen extends StatefulWidget {
  const _EntryScreen();
  @override
  State<_EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<_EntryScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final next = OpenBackend.instance.isAuthenticated ? const ui.AppShell() : const _WelcomeScreen();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ui.AppSvg(ui.AppIcons.splash, size: 118, card: true),
            SizedBox(height: 26),
            Text('Open', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900)),
          ]),
        ),
      );
}

class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              const ui.AppSvg(ui.AppIcons.splash, size: 90, card: true),
              const SizedBox(height: 28),
              const Text('Open', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),
              const Text('Kaydırma.\nÖnce kilidimi aç.', style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w800)),
              const Spacer(),
              FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _LoginScreen())), child: const Text('Başlayalım')),
            ]),
          ),
        ),
      );
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              const ui.AppSvg(ui.AppIcons.splash, size: 82, card: true),
              const SizedBox(height: 26),
              const Text('Open', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text('Gerçek bağlantılar burada başlar.', style: TextStyle(fontSize: 18, color: ui.OpenApp.muted)),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ui.PhoneLoginScreen())),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [ui.AppSvg(ui.AppIcons.phone, size: 23), SizedBox(width: 10), Text('Telefon ile devam et')]),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), shape: const StadiumBorder()),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _EmailAuthScreen())),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [ui.AppSvg(ui.AppIcons.mail, size: 23), SizedBox(width: 10), Text('E-posta ile devam et')]),
              ),
            ]),
          ),
        ),
      );
}

class _EmailAuthScreen extends StatefulWidget {
  const _EmailAuthScreen();
  @override
  State<_EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<_EmailAuthScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool login = false;
  bool busy = false;
  String? error;

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6) {
      setState(() => error = 'Geçerli e-posta ve en az 6 karakter şifre gir.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      final response = login
          ? await OpenBackend.instance.loginEmail(email.text, password.text)
          : await OpenBackend.instance.registerEmail(email.text, password.text);
      if (!mounted) return;
      if (response.session == null) {
        setState(() => error = 'E-postana gelen doğrulama bağlantısını açıp sonra giriş yap.');
        return;
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const _ProfileScreen()), (_) => false);
    } catch (e) {
      if (mounted) setState(() => error = 'İşlem tamamlanamadı: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ui.PageTitle(login ? 'Tekrar hoş geldin.' : 'Hesabını aç.', login ? 'E-posta ve şifrenle giriş yap.' : 'E-posta ile kayıt bilgilerini gir, sonra profilini oluştur.'),
              const SizedBox(height: 24),
              TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-posta')),
              const SizedBox(height: 14),
              TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Şifre')),
              if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
              const SizedBox(height: 24),
              FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Bekle...' : (login ? 'Giriş yap' : 'Kayıt ol ve devam et'))),
              const SizedBox(height: 10),
              Center(child: TextButton(onPressed: busy ? null : () => setState(() { login = !login; error = null; }), child: Text(login ? 'Yeni hesap oluştur' : 'Zaten hesabım var'))),
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
    if (name.text.trim().isEmpty || city.text.trim().isEmpty) {
      setState(() => error = 'Ad ve konum alanlarını doldur.');
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
        body: SafeArea(
          child: SingleChildScrollView(
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
              Wrap(spacing: 8, children: ['Kadın', 'Erkek', 'Belirtmek istemiyorum'].map((item) => ChoiceChip(label: Text(item), selected: gender == item, selectedColor: ui.OpenApp.lime, onSelected: (_) => setState(() => gender = item))).toList()),
              if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
              const SizedBox(height: 24),
              FilledButton(onPressed: busy ? null : next, child: Text(busy ? 'Kaydediliyor...' : 'Kilit sorularına geç')),
            ]),
          ),
        ),
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

  void toggle(int i) => setState(() {
        if (selected.contains(i)) { selected.remove(i); } else if (selected.length < 3) { selected.add(i); }
      });

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
        body: SafeArea(
          child: Padding(
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
                  return InkWell(onTap: () => toggle(i), borderRadius: BorderRadius.circular(22), child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: active ? ui.OpenApp.lime.withValues(alpha: .16) : ui.OpenApp.soft, borderRadius: BorderRadius.circular(22), border: Border.all(color: active ? ui.OpenApp.lime : Colors.transparent, width: 2)),
                    child: Row(children: [Expanded(child: Text(questions[i], style: const TextStyle(fontWeight: FontWeight.w700))), ui.AppSvg(active ? ui.AppIcons.unlock : ui.AppIcons.lock, size: 28)]),
                  ));
                },
              )),
              if (error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(error!, style: const TextStyle(color: Colors.red))),
              FilledButton(onPressed: selected.length == 3 && !busy ? finish : null, child: Text(busy ? 'Kaydediliyor...' : (selected.length == 3 ? 'Profili tamamla' : '${selected.length}/3 soru seçildi'))),
            ]),
          ),
        ),
      );
}
