import 'package:flutter/material.dart';

void main() => runApp(const OpenApp());

class OpenApp extends StatelessWidget {
  const OpenApp({super.key});
  static const lime = Color(0xFFC6FF00);
  static const ink = Color(0xFF0D0D0D);
  static const bg = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(seedColor: lime, brightness: Brightness.light),
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
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 92, height: 92,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: OpenApp.lime.withValues(alpha: .32), blurRadius: 42, spreadRadius: 5)],
            ),
            child: const Icon(Icons.lock_open_rounded, color: OpenApp.lime, size: 52),
          ),
          const SizedBox(height: 24),
          const Text('Open', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
        ]),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Spacer(flex: 2),
            Container(
              width: 82, height: 82,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFF0F0F0)),
                boxShadow: [BoxShadow(color: OpenApp.lime.withValues(alpha: .25), blurRadius: 34, spreadRadius: 2)],
              ),
              child: const Icon(Icons.lock_open_rounded, color: OpenApp.lime, size: 46),
            ),
            const SizedBox(height: 32),
            const Text('Open', style: TextStyle(fontSize: 52, height: 1, fontWeight: FontWeight.w900, letterSpacing: -2)),
            const SizedBox(height: 24),
            const Text('Kaydırma.\nÖnce kilidimi aç.', style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w850, letterSpacing: -.7)),
            const SizedBox(height: 18),
            const SizedBox(width: 44, child: Divider(color: OpenApp.lime, thickness: 3)),
            const SizedBox(height: 14),
            const Text('Bir fotoğraftan fazlasını keşfet.\nSoruyu cevapla, profili aç ve gerçek bir bağ kur.', style: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF666666))),
            const Spacer(flex: 3),
            FilledButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())),
              child: const Text('Başlayalım'),
            ),
          ]),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;
  final pages = const [
    ('Profil değil,\ninsanı keşfet.', 'Önce soruları cevapla, sonra karar ver.', Icons.lock_outline_rounded),
    ('3 kilit soru,\nyüzlerce olasılık.', 'Merak uyandıran sorularla daha anlamlı sohbetler.', Icons.question_mark_rounded),
    ('Doğru kişiyle\nanahtarın uyusun.', 'Anahtarını gönder. Kabul edilirse profil açılır ve sohbet başlar.', Icons.key_rounded),
    ('Gerçek bağlantılar\nburada başlar.', 'Daha az yüzeysel, daha çok sen.', Icons.lock_open_rounded),
  ];

  void next() {
    if (page < pages.length - 1) {
      controller.nextPage(duration: const Duration(milliseconds: 330), curve: Curves.easeOutCubic);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              child: const Text('Atla', style: TextStyle(color: OpenApp.ink, fontWeight: FontWeight.w700)),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (v) => setState(() => page = v),
              itemBuilder: (_, i) {
                final item = pages[i];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(28, 18, 28, 18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 190, height: 190,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: OpenApp.lime.withValues(alpha: .08)),
                          child: Center(
                            child: Container(
                              width: 112, height: 112,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(34),
                                boxShadow: [BoxShadow(color: OpenApp.lime.withValues(alpha: .38), blurRadius: 45, spreadRadius: 3)],
                              ),
                              child: Icon(item.$3, size: 62, color: OpenApp.lime),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: OpenApp.lime, borderRadius: BorderRadius.circular(20)),
                      child: Text('0${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(height: 18),
                    Text(item.$1, style: const TextStyle(fontSize: 32, height: 1.08, fontWeight: FontWeight.w900, letterSpacing: -.8)),
                    const SizedBox(height: 14),
                    Text(item.$2, style: const TextStyle(fontSize: 16, height: 1.45, color: Color(0xFF666666))),
                    const SizedBox(height: 26),
                    Row(children: List.generate(pages.length, (d) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 7),
                      width: d == page ? 25 : 8, height: 8,
                      decoration: BoxDecoration(color: d == page ? OpenApp.lime : const Color(0xFFD8D8D8), borderRadius: BorderRadius.circular(10)),
                    ))),
                    const SizedBox(height: 24),
                    FilledButton(onPressed: next, child: Text(i == pages.length - 1 ? 'Hadi!' : 'Devam et')),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Spacer(),
            const Text('Open', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: -2)),
            const SizedBox(height: 12),
            const Text('Gerçek bağlantılar burada başlar.', style: TextStyle(fontSize: 18, color: Color(0xFF666666))),
            const Spacer(),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.phone_rounded), label: const Text('Telefon ile devam et')),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), shape: const StadiumBorder(), foregroundColor: OpenApp.ink),
              onPressed: () {}, icon: const Icon(Icons.mail_outline_rounded), label: const Text('E-posta ile devam et'),
            ),
            const SizedBox(height: 24),
            const Center(child: Text('Zaten hesabın var mı?  Giriş yap', style: TextStyle(color: Color(0xFF777777)))),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }
}
