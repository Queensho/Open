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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: lime, width: 2),
            ),
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
        boxShadow: [
          BoxShadow(
            color: OpenApp.lime.withValues(alpha: .20),
            blurRadius: 34,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: image,
    );
  }
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
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AssetSvg('assets/icons_svg/splash_logo.svg', size: 118),
              const SizedBox(height: 26),
              const Text('Open', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: -1.8)),
              const SizedBox(height: 9),
              Container(width: 34, height: 5, decoration: BoxDecoration(color: OpenApp.lime, borderRadius: BorderRadius.circular(9))),
            ],
          ),
        ),
      );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),
                const AssetSvg('assets/icons_svg/splash_logo.svg', size: 90),
                const SizedBox(height: 30),
                const Text('Open', style: TextStyle(fontSize: 52, height: 1, fontWeight: FontWeight.w900, letterSpacing: -2)),
                const SizedBox(height: 22),
                const Text('Kaydırma.\nÖnce kilidimi aç.', style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -.7)),
                const SizedBox(height: 18),
                Container(width: 44, height: 4, decoration: BoxDecoration(color: OpenApp.lime, borderRadius: BorderRadius.circular(8))),
                const SizedBox(height: 16),
                const Text('Bir fotoğraftan fazlasını keşfet.\nSoruyu cevapla, profili aç ve gerçek bir bağ kur.', style: TextStyle(fontSize: 16, height: 1.5, color: OpenApp.muted)),
                const Spacer(flex: 3),
                FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())), child: const Text('Başlayalım')),
              ],
            ),
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
  final controller = PageController();
  int page = 0;
  final pages = const [
    ('Profil değil,\ninsanı keşfet.', 'Önce soruları cevapla, sonra karar ver.', 'assets/icons_svg/icon_lock.svg'),
    ('3 kilit soru,\nyüzlerce olasılık.', 'Merak uyandıran sorularla daha anlamlı sohbetler.', 'assets/icons_svg/icon_question.svg'),
    ('Doğru kişiyle\nanahtarın uyusun.', 'Anahtarını gönder. Kabul edilirse profil açılır ve sohbet başlar.', 'assets/icons_svg/icon_key.svg'),
    ('Gerçek bağlantılar\nburada başlar.', 'Daha az yüzeysel, daha çok sen.', 'assets/icons_svg/icon_unlock.svg'),
  ];

  void next() {
    if (page < pages.length - 1) {
      controller.nextPage(duration: const Duration(milliseconds: 330), curve: Curves.easeOutCubic);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 6),
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Atla', style: TextStyle(color: OpenApp.ink, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (v) => setState(() => page = v),
                  itemBuilder: (_, i) {
                    final p = pages[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(28, 8, 28, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 230,
                                height: 230,
                                decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [OpenApp.lime.withValues(alpha: .17), OpenApp.lime.withValues(alpha: .025), Colors.transparent])),
                                child: Center(child: AssetSvg(p.$3, size: 146)),
                              ),
                            ),
                          ),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: OpenApp.lime, borderRadius: BorderRadius.circular(18)), child: Text('0${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
                          const SizedBox(height: 18),
                          Text(p.$1, style: const TextStyle(fontSize: 34, height: 1.06, fontWeight: FontWeight.w900, letterSpacing: -1)),
                          const SizedBox(height: 15),
                          Text(p.$2, style: const TextStyle(fontSize: 16, height: 1.45, color: OpenApp.muted)),
                          const SizedBox(height: 26),
                          Row(children: List.generate(pages.length, (d) => AnimatedContainer(duration: const Duration(milliseconds: 220), margin: const EdgeInsets.only(right: 8), width: d == page ? 28 : 9, height: 9, decoration: BoxDecoration(color: d == page ? OpenApp.lime : const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(10))))),
                          const SizedBox(height: 25),
                          FilledButton(onPressed: next, child: Text(i == pages.length - 1 ? 'Open’a gir' : 'Devam et')),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AssetSvg('assets/icons_svg/icon_unlock.svg', size: 72),
                const SizedBox(height: 28),
                const PageTitle('Hesabını aç.', 'Open’da önce seni tanıyalım. Sonra profilini kilit sorularınla oluşturacaksın.'),
                const SizedBox(height: 28),
                TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-posta', hintText: 'ornek@mail.com')),
                const SizedBox(height: 14),
                TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Şifre', hintText: 'En az 8 karakter')),
                const SizedBox(height: 14),
                TextField(keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Doğum yılı', hintText: '1995')),
                const SizedBox(height: 26),
                FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProfileScreen())), child: const Text('Devam et')),
                const SizedBox(height: 16),
                Center(child: TextButton(onPressed: () {}, child: const Text('Zaten hesabın var mı? Giriş yap', style: TextStyle(color: OpenApp.ink, fontWeight: FontWeight.w700)))),
              ],
            ),
          ),
        ),
      );
}

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final questions = List.generate(3, (_) => TextEditingController());
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 22, 26, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), const Spacer(), const Text('Profil 1/2', style: TextStyle(fontWeight: FontWeight.w800))]),
                const SizedBox(height: 14),
                const PageTitle('Profilini oluştur.', 'Fotoğrafın hemen açılmayacak. Seni önce verdiğin ipuçları ve kilit soruların anlatacak.'),
                const SizedBox(height: 26),
                Container(height: 180, decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(30)), child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add_a_photo_rounded, size: 42), SizedBox(height: 10), Text('Fotoğraf ekle', style: TextStyle(fontWeight: FontWeight.w800))]))),
                const SizedBox(height: 16),
                const TextField(decoration: InputDecoration(labelText: 'Adın', hintText: 'Adın')),
                const SizedBox(height: 14),
                const TextField(decoration: InputDecoration(labelText: 'Kısa bio', hintText: 'Seni 1 cümlede anlat...')),
                const SizedBox(height: 28),
                Row(children: [const AssetSvg('assets/icons_svg/icon_lock.svg', size: 48), const SizedBox(width: 14), const Expanded(child: Text('3 kilit sorunu seç', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)))]),
                const SizedBox(height: 16),
                for (int i = 0; i < 3; i++) ...[
                  TextField(controller: questions[i], decoration: InputDecoration(labelText: 'Kilit sorusu ${i + 1}', hintText: i == 0 ? 'Bir pazar sabahı seni nerede bulurum?' : i == 1 ? 'Seni güldüren küçük şey ne?' : 'Birine hemen güvenmeni sağlayan şey?')),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 14),
                FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell())), child: const Text('Profili tamamla')),
              ],
            ),
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
  int index = 0;
  final screens = const [DiscoverScreen(), KeysScreen(), MessagesScreen(), MyProfileScreen()];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: OpenApp.lime,
          selectedIndex: index,
          onDestinationSelected: (v) => setState(() => index = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore_rounded), label: 'Keşfet'),
            NavigationDestination(icon: Icon(Icons.key_outlined), selectedIcon: Icon(Icons.key_rounded), label: 'Anahtarlar'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), selectedIcon: Icon(Icons.chat_bubble_rounded), label: 'Mesajlar'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      );
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [const Text('Open', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1.2)), const Spacer(), IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded))]),
              const SizedBox(height: 6),
              const Text('Önce merak et. Sonra aç.', style: TextStyle(color: OpenApp.muted, fontSize: 15)),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(34)),
                  child: Column(
                    children: [
                      const Spacer(),
                      Stack(alignment: Alignment.center, children: [
                        Container(width: 190, height: 190, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(38))),
                        const AssetSvg('assets/icons_svg/icon_lock.svg', size: 132),
                      ]),
                      const SizedBox(height: 20),
                      const Text('Maya, 27', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      const Text('İstanbul • 3 km', style: TextStyle(color: OpenApp.muted, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('KİLİT SORUSU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.1)), SizedBox(height: 10), Text('Bir pazar sabahı seni nerede bulurum?', style: TextStyle(fontSize: 20, height: 1.2, fontWeight: FontWeight.w800))])),
                      const SizedBox(height: 14),
                      FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnswerKeyScreen())), icon: const Icon(Icons.key_rounded), label: const Text('Soruyu cevapla')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class AnswerKeyScreen extends StatefulWidget {
  const AnswerKeyScreen({super.key});
  @override
  State<AnswerKeyScreen> createState() => _AnswerKeyScreenState();
}

class _AnswerKeyScreenState extends State<AnswerKeyScreen> {
  final answer = TextEditingController();
  bool sent = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
                const SizedBox(height: 16),
                const AssetSvg('assets/icons_svg/icon_key.svg', size: 92),
                const SizedBox(height: 26),
                const PageTitle('Anahtarını gönder.', 'Cevabın onun profilini açmak için ilk adım. Samimi ol; burada doğru cevap yok.'),
                const SizedBox(height: 24),
                Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(24)), child: const Text('“Bir pazar sabahı seni nerede bulurum?”', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1.25))),
                const SizedBox(height: 16),
                TextField(controller: answer, maxLines: 5, decoration: const InputDecoration(hintText: 'Cevabını yaz...')),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    setState(() => sent = true);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anahtar gönderildi.')));
                  },
                  child: Text(sent ? 'Anahtar gönderildi ✓' : 'Anahtarı gönder'),
                ),
              ],
            ),
          ),
        ),
      );
}

class KeysScreen extends StatelessWidget {
  const KeysScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Anahtarlar', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
              const SizedBox(height: 6),
              const Text('Sana gelen cevapları burada aç.', style: TextStyle(color: OpenApp.muted)),
              const SizedBox(height: 24),
              _keyCard(context, 'Deniz, 29', '“Kahve, uzun yürüyüş ve telefonsuz bir kahvaltı.”'),
              const SizedBox(height: 14),
              _keyCard(context, 'Ece, 26', '“Muhtemelen sahilde, kulaklıkla ve elimde kruvasanla.”'),
            ],
          ),
        ),
      );

  Widget _keyCard(BuildContext context, String name, String answer) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(26)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AssetSvg('assets/icons_svg/icon_key.svg', size: 58),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(answer, style: const TextStyle(height: 1.35, color: OpenApp.muted)), const SizedBox(height: 14), Row(children: [Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Geç'))), const SizedBox(width: 10), Expanded(child: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MatchScreen(name: name))), child: const Text('Aç')))])])),
          ],
        ),
      );
}

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                const Spacer(),
                const AssetSvg('assets/icons_svg/icon_unlock.svg', size: 150),
                const SizedBox(height: 28),
                const Text('Kilit açıldı.', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: -1.4)),
                const SizedBox(height: 10),
                Text('$name ile artık birbirinizi görebilir ve konuşabilirsiniz.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, height: 1.45, color: OpenApp.muted)),
                const Spacer(),
                FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatScreen(name: name))), child: const Text('Mesaj gönder')),
                const SizedBox(height: 10),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Şimdi değil', style: TextStyle(color: OpenApp.ink, fontWeight: FontWeight.w700))),
              ],
            ),
          ),
        ),
      );
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mesajlar', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(radius: 28, backgroundColor: OpenApp.lime, child: const Icon(Icons.person_rounded, color: OpenApp.ink)),
                title: const Text('Deniz', style: TextStyle(fontWeight: FontWeight.w900)),
                subtitle: const Text('Bu cevap gerçekten iyiydi 😄', maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Text('Şimdi', style: TextStyle(fontSize: 12, color: OpenApp.muted)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen(name: 'Deniz'))),
              ),
            ],
          ),
        ),
      );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.name});
  final String name;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final messages = <String>['Bu cevap gerçekten iyiydi 😄', 'Pazar planımız belli oldu o zaman.'];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w900)), centerTitle: false),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => Align(
                    alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: const BoxConstraints(maxWidth: 290),
                      decoration: BoxDecoration(color: i.isEven ? OpenApp.soft : OpenApp.lime, borderRadius: BorderRadius.circular(20)),
                      child: Text(messages[i], style: const TextStyle(fontSize: 15.5, height: 1.3)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                child: Row(children: [Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Mesaj yaz...'))), const SizedBox(width: 8), IconButton.filled(style: IconButton.styleFrom(backgroundColor: OpenApp.lime, foregroundColor: OpenApp.ink), onPressed: () { if (controller.text.trim().isNotEmpty) { setState(() { messages.add(controller.text.trim()); controller.clear(); }); } }, icon: const Icon(Icons.arrow_upward_rounded))]),
              ),
            ],
          ),
        ),
      );
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Profil', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
              const SizedBox(height: 22),
              Container(width: double.infinity, padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(30)), child: const Column(children: [CircleAvatar(radius: 48, backgroundColor: Colors.white, child: Icon(Icons.person_rounded, size: 52, color: OpenApp.ink)), SizedBox(height: 14), Text('Senin profilin', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), SizedBox(height: 5), Text('3 kilit sorusu aktif', style: TextStyle(color: OpenApp.muted))])),
              const SizedBox(height: 16),
              ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)), tileColor: OpenApp.soft, leading: const Icon(Icons.lock_outline_rounded), title: const Text('Kilit sorularını düzenle', style: TextStyle(fontWeight: FontWeight.w800)), trailing: const Icon(Icons.chevron_right_rounded)),
              const SizedBox(height: 10),
              ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)), tileColor: OpenApp.soft, leading: const Icon(Icons.settings_outlined), title: const Text('Ayarlar', style: TextStyle(fontWeight: FontWeight.w800)), trailing: const Icon(Icons.chevron_right_rounded)),
            ],
          ),
        ),
      );
}
