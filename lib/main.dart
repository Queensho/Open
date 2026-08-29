import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const OpenApp());

class OpenApp extends StatelessWidget {
  const OpenApp({super.key});
  static const lime = Color(0xFFBFFF00);
  static const ink = Color(0xFF111111);
  static const muted = Color(0xFF707070);
  static const soft = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Open',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: lime),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: soft,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: lime, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: lime,
              foregroundColor: ink,
              minimumSize: const Size.fromHeight(58),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        home: const SplashScreen(),
      );
}

class AssetSvg extends StatelessWidget {
  const AssetSvg(this.path, {super.key, this.size = 126, this.card = true});
  final String path;
  final double size;
  final bool card;
  @override
  Widget build(BuildContext context) {
    final image = Padding(
      padding: EdgeInsets.all(size * .08),
      child: SvgPicture.asset(path, fit: BoxFit.contain),
    );
    if (!card) return SizedBox(width: size, height: size, child: image);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * .28),
        boxShadow: [BoxShadow(color: OpenApp.lime.withValues(alpha: .20), blurRadius: 34, spreadRadius: 4, offset: const Offset(0, 8))],
      ),
      child: image,
    );
  }
}

class MiniSvg extends StatelessWidget {
  const MiniSvg(this.path, {super.key, this.size = 24, this.color = OpenApp.ink});
  final String path;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        path,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
}

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w900, letterSpacing: -1.1)),
        const SizedBox(height: 10),
        Text(subtitle, style: const TextStyle(fontSize: 15.5, height: 1.45, color: OpenApp.muted)),
      ]);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AssetSvg('assets/icons_pack/gradient/splash_logo.svg', size: 118),
            SizedBox(height: 26),
            Text('Open', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900)),
          ]),
        ),
      );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              const AssetSvg('assets/icons_pack/gradient/splash_logo.svg', size: 90),
              const SizedBox(height: 28),
              const Text('Open', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),
              const Text('Kaydırma.\nÖnce kilidimi aç.', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800)),
              const Spacer(),
              FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())), child: const Text('Başlayalım')),
            ]),
          ),
        ),
      );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final c = PageController();
  int page = 0;
  final pages = const [
    ('Profil değil,\ninsanı keşfet.', 'Önce soruları cevapla, sonra karar ver.', 'assets/icons_pack/gradient/icon_lock.svg'),
    ('3 kilit soru,\nyüzlerce olasılık.', 'Merak uyandıran sorularla daha anlamlı sohbetler.', 'assets/icons_pack/line/icon_question.svg'),
    ('Doğru kişiyle\nanahtarın uyusun.', 'Anahtarını gönder. Kabul edilirse profil açılır.', 'assets/icons_pack/gradient/icon_key.svg'),
    ('Gerçek bağlantılar\nburada başlar.', 'Daha az yüzeysel, daha çok sen.', 'assets/icons_pack/gradient/icon_unlock.svg'),
  ];

  void next() {
    if (page < 3) {
      c.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('Atla')),
            ),
            Expanded(
              child: PageView.builder(
                controller: c,
                itemCount: 4,
                onPageChanged: (v) => setState(() => page = v),
                itemBuilder: (_, i) {
                  final p = pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Center(child: AssetSvg(p.$3, size: 150))),
                      Text('0${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900, backgroundColor: OpenApp.lime)),
                      const SizedBox(height: 18),
                      Text(p.$1, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      Text(p.$2, style: const TextStyle(color: OpenApp.muted, fontSize: 16)),
                      const SizedBox(height: 24),
                      FilledButton(onPressed: next, child: const Text('Devam et')),
                    ]),
                  );
                },
              ),
            ),
          ]),
        ),
      );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  void go(BuildContext context) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              const AssetSvg('assets/icons_pack/gradient/splash_logo.svg', size: 82),
              const SizedBox(height: 26),
              const Text('Open', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text('Gerçek bağlantılar burada başlar.', style: TextStyle(fontSize: 18, color: OpenApp.muted)),
              const Spacer(),
              FilledButton(
                onPressed: () => go(context),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [MiniSvg('assets/icons_pack/line/icon_phone.svg', size: 22), SizedBox(width: 10), Text('Telefon ile devam et')]),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), shape: const StadiumBorder()),
                onPressed: () => go(context),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [MiniSvg('assets/icons_pack/line/icon_mail.svg', size: 22), SizedBox(width: 10), Text('E-posta ile devam et')]),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      );
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const AssetSvg('assets/icons_pack/gradient/icon_unlock.svg', size: 72),
              const SizedBox(height: 24),
              const PageTitle('Hesabını aç.', 'Kayıt bilgilerini gir, sonra profilini oluştur.'),
              const SizedBox(height: 24),
              const TextField(decoration: InputDecoration(labelText: 'E-posta veya telefon')),
              const SizedBox(height: 14),
              const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Şifre')),
              const SizedBox(height: 14),
              const TextField(decoration: InputDecoration(labelText: 'Doğum yılı')),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProfileScreen())), child: const Text('Kayıt ol ve devam et')),
            ]),
          ),
        ),
      );
}

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const PageTitle('Profilini oluştur.', 'Fotoğrafını ve 3 kilit sorunu ekle.'),
              const SizedBox(height: 24),
              Container(height: 160, decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(28)), child: const Center(child: Text('＋ Fotoğraf ekle', style: TextStyle(fontWeight: FontWeight.w800)))),
              const SizedBox(height: 14),
              const TextField(decoration: InputDecoration(labelText: 'Adın')),
              const SizedBox(height: 14),
              const TextField(decoration: InputDecoration(labelText: 'Kısa bio')),
              const SizedBox(height: 22),
              const Text('3 kilit sorusu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              for (int i = 1; i <= 3; i++) Padding(padding: const EdgeInsets.only(bottom: 12), child: TextField(decoration: InputDecoration(labelText: 'Kilit sorusu $i'))),
              FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell())), child: const Text('Profili tamamla')),
            ]),
          ),
        ),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int i = 0;
  final screens = const [DiscoverScreen(), KeysScreen(), MessagesScreen(), MyProfileScreen()];
  Widget navIcon(String path, int index) => MiniSvg(path, size: 24, color: i == index ? OpenApp.ink : const Color(0xFF777777));
  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[i],
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          indicatorColor: OpenApp.lime,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: [
            NavigationDestination(icon: navIcon('assets/icons_pack/nav/nav_home.svg', 0), label: 'Keşfet'),
            NavigationDestination(icon: navIcon('assets/icons_pack/nav/nav_key.svg', 1), label: 'Anahtarlar'),
            NavigationDestination(icon: navIcon('assets/icons_pack/nav/nav_messages.svg', 2), label: 'Mesajlar'),
            NavigationDestination(icon: navIcon('assets/icons_pack/nav/nav_profile.svg', 3), label: 'Profil'),
          ],
        ),
      );
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PageTitle('Keşfet', 'Fotoğraf kilitli. Önce soruyu cevapla.'),
            const Spacer(),
            Center(
              child: Column(children: [
                const AssetSvg('assets/icons_pack/gradient/icon_lock.svg', size: 150),
                const SizedBox(height: 18),
                const Text('Deniz, 27', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('“Bir pazar sabahı seni nerede bulurum?”'),
                const SizedBox(height: 20),
                FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnswerScreen())), child: const Text('Soruyu cevapla')),
              ]),
            ),
            const Spacer(),
          ]),
        ),
      );
}

class AnswerScreen extends StatelessWidget {
  const AnswerScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PageTitle('Anahtarını kazan.', 'Soruyu samimi şekilde cevapla.'),
            const SizedBox(height: 24),
            const TextField(maxLines: 5, decoration: InputDecoration(hintText: 'Cevabını yaz...')),
            const Spacer(),
            FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const KeySentScreen())), child: const Text('Anahtarı gönder')),
          ]),
        ),
      );
}

class KeySentScreen extends StatelessWidget {
  const KeySentScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const AssetSvg('assets/icons_pack/gradient/icon_key.svg', size: 150),
              const SizedBox(height: 24),
              const Text('Anahtar gönderildi!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text('Karşı taraf kabul ederse profil açılacak.'),
              const SizedBox(height: 30),
              FilledButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false), child: const Text('Keşfete dön')),
            ]),
          ),
        ),
      );
}

class KeysScreen extends StatelessWidget {
  const KeysScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PageTitle('Anahtarlar', 'Sana gelen cevaplar burada.'),
            const SizedBox(height: 28),
            Card(
              child: ListTile(
                leading: const AssetSvg('assets/icons_pack/gradient/icon_key.svg', size: 46, card: false),
                title: const Text('Ece sana bir anahtar gönderdi'),
                subtitle: const Text('“Kahve, sahil ve uzun bir yürüyüş.”'),
                trailing: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen())), child: const Text('Aç')),
              ),
            ),
          ]),
        ),
      );
}

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const AssetSvg('assets/icons_pack/gradient/icon_unlock.svg', size: 160),
              const SizedBox(height: 24),
              const Text('Kilit açıldı.', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text('Artık birbirinizi görebilir ve konuşabilirsiniz.'),
              const SizedBox(height: 28),
              FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())), child: const Text('Mesaj gönder')),
            ]),
          ),
        ),
      );
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PageTitle('Mesajlar', 'Kilidi açılan bağlantıların.'),
            const SizedBox(height: 24),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
              leading: const AssetSvg('assets/icons_pack/badge/icon_profile.svg', size: 48, card: false),
              title: const Text('Ece', style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: const Text('Selam 👋'),
            ),
          ]),
        ),
      );
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ece')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Expanded(child: Align(alignment: Alignment.topLeft, child: Card(child: Padding(padding: EdgeInsets.all(14), child: Text('Selam! Cevabını sevdim 😊'))))),
            Row(children: [
              const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Mesaj yaz...'))),
              const SizedBox(width: 10),
              SizedBox(width: 52, height: 52, child: FilledButton(onPressed: () {}, style: FilledButton.styleFrom(padding: EdgeInsets.zero, shape: const CircleBorder()), child: const AssetSvg('assets/icons_pack/gradient/icon_send.svg', size: 28, card: false))),
            ]),
          ]),
        ),
      );
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PageTitle('Profilin', 'Kilit sorularını ve profilini buradan yönet.'),
            SizedBox(height: 28),
            AssetSvg('assets/icons_pack/badge/icon_profile.svg', size: 110),
            SizedBox(height: 18),
            Text('Tayfun', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            Text('3 kilit sorusu aktif', style: TextStyle(color: OpenApp.muted)),
          ]),
        ),
      );
}
