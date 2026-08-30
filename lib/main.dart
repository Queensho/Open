import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const OpenApp());

class OpenApp extends StatelessWidget {
  const OpenApp({super.key});
  static const lime = Color(0xFFBFFF00);
  static const ink = Color(0xFF111111);
  static const muted = Color(0xFF707070);
  static const soft = Color(0xFFF6F6F3);
  static const purple = Color(0xFF7C4DFF);
  static const coral = Color(0xFFFF6464);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
}

class AppIcons {
  static const splash = 'assets/app_icons/gradient/splash_logo.svg';
  static const lock = 'assets/app_icons/gradient/icon_lock.svg';
  static const unlock = 'assets/app_icons/gradient/icon_unlock.svg';
  static const key = 'assets/app_icons/gradient/icon_key.svg';
  static const send = 'assets/app_icons/gradient/icon_send.svg';
  static const question = 'assets/app_icons/line/icon_question.svg';
  static const phone = 'assets/app_icons/line/icon_phone.svg';
  static const mail = 'assets/app_icons/line/icon_mail.svg';
  static const camera = 'assets/app_icons/line/icon_camera.svg';
  static const profile = 'assets/app_icons/badge/icon_profile.svg';
  static const navHome = 'assets/app_icons/nav/nav_home.svg';
  static const navHomeActive = 'assets/app_icons/nav/nav_home_active.svg';
  static const navKey = 'assets/app_icons/nav/nav_key.svg';
  static const navKeyActive = 'assets/app_icons/nav/nav_key_active.svg';
  static const navMessages = 'assets/app_icons/nav/nav_messages.svg';
  static const navMessagesActive = 'assets/app_icons/nav/nav_messages_active.svg';
  static const navProfile = 'assets/app_icons/nav/nav_profile.svg';
  static const navProfileActive = 'assets/app_icons/nav/nav_profile_active.svg';
}

class AppSvg extends StatelessWidget {
  const AppSvg(this.path, {super.key, this.size = 64, this.card = false});
  final String path;
  final double size;
  final bool card;

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(path, width: size, height: size, fit: BoxFit.contain);
    if (!card) return SizedBox(width: size, height: size, child: svg);
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * .28),
        boxShadow: [BoxShadow(color: OpenApp.lime.withValues(alpha: .20), blurRadius: 30, spreadRadius: 3, offset: const Offset(0, 8))],
      ),
      child: svg,
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

class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.step, required this.total});
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: step / total,
                minHeight: 7,
                backgroundColor: const Color(0xFFEAEAEA),
                valueColor: const AlwaysStoppedAnimation(OpenApp.lime),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text('$step/$total', style: const TextStyle(fontWeight: FontWeight.w900)),
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
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvg(AppIcons.splash, size: 118, card: true),
              SizedBox(height: 26),
              Text('Open', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900)),
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
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const AppSvg(AppIcons.splash, size: 90, card: true),
                const SizedBox(height: 28),
                const Text('Open', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900)),
                const SizedBox(height: 18),
                const Text('Kaydırma.\nÖnce kilidimi aç.', style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w800)),
                const Spacer(),
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
    ('Profil değil,\ninsanı keşfet.', 'Önce soruları cevapla, sonra karar ver.', AppIcons.lock),
    ('3 kilit soru,\nyüzlerce olasılık.', 'Merak uyandıran sorularla daha anlamlı sohbetler.', AppIcons.question),
    ('Doğru kişiyle\nanahtarın uyusun.', 'Anahtarını gönder. Kabul edilirse profil açılır.', AppIcons.key),
    ('Gerçek bağlantılar\nburada başlar.', 'Daha az yüzeysel, daha çok sen.', AppIcons.unlock),
  ];

  void next() {
    if (page < pages.length - 1) {
      controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
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
                  padding: const EdgeInsets.only(right: 18, top: 4),
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                    child: const Text('Atla', style: TextStyle(color: OpenApp.ink, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (value) => setState(() => page = value),
                  itemBuilder: (_, i) {
                    final item = pages[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(28, 6, 28, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Center(child: AppSvg(item.$3, size: 150, card: true))),
                          Text(item.$1, style: const TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 12),
                          Text(item.$2, style: const TextStyle(color: OpenApp.muted, fontSize: 16, height: 1.4)),
                          const SizedBox(height: 20),
                          FilledButton(onPressed: next, child: const Text('Devam et')),
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const AppSvg(AppIcons.splash, size: 82, card: true),
                const SizedBox(height: 26),
                const Text('Open', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                const Text('Gerçek bağlantılar burada başlar.', style: TextStyle(fontSize: 18, color: OpenApp.muted)),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneLoginScreen())),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [AppSvg(AppIcons.phone, size: 23), SizedBox(width: 10), Text('Telefon ile devam et')]),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), shape: const StadiumBorder()),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [AppSvg(AppIcons.mail, size: 23), SizedBox(width: 10), Text('E-posta ile devam et')]),
                ),
              ],
            ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSvg(AppIcons.phone, size: 76, card: true),
                const SizedBox(height: 26),
                const PageTitle('Telefon numaranı gir.', 'Sana 6 haneli bir doğrulama kodu göndereceğiz.'),
                const SizedBox(height: 28),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]'))],
                  decoration: InputDecoration(prefixText: '+90  ', labelText: 'Telefon numarası', hintText: '5XX XXX XX XX', errorText: error),
                ),
                const SizedBox(height: 12),
                const Text('Şimdilik test doğrulama kodu: 123456', style: TextStyle(color: OpenApp.muted, fontSize: 13)),
                const Spacer(),
                FilledButton(onPressed: sendCode, child: const Text('Onay kodu gönder')),
              ],
            ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSvg(AppIcons.unlock, size: 76, card: true),
                const SizedBox(height: 26),
                PageTitle('Onay kodunu gir.', '+90 ${widget.phone} numarasına gönderilen 6 haneli kodu yaz.'),
                const SizedBox(height: 28),
                TextField(
                  controller: code,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 10),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                  decoration: InputDecoration(counterText: '', hintText: '••••••', errorText: error),
                  onSubmitted: (_) => verify(),
                ),
                const Spacer(),
                FilledButton(onPressed: verify, child: const Text('Doğrula ve devam et')),
              ],
            ),
          ),
        ),
      );
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageTitle('Hesabını aç.', 'E-posta ile kayıt bilgilerini gir, sonra profilini oluştur.'),
                const SizedBox(height: 24),
                const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'E-posta')),
                const SizedBox(height: 14),
                const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Şifre')),
                const SizedBox(height: 24),
                FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProfileScreen())), child: const Text('Kayıt ol ve devam et')),
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
  String gender = 'Kadın';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 4, 26, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(step: 1, total: 2),
                const SizedBox(height: 24),
                const PageTitle('Seni tanıyalım.', 'Profilin kilitli başlayacak. Temel bilgilerini ekle.'),
                const SizedBox(height: 24),
                Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [AppSvg(AppIcons.camera, size: 52), SizedBox(height: 10), Text('Fotoğraf ekle', style: TextStyle(fontWeight: FontWeight.w800))])),
                ),
                const SizedBox(height: 16),
                const TextField(decoration: InputDecoration(labelText: 'Adın')),
                const SizedBox(height: 14),
                const TextField(decoration: InputDecoration(labelText: 'Konum')),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  children: ['Kadın', 'Erkek', 'Belirtmek istemiyorum']
                      .map((item) => ChoiceChip(label: Text(item), selected: gender == item, selectedColor: OpenApp.lime, onSelected: (_) => setState(() => gender = item)))
                      .toList(),
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LockQuestionsScreen())), child: const Text('Kilit sorularına geç')),
              ],
            ),
          ),
        ),
      );
}

class LockQuestionsScreen extends StatefulWidget {
  const LockQuestionsScreen({super.key});
  @override
  State<LockQuestionsScreen> createState() => _LockQuestionsScreenState();
}

class _LockQuestionsScreenState extends State<LockQuestionsScreen> {
  final selected = <int>{};
  final questions = const [
    'Bir pazar sabahı seni nerede bulurum?',
    'Seni güldüren küçük şey ne?',
    'Birine hemen güvenmeni sağlayan şey?',
    'Hayalindeki plansız gün nasıl geçer?',
    'Bir şarkı seni hangi ana götürür?',
    'İlk buluşmada en çok neye dikkat edersin?',
  ];

  void toggle(int i) {
    setState(() {
      if (selected.contains(i)) {
        selected.remove(i);
      } else if (selected.length < 3) {
        selected.add(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 4, 26, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(step: 2, total: 2),
                const SizedBox(height: 24),
                const PageTitle('3 kilit sorunu seç.', 'Seni keşfetmek isteyen kişi önce bu sorulardan birini cevaplayacak.'),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final active = selected.contains(i);
                      return InkWell(
                        onTap: () => toggle(i),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: active ? OpenApp.lime.withValues(alpha: .16) : OpenApp.soft,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: active ? OpenApp.lime : Colors.transparent, width: 2),
                          ),
                          child: Row(children: [Expanded(child: Text(questions[i], style: const TextStyle(fontWeight: FontWeight.w700))), AppSvg(active ? AppIcons.unlock : AppIcons.lock, size: 28)]),
                        ),
                      );
                    },
                  ),
                ),
                FilledButton(
                  onPressed: selected.length == 3 ? () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false) : null,
                  child: Text(selected.length == 3 ? 'Profili tamamla' : '${selected.length}/3 soru seçildi'),
                ),
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
          indicatorColor: OpenApp.lime.withValues(alpha: .25),
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: [
            NavigationDestination(icon: AppSvg(index == 0 ? AppIcons.navHomeActive : AppIcons.navHome, size: 25), label: 'Keşfet'),
            NavigationDestination(icon: AppSvg(index == 1 ? AppIcons.navKeyActive : AppIcons.navKey, size: 25), label: 'Anahtarlar'),
            NavigationDestination(icon: AppSvg(index == 2 ? AppIcons.navMessagesActive : AppIcons.navMessages, size: 25), label: 'Mesajlar'),
            NavigationDestination(icon: AppSvg(index == 3 ? AppIcons.navProfileActive : AppIcons.navProfile, size: 25), label: 'Profil'),
          ],
        ),
      );
}

class LockedProfile {
  const LockedProfile({required this.name, required this.age, required this.location, required this.distance, required this.bio, required this.questions, required this.color, required this.interests});
  final String name;
  final int age;
  final String location;
  final String distance;
  final String bio;
  final List<String> questions;
  final Color color;
  final List<String> interests;
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final profiles = const [
    LockedProfile(
      name: 'Deniz',
      age: 27,
      location: 'Kadıköy',
      distance: '2,4 km',
      bio: 'Kahve, sahil ve uzun yürüyüşler.',
      questions: ['Bir pazar sabahı seni nerede bulurum?', 'Seni güldüren küçük şey ne?', 'Plansız bir günün nasıl geçer?'],
      color: Color(0xFFFFA8B8),
      interests: ['Müzik', 'Seyahat', 'Kahve'],
    ),
    LockedProfile(
      name: 'Ece',
      age: 25,
      location: 'Beşiktaş',
      distance: '4,1 km',
      bio: 'Konser, analog fotoğraf ve yeni şehirler.',
      questions: ['Son anda aldığın en güzel karar neydi?', 'Bir şarkı seni hangi ana götürür?', 'İlk buluşmada en çok neye dikkat edersin?'],
      color: Color(0xFF8F6BD8),
      interests: ['Fotoğraf', 'Konser', 'Tasarım'],
    ),
    LockedProfile(
      name: 'Selin',
      age: 29,
      location: 'Şişli',
      distance: '6,8 km',
      bio: 'İyi yemek, kötü espriler ve spontane planlar.',
      questions: ['Hafta sonu senin için mükemmel nasıl geçer?', 'Birine hemen güvenmeni sağlayan şey?', 'Seni gerçekten heyecanlandıran şey ne?'],
      color: Color(0xFFFFBE18),
      interests: ['Yemek', 'Sinema', 'Gezi'],
    ),
  ];

  int profileIndex = 0;
  LockedProfile get profile => profiles[profileIndex];

  void move(int delta) => setState(() => profileIndex = (profileIndex + delta + profiles.length) % profiles.length);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 700;
          final cardHeight = (constraints.maxHeight * (compact ? .48 : .53)).clamp(330.0, 520.0);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _discoverHeader(),
                const SizedBox(height: 18),
                _discoverTabs(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Text('Sana uygun yeni insanları keşfet 💚', style: TextStyle(fontSize: 22, height: 1.1, fontWeight: FontWeight.w900, letterSpacing: -.4))),
                    _filterButton(),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(height: cardHeight, child: _profileStack(cardHeight)),
                const SizedBox(height: 18),
                _actions(),
                const SizedBox(height: 10),
                const Center(child: Text('Anahtarla kilidi aç', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                const SizedBox(height: 3),
                const Center(child: Text('3 soruyla birbirinizi daha iyi tanıyın', style: TextStyle(color: OpenApp.muted, fontWeight: FontWeight.w600))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _discoverHeader() {
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF91F3C8), Color(0xFF8CD7FF)]),
            borderRadius: BorderRadius.circular(19),
          ),
          child: const AppSvg(AppIcons.profile, size: 42),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Merhaba 👋', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              SizedBox(height: 2),
              Row(children: [Icon(Icons.location_on_rounded, size: 17, color: OpenApp.purple), SizedBox(width: 3), Text('İstanbul', style: TextStyle(color: OpenApp.purple, fontWeight: FontWeight.w800))]),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.notifications_none_rounded, size: 28)),
            const Positioned(right: 6, top: 5, child: CircleAvatar(radius: 5, backgroundColor: Color(0xFFFF4C68))),
          ],
        ),
      ],
    );
  }

  Widget _discoverTabs() {
    const items = [
      (Icons.explore_rounded, 'Keşfet', 0),
      (Icons.favorite_border_rounded, 'Beğenenler', 12),
      (Icons.chat_bubble_outline_rounded, 'Eşleşmeler', 3),
    ];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (_, i) {
          final item = items[i];
          final active = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              gradient: active ? const LinearGradient(colors: [Color(0xFF8F54FF), Color(0xFF6946F5)]) : null,
              color: active ? null : Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: active ? Colors.transparent : const Color(0xFFE8E8EE)),
              boxShadow: active ? [BoxShadow(color: OpenApp.purple.withValues(alpha: .22), blurRadius: 18, offset: const Offset(0, 7))] : null,
            ),
            child: Row(
              children: [
                Icon(item.$1, size: 20, color: active ? Colors.white : OpenApp.muted),
                const SizedBox(width: 7),
                Text(item.$2, style: TextStyle(color: active ? Colors.white : OpenApp.ink, fontWeight: FontWeight.w800)),
                if (item.$3 > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFFF5D72), borderRadius: BorderRadius.circular(99)),
                    child: Text('${item.$3}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _filterButton() => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFE8E8EE))),
        child: const Icon(Icons.tune_rounded),
      );

  Widget _profileStack(double cardHeight) {
    final next = profiles[(profileIndex + 1) % profiles.length];
    final after = profiles[(profileIndex + 2) % profiles.length];
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(top: 18, left: 52, right: 8, bottom: 42, child: Transform.rotate(angle: .05, child: _backCard(after.color))),
        Positioned(top: 30, left: 24, right: 34, bottom: 26, child: Transform.rotate(angle: -.045, child: _backCard(next.color))),
        Positioned.fill(
          top: 42,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity < 0) move(1);
              if (velocity > 0) move(-1);
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: Container(
                key: ValueKey(profileIndex),
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [profile.color, Color.lerp(profile.color, Colors.white, .24)!]),
                  borderRadius: BorderRadius.circular(52),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .16), blurRadius: 32, offset: const Offset(0, 16))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(top: 22, left: 20, child: _onlineChip()),
                      Positioned(top: 18, right: 18, child: Container(width: 44, height: 44, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.auto_awesome_rounded, size: 22))),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppSvg(AppIcons.lock, size: 112, card: true),
                            const SizedBox(height: 14),
                            const Text('Profil kilitli', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 34), child: Text(profile.bio, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(22, 36, 22, 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: .72)]),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [Flexible(child: Text('${profile.name}, ${profile.age}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900))), const SizedBox(width: 7), const Icon(Icons.verified_rounded, color: Color(0xFF58A5FF), size: 24)]),
                              const SizedBox(height: 5),
                              Row(children: [const Icon(Icons.location_on_rounded, color: Colors.white70, size: 18), const SizedBox(width: 3), Text(profile.location, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), const SizedBox(width: 9), _distanceChip(profile.distance)]),
                              const SizedBox(height: 11),
                              Wrap(spacing: 7, runSpacing: 7, children: profile.interests.map(_interestChip).toList()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _backCard(Color color) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, Color.lerp(color, Colors.white, .24)!]),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [BoxShadow(color: color.withValues(alpha: .25), blurRadius: 20, offset: const Offset(0, 10))],
        ),
      );

  Widget _onlineChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .88), borderRadius: BorderRadius.circular(99)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [CircleAvatar(radius: 4, backgroundColor: Color(0xFF60E15A)), SizedBox(width: 7), Text('Çevrimiçi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800))]),
      );

  Widget _distanceChip(String distance) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: OpenApp.purple.withValues(alpha: .76), borderRadius: BorderRadius.circular(99)),
        child: Text('$distance uzakta', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
      );

  Widget _interestChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(99), border: Border.all(color: Colors.white24)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
      );

  Widget _actions() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RoundAction(color: Colors.white, icon: Icons.close_rounded, iconColor: OpenApp.coral, onTap: () => move(1)),
          const SizedBox(width: 18),
          _RoundAction(color: OpenApp.lime, size: 84, glow: true, onTap: () => _showQuestions(context), child: const AppSvg(AppIcons.key, size: 38)),
          const SizedBox(width: 18),
          _RoundAction(color: Colors.white, icon: Icons.favorite_rounded, iconColor: OpenApp.purple, onTap: () => move(1)),
        ],
      );

  void _showQuestions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 30),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(34))),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 44, height: 5, decoration: BoxDecoration(color: const Color(0xFFD8D8D8), borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text('${profile.name} için bir kilit sorusu seç', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
              const SizedBox(height: 18),
              for (final question in profile.questions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AnswerScreen(profile: profile, question: question)));
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(20)),
                      child: Row(children: [const AppSvg(AppIcons.question, size: 26), const SizedBox(width: 12), Expanded(child: Text(question, style: const TextStyle(fontWeight: FontWeight.w700))), const Icon(Icons.chevron_right_rounded)]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.color, required this.onTap, this.icon, this.child, this.iconColor = Colors.white, this.size = 72, this.glow = false});
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? child;
  final Color iconColor;
  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: glow ? OpenApp.lime.withValues(alpha: .42) : Colors.black.withValues(alpha: .10), blurRadius: glow ? 28 : 14, spreadRadius: glow ? 5 : 0, offset: const Offset(0, 8)),
          ],
        ),
        child: Material(
          color: color,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(width: size, height: size, child: Center(child: child ?? Icon(icon, size: 38, color: iconColor))),
          ),
        ),
      );
}

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key, required this.profile, required this.question});
  final LockedProfile profile;
  final String question;
  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final answer = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSvg(AppIcons.question, size: 70, card: true),
                const SizedBox(height: 20),
                Text('${widget.profile.name} için anahtarını oluştur.', style: const TextStyle(fontSize: 30, height: 1.05, fontWeight: FontWeight.w900)),
                const SizedBox(height: 22),
                Container(width: double.infinity, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(20)), child: Text(widget.question, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
                const SizedBox(height: 14),
                TextField(controller: answer, maxLines: 5, maxLength: 250, decoration: const InputDecoration(hintText: 'Cevabını yaz...')),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KeySentScreen(name: widget.profile.name))),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [AppSvg(AppIcons.key, size: 26), SizedBox(width: 10), Text('Anahtarı gönder')]),
                ),
              ],
            ),
          ),
        ),
      );
}

class KeySentScreen extends StatelessWidget {
  const KeySentScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppSvg(AppIcons.key, size: 150, card: true),
                const SizedBox(height: 24),
                const Text('Anahtar gönderildi!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Text('$name cevabını gördüğünde anahtarını kabul edebilir.', textAlign: TextAlign.center),
                const SizedBox(height: 30),
                FilledButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false), child: const Text('Keşfete dön')),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle('Anahtarlar', 'Sana gelen cevaplar burada.'),
              const SizedBox(height: 24),
              for (final item in const [('Ece', '“Kahve, sahil ve uzun bir yürüyüş.”'), ('Selin', '“Bence iyi bir gün plansız başlayandır.”')])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(22)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: const AppSvg(AppIcons.key, size: 46),
                      title: Text('${item.$1} sana bir anahtar gönderdi', style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(item.$2),
                      trailing: FilledButton(
                        style: FilledButton.styleFrom(minimumSize: const Size(72, 44), padding: const EdgeInsets.symmetric(horizontal: 18)),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MatchScreen(name: item.$1))),
                        child: const Text('Aç'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppSvg(AppIcons.unlock, size: 160, card: true),
                const SizedBox(height: 24),
                const Text('Kilit açıldı.', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Text('$name ile artık birbirinizi görebilir ve konuşabilirsiniz.', textAlign: TextAlign.center),
                const SizedBox(height: 28),
                FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(name: name))), child: const Text('Mesaj gönder')),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle('Mesajlar', 'Kilidi açılan bağlantıların.'),
              const SizedBox(height: 24),
              for (final name in const ['Ece', 'Selin'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(22)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(name: name))),
                      leading: const AppSvg(AppIcons.profile, size: 48),
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: const Text('Selam 👋'),
                    ),
                  ),
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
  final input = TextEditingController();
  final messages = <String>[];

  void send() {
    final value = input.text.trim();
    if (value.isEmpty) return;
    setState(() => messages.add(value));
    input.clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.name)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(18)), child: const Text('Selam! Cevabını sevdim 😊')),
                      ),
                      ...messages.map((message) => Align(alignment: Alignment.centerRight, child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: OpenApp.lime, borderRadius: BorderRadius.circular(18)), child: Text(message)))),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: TextField(controller: input, onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'Mesaj yaz...'))),
                    const SizedBox(width: 10),
                    SizedBox(width: 54, height: 54, child: FilledButton(onPressed: send, style: FilledButton.styleFrom(padding: EdgeInsets.zero, shape: const CircleBorder()), child: const AppSvg(AppIcons.send, size: 26))),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle('Profilin', 'Kilit sorularını ve profilini buradan yönet.'),
              SizedBox(height: 28),
              AppSvg(AppIcons.profile, size: 110, card: true),
              SizedBox(height: 18),
              Text('Profil hazır', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              Text('3 kilit sorusu aktif', style: TextStyle(color: OpenApp.muted)),
            ],
          ),
        ),
      );
}
