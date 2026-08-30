import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/open_backend.dart';
import 'main.dart' as ui;
import 'real_app_shell.dart';

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
          inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: ui.OpenApp.soft, border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: ui.OpenApp.lime, width: 2)), contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17)),
          filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: ui.OpenApp.lime, foregroundColor: ui.OpenApp.ink, minimumSize: const Size.fromHeight(58), shape: const StadiumBorder(), textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
        ),
        home: const _Splash(),
      );
}

Future<void> _openAnonymousSession(BuildContext context) async {
  if (!OpenBackend.instance.isAuthenticated) await OpenBackend.instance.startMockPhoneSession();
  if (!context.mounted) return;
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const _ProfileScreen()), (_) => false);
}

class _Splash extends StatefulWidget { const _Splash(); @override State<_Splash> createState() => _SplashState(); }
class _SplashState extends State<_Splash> {
  @override void initState() { super.initState(); Future.delayed(const Duration(milliseconds: 900), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const _Welcome())); }); }
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [ui.AppSvg(ui.AppIcons.splash, size: 118, card: true), SizedBox(height: 26), Text('Open', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900))])));
}

class _Welcome extends StatelessWidget {
  const _Welcome();
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Spacer(), const ui.AppSvg(ui.AppIcons.splash, size: 90, card: true), const SizedBox(height: 28), const Text('Open', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900)), const SizedBox(height: 18), const Text('Kaydırma.\nÖnce kilidimi aç.', style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w800)), const Spacer(), FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _Onboarding())), child: const Text('Başlayalım'))]))));
}

class _Onboarding extends StatefulWidget { const _Onboarding(); @override State<_Onboarding> createState() => _OnboardingState(); }
class _OnboardingState extends State<_Onboarding> {
  final controller = PageController(); int page = 0;
  final pages = const [('Profil değil,\ninsanı keşfet.', 'Önce soruları cevapla, sonra karar ver.', ui.AppIcons.lock), ('3 kilit soru,\nyüzlerce olasılık.', 'Merak uyandıran sorularla daha anlamlı sohbetler.', ui.AppIcons.question), ('Doğru kişiyle\nanahtarın uyusun.', 'Anahtarını gönder. Kabul edilirse profil açılır.', ui.AppIcons.key), ('Gerçek bağlantılar\nburada başlar.', 'Daha az yüzeysel, daha çok sen.', ui.AppIcons.unlock)];
  void next() { if (page < pages.length - 1) { controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic); } else { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const _ContactChoice())); } }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Column(children: [Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.only(right: 18, top: 4), child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const _ContactChoice())), child: const Text('Atla', style: TextStyle(color: ui.OpenApp.ink, fontWeight: FontWeight.w800))))), Expanded(child: PageView.builder(controller: controller, itemCount: pages.length, onPageChanged: (v) => setState(() => page = v), itemBuilder: (_, i) { final item = pages[i]; return Padding(padding: const EdgeInsets.fromLTRB(28, 6, 28, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Center(child: ui.AppSvg(item.$3, size: 150, card: true))), Text(item.$1, style: const TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w900)), const SizedBox(height: 12), Text(item.$2, style: const TextStyle(color: ui.OpenApp.muted, fontSize: 16, height: 1.4)), const SizedBox(height: 20), FilledButton(onPressed: next, child: Text(i == pages.length - 1 ? 'Hadi başlayalım' : 'Devam et'))])); }))])));
}

class _ContactChoice extends StatelessWidget {
  const _ContactChoice();
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Spacer(), const ui.AppSvg(ui.AppIcons.splash, size: 82, card: true), const SizedBox(height: 26), const Text('Open', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)), const SizedBox(height: 12), const Text('Nasıl devam etmek istersin?', style: TextStyle(fontSize: 18, color: ui.OpenApp.muted)), const Spacer(), FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _PhoneInput())), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [ui.AppSvg(ui.AppIcons.phone, size: 23), SizedBox(width: 10), Text('Telefon ile devam et')])), const SizedBox(height: 12), OutlinedButton(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), shape: const StadiumBorder()), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _EmailInput())), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [ui.AppSvg(ui.AppIcons.mail, size: 23), SizedBox(width: 10), Text('E-posta ile devam et')]))]))));
}

class _PhoneInput extends StatefulWidget { const _PhoneInput(); @override State<_PhoneInput> createState() => _PhoneInputState(); }
class _PhoneInputState extends State<_PhoneInput> {
  final phone = TextEditingController(); bool busy = false; String? error;
  Future<void> next() async { final digits = phone.text.replaceAll(RegExp(r'\D'), ''); if (digits.length < 10) { setState(() => error = 'Geçerli bir telefon numarası gir.'); return; } setState(() { busy = true; error = null; }); try { await _openAnonymousSession(context); } catch (e) { if (mounted) setState(() => error = 'Devam edilemedi: $e'); } finally { if (mounted) setState(() => busy = false); } }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: Colors.transparent), body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(26, 12, 26, 28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const ui.AppSvg(ui.AppIcons.phone, size: 76, card: true), const SizedBox(height: 26), const ui.PageTitle('Telefon numaranı gir.', 'Doğrulama kodu istemeden doğrudan devam edeceksin.'), const SizedBox(height: 28), TextField(controller: phone, keyboardType: TextInputType.phone, autofocus: true, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]'))], decoration: InputDecoration(prefixText: '+90  ', labelText: 'Telefon numarası', hintText: '5XX XXX XX XX', errorText: error)), const Spacer(), FilledButton(onPressed: busy ? null : next, child: Text(busy ? 'Hazırlanıyor...' : 'Devam et'))]))));
}

class _EmailInput extends StatefulWidget { const _EmailInput(); @override State<_EmailInput> createState() => _EmailInputState(); }
class _EmailInputState extends State<_EmailInput> {
  final email = TextEditingController(); bool busy = false; String? error;
  Future<void> next() async { if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.text.trim())) { setState(() => error = 'Geçerli bir e-posta adresi gir.'); return; } setState(() { busy = true; error = null; }); try { await _openAnonymousSession(context); } catch (e) { if (mounted) setState(() => error = 'Devam edilemedi: $e'); } finally { if (mounted) setState(() => busy = false); } }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: Colors.transparent), body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(26, 12, 26, 28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const ui.AppSvg(ui.AppIcons.mail, size: 76, card: true), const SizedBox(height: 26), const ui.PageTitle('E-posta adresini gir.', 'Şifre veya e-posta doğrulaması istemeden devam edeceksin.'), const SizedBox(height: 28), TextField(controller: email, keyboardType: TextInputType.emailAddress, autofocus: true, decoration: InputDecoration(labelText: 'E-posta', hintText: 'ornek@mail.com', errorText: error)), const Spacer(), FilledButton(onPressed: busy ? null : next, child: Text(busy ? 'Hazırlanıyor...' : 'Devam et'))]))));
}

class _ProfileScreen extends StatefulWidget { const _ProfileScreen(); @override State<_ProfileScreen> createState() => _ProfileScreenState(); }
class _ProfileScreenState extends State<_ProfileScreen> {
  final name = TextEditingController(); final city = TextEditingController(); String gender = 'Kadın'; bool busy = false; String? error;
  Future<void> next() async { if (name.text.trim().length < 2 || city.text.trim().length < 2) { setState(() => error = 'Adını ve konumunu doldur.'); return; } setState(() { busy = true; error = null; }); try { await OpenBackend.instance.saveProfile(name.text, city.text, gender); if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_) => const _QuestionsScreen())); } catch (e) { if (mounted) setState(() => error = 'Profil kaydedilemedi: $e'); } finally { if (mounted) setState(() => busy = false); } }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: Colors.transparent), body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(26, 4, 26, 32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const ui.StepHeader(step: 1, total: 2), const SizedBox(height: 24), const ui.PageTitle('Seni tanıyalım.', 'Profilin kilitli başlayacak. Temel bilgilerini ekle.'), const SizedBox(height: 24), Container(height: 170, width: double.infinity, decoration: BoxDecoration(color: ui.OpenApp.soft, borderRadius: BorderRadius.circular(30)), child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [ui.AppSvg(ui.AppIcons.camera, size: 52), SizedBox(height: 10), Text('Fotoğraf ekle', style: TextStyle(fontWeight: FontWeight.w800))]))), const SizedBox(height: 16), TextField(controller: name, decoration: const InputDecoration(labelText: 'Adın')), const SizedBox(height: 14), TextField(controller: city, decoration: const InputDecoration(labelText: 'Konum')), const SizedBox(height: 18), Wrap(spacing: 8, runSpacing: 8, children: ['Kadın', 'Erkek', 'Belirtmek istemiyorum'].map((item) => ChoiceChip(label: Text(item), selected: gender == item, selectedColor: ui.OpenApp.lime, onSelected: (_) => setState(() => gender = item))).toList()), if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red))), const SizedBox(height: 24), FilledButton(onPressed: busy ? null : next, child: Text(busy ? 'Kaydediliyor...' : 'Kilit sorularına geç'))]))));
}

class _QuestionsScreen extends StatefulWidget { const _QuestionsScreen(); @override State<_QuestionsScreen> createState() => _QuestionsScreenState(); }
class _QuestionsScreenState extends State<_QuestionsScreen> {
  final selected = <int>{}; bool busy = false; String? error;
  final questions = const ['Bir pazar sabahı seni nerede bulurum?', 'Seni güldüren küçük şey ne?', 'Birine hemen güvenmeni sağlayan şey?', 'Hayalindeki plansız gün nasıl geçer?', 'Bir şarkı seni hangi ana götürür?', 'İlk buluşmada en çok neye dikkat edersin?'];
  Future<void> finish() async { if (selected.length != 3) return; setState(() { busy = true; error = null; }); try { final chosen = selected.toList()..sort(); await OpenBackend.instance.saveLockQuestions(chosen.map((i) => questions[i]).toList()); if (!mounted) return; Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const RealAppShell()), (_) => false); } catch (e) { if (mounted) setState(() => error = 'Sorular kaydedilemedi: $e'); } finally { if (mounted) setState(() => busy = false); } }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: Colors.transparent), body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(26, 4, 26, 28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const ui.StepHeader(step: 2, total: 2), const SizedBox(height: 24), const ui.PageTitle('3 kilit sorunu seç.', 'Seni keşfetmek isteyen kişi önce bu sorulardan birini cevaplayacak.'), const SizedBox(height: 18), Expanded(child: ListView.separated(itemCount: questions.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) { final active = selected.contains(i); return InkWell(onTap: busy ? null : () => setState(() { if (active) { selected.remove(i); } else if (selected.length < 3) { selected.add(i); } }), borderRadius: BorderRadius.circular(22), child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: active ? ui.OpenApp.lime.withValues(alpha: .16) : ui.OpenApp.soft, borderRadius: BorderRadius.circular(22), border: Border.all(color: active ? ui.OpenApp.lime : Colors.transparent, width: 2)), child: Row(children: [Expanded(child: Text(questions[i], style: const TextStyle(fontWeight: FontWeight.w700))), ui.AppSvg(active ? ui.AppIcons.unlock : ui.AppIcons.lock, size: 28)]))); })), if (error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(error!, style: const TextStyle(color: Colors.red))), FilledButton(onPressed: selected.length == 3 && !busy ? finish : null, child: Text(busy ? 'Kaydediliyor...' : (selected.length == 3 ? 'Profili tamamla' : '${selected.length}/3 soru seçildi')))]))));
}
