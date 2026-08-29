import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class AppIcon extends StatelessWidget {
  const AppIcon(this.index, {super.key, this.size = 64, this.card = false});
  final int index;
  final double size;
  final bool card;

  @override
  Widget build(BuildContext context) {
    final col = index % 4;
    final row = index ~/ 4;
    final icon = SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topLeft,
          minWidth: size * 4,
          maxWidth: size * 4,
          minHeight: size * 5,
          maxHeight: size * 5,
          child: Transform.translate(
            offset: Offset(-col * size, -row * size),
            child: Image.asset(
              'assets/icons_pack/preview_sprite.png',
              width: size * 4,
              height: size * 5,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
    if (!card) return icon;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * .28),
        boxShadow: [BoxShadow(color: OpenApp.lime.withValues(alpha: .18), blurRadius: 30, spreadRadius: 3, offset: const Offset(0, 8))],
      ),
      child: icon,
    );
  }
}

class IconsPack {
  static const splash = 0;
  static const lock = 1;
  static const question = 2;
  static const key = 3;
  static const unlock = 4;
  static const phone = 5;
  static const mail = 6;
  static const camera = 7;
  static const navHome = 8;
  static const navHomeActive = 9;
  static const navKey = 10;
  static const navKeyActive = 11;
  static const navMessages = 12;
  static const navMessagesActive = 13;
  static const navProfile = 14;
  static const navProfileActive = 15;
  static const profile = 16;
  static const send = 17;
}

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, this.subtitle, {super.key});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w900, letterSpacing: -1.1)),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(fontSize: 15.5, height: 1.45, color: OpenApp.muted)),
        ],
      );
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
            AppIcon(IconsPack.splash, size: 118, card: true),
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
              const AppIcon(IconsPack.splash, size: 90, card: true),
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
    ('Profil değil,\ninsanı keşfet.', 'Önce soruları cevapla, sonra karar ver.', IconsPack.lock),
    ('3 kilit soru,\nyüzlerce olasılık.', 'Merak uyandıran sorularla daha anlamlı sohbetler.', IconsPack.question),
    ('Doğru kişiyle\nanahtarın uyusun.', 'Anahtarını gönder. Kabul edilirse profil açılır.', IconsPack.key),
    ('Gerçek bağlantılar\nburada başlar.', 'Daha az yüzeysel, daha çok sen.', IconsPack.unlock),
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
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('Atla'))),
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
                      Expanded(child: Center(child: AppIcon(p.$3, size: 150, card: true))),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: OpenApp.lime, borderRadius: BorderRadius.circular(18)), child: Text('0${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900))),
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
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              const AppIcon(IconsPack.splash, size: 82, card: true),
              const SizedBox(height: 26),
              const Text('Open', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text('Gerçek bağlantılar burada başlar.', style: TextStyle(fontSize: 18, color: OpenApp.muted)),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneLoginScreen())),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [AppIcon(IconsPack.phone, size: 24), SizedBox(width: 10), Text('Telefon ile devam et')]),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), shape: const StadiumBorder()),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [AppIcon(IconsPack.mail, size: 24), SizedBox(width: 10), Text('E-posta ile devam et')]),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      );
}

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final phone = TextEditingController();
  String? error;
  void sendCode() {
    final digits = phone.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      setState(() => error = 'Geçerli bir telefon numarası gir.');
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(phone: phone.text.trim())));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const AppIcon(IconsPack.phone, size: 76, card: true),
              const SizedBox(height: 26),
              const PageTitle('Telefon numaranı gir.', 'Sana 6 haneli bir doğrulama kodu göndereceğiz.'),
              const SizedBox(height: 28),
              TextField(controller: phone, keyboardType: TextInputType.phone, autofocus: true, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]'))], decoration: InputDecoration(prefixText: '+90  ', labelText: 'Telefon numarası', hintText: '5XX XXX XX XX', errorText: error)),
              const SizedBox(height: 12),
              const Text('Şimdilik test doğrulama kodu: 123456', style: TextStyle(color: OpenApp.muted, fontSize: 13)),
              const Spacer(),
              FilledButton(onPressed: sendCode, child: const Text('Onay kodu gönder')),
            ]),
          ),
        ),
      );
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});
  final String phone;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final code = TextEditingController();
  String? error;
  void verify() {
    if (code.text.trim() != '123456') {
      setState(() => error = 'Kod hatalı. Test kodu: 123456');
      return;
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CreateProfileScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const AppIcon(IconsPack.unlock, size: 76, card: true),
              const SizedBox(height: 26),
              PageTitle('Onay kodunu gir.', '+90 ${widget.phone} numarasına gönderilen 6 haneli kodu yaz.'),
              const SizedBox(height: 28),
              TextField(controller: code, keyboardType: TextInputType.number, autofocus: true, maxLength: 6, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 10), inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)], decoration: InputDecoration(counterText: '', hintText: '••••••', errorText: error), onSubmitted: (_) => verify()),
              const SizedBox(height: 14),
              Center(child: TextButton(onPressed: () => setState(() => error = null), child: const Text('Kodu tekrar gönder'))),
              const Spacer(),
              FilledButton(onPressed: verify, child: const Text('Doğrula ve devam et')),
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
              const AppIcon(IconsPack.unlock, size: 72, card: true),
              const SizedBox(height: 24),
              const PageTitle('Hesabını aç.', 'E-posta ile kayıt bilgilerini gir, sonra profilini oluştur.'),
              const SizedBox(height: 24),
              const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'E-posta')),
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
              Container(height: 160, decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(28)), child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [AppIcon(IconsPack.camera, size: 50), SizedBox(height: 8), Text('Fotoğraf ekle', style: TextStyle(fontWeight: FontWeight.w800))]))),
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
  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[i],
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          indicatorColor: OpenApp.lime,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: [
            NavigationDestination(icon: AppIcon(i == 0 ? IconsPack.navHomeActive : IconsPack.navHome, size: 26), label: 'Keşfet'),
            NavigationDestination(icon: AppIcon(i == 1 ? IconsPack.navKeyActive : IconsPack.navKey, size: 26), label: 'Anahtarlar'),
            NavigationDestination(icon: AppIcon(i == 2 ? IconsPack.navMessagesActive : IconsPack.navMessages, size: 26), label: 'Mesajlar'),
            NavigationDestination(icon: AppIcon(i == 3 ? IconsPack.navProfileActive : IconsPack.navProfile, size: 26), label: 'Profil'),
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
            Center(child: Column(children: [
              const AppIcon(IconsPack.lock, size: 150, card: true),
              const SizedBox(height: 18),
              const Text('Deniz, 27', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('“Bir pazar sabahı seni nerede bulurum?”'),
              const SizedBox(height: 20),
              FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnswerScreen())), child: const Text('Soruyu cevapla')),
            ])),
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
              const AppIcon(IconsPack.key, size: 150, card: true),
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
            Card(child: ListTile(leading: const AppIcon(IconsPack.key, size: 46), title: const Text('Ece sana bir anahtar gönderdi'), subtitle: const Text('“Kahve, sahil ve uzun bir yürüyüş.”'), trailing: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen())), child: const Text('Aç')))),
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
              const AppIcon(IconsPack.unlock, size: 160, card: true),
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
            ListTile(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())), leading: const AppIcon(IconsPack.profile, size: 48), title: const Text('Ece', style: TextStyle(fontWeight: FontWeight.w800)), subtitle: const Text('Selam 👋')),
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
              SizedBox(width: 52, height: 52, child: FilledButton(onPressed: () {}, style: FilledButton.styleFrom(padding: EdgeInsets.zero, shape: const CircleBorder()), child: const AppIcon(IconsPack.send, size: 28))),
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
            AppIcon(IconsPack.profile, size: 110, card: true),
            SizedBox(height: 18),
            Text('Tayfun', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            Text('3 kilit sorusu aktif', style: TextStyle(color: OpenApp.muted)),
          ]),
        ),
      );
}
