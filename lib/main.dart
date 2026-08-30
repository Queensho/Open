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
        boxShadow: [
          BoxShadow(
            color: OpenApp.lime.withValues(alpha: .20),
            blurRadius: 30,
            spreadRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 34,
              height: 1.05,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 15.5, height: 1.45, color: OpenApp.muted),
          ),
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
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
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
                const Text(
                  'Kaydırma.\nÖnce kilidimi aç.',
                  style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  ),
                  child: const Text('Başlayalım'),
                ),
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
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
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
                    final p = pages[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(28, 6, 28, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Center(child: AppSvg(p.$3, size: 150, card: true))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: OpenApp.lime, borderRadius: BorderRadius.circular(18)),
                            child: Text('0${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(height: 18),
                          Text(p.$1, style: const TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 12),
                          Text(p.$2, style: const TextStyle(color: OpenApp.muted, fontSize: 16, height: 1.4)),
                          const SizedBox(height: 20),
                          Row(
                            children: List.generate(
                              pages.length,
                              (d) => AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                margin: const EdgeInsets.only(right: 7),
                                width: d == page ? 28 : 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: d == page ? OpenApp.lime : const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSvg(AppIcons.phone, size: 23),
                      SizedBox(width: 10),
                      Text('Telefon ile devam et'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), shape: const StadiumBorder()),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSvg(AppIcons.mail, size: 23),
                      SizedBox(width: 10),
                      Text('E-posta ile devam et'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                  decoration: InputDecoration(
                    prefixText: '+90  ',
                    labelText: 'Telefon numarası',
                    hintText: '5XX XXX XX XX',
                    errorText: error,
                  ),
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
                const SizedBox(height: 14),
                Center(child: TextButton(onPressed: () => setState(() => error = null), child: const Text('Kodu tekrar gönder'))),
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
                const AppSvg(AppIcons.unlock, size: 72, card: true),
                const SizedBox(height: 24),
                const PageTitle('Hesabını aç.', 'E-posta ile kayıt bilgilerini gir, sonra profilini oluştur.'),
                const SizedBox(height: 24),
                const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'E-posta')),
                const SizedBox(height: 14),
                const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Şifre')),
                const SizedBox(height: 14),
                const TextField(decoration: InputDecoration(labelText: 'Doğum yılı')),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProfileScreen())),
                  child: const Text('Kayıt ol ve devam et'),
                ),
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
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSvg(AppIcons.camera, size: 52),
                        SizedBox(height: 10),
                        Text('Fotoğraf ekle', style: TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(decoration: InputDecoration(labelText: 'Adın')),
                const SizedBox(height: 14),
                const TextField(keyboardType: TextInputType.datetime, decoration: InputDecoration(labelText: 'Doğum tarihi', hintText: 'GG/AA/YYYY')),
                const SizedBox(height: 14),
                const TextField(decoration: InputDecoration(labelText: 'Konum', hintText: 'İstanbul')),
                const SizedBox(height: 18),
                const Text('Cinsiyet', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['Kadın', 'Erkek', 'Belirtmek istemiyorum']
                      .map(
                        (item) => ChoiceChip(
                          label: Text(item),
                          selected: gender == item,
                          selectedColor: OpenApp.lime,
                          onSelected: (_) => setState(() => gender = item),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 18),
                const TextField(maxLines: 3, decoration: InputDecoration(labelText: 'Kısa bio', hintText: 'Seni bir cümlede anlat...')),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LockQuestionsScreen())),
                  child: const Text('Kilit sorularına geç'),
                ),
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
                          child: Row(
                            children: [
                              Expanded(child: Text(questions[i], style: const TextStyle(fontWeight: FontWeight.w700))),
                              const SizedBox(width: 12),
                              AppSvg(active ? AppIcons.unlock : AppIcons.lock, size: 28),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: selected.length == 3
                      ? () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false)
                      : null,
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
            NavigationDestination(
              icon: AppSvg(index == 0 ? AppIcons.navHomeActive : AppIcons.navHome, size: 25),
              label: 'Keşfet',
            ),
            NavigationDestination(
              icon: AppSvg(index == 1 ? AppIcons.navKeyActive : AppIcons.navKey, size: 25),
              label: 'Anahtarlar',
            ),
            NavigationDestination(
              icon: AppSvg(index == 2 ? AppIcons.navMessagesActive : AppIcons.navMessages, size: 25),
              label: 'Mesajlar',
            ),
            NavigationDestination(
              icon: AppSvg(index == 3 ? AppIcons.navProfileActive : AppIcons.navProfile, size: 25),
              label: 'Profil',
            ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle('Keşfet', 'Fotoğraf kilitli. Önce soruyu cevapla.'),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    const AppSvg(AppIcons.lock, size: 150, card: true),
                    const SizedBox(height: 18),
                    const Text('Deniz, 27', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('“Bir pazar sabahı seni nerede bulurum?”', textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnswerScreen())),
                      child: const Text('Soruyu cevapla'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
}

class AnswerScreen extends StatelessWidget {
  const AnswerScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSvg(AppIcons.question, size: 70, card: true),
              const SizedBox(height: 22),
              const PageTitle('Anahtarını kazan.', 'Soruyu samimi şekilde cevapla.'),
              const SizedBox(height: 24),
              const TextField(maxLines: 5, decoration: InputDecoration(hintText: 'Cevabını yaz...')),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const KeySentScreen())),
                child: const Text('Anahtarı gönder'),
              ),
            ],
          ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppSvg(AppIcons.key, size: 150, card: true),
                const SizedBox(height: 24),
                const Text('Anahtar gönderildi!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                const Text('Karşı taraf kabul ederse profil açılacak.', textAlign: TextAlign.center),
                const SizedBox(height: 30),
                FilledButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false),
                  child: const Text('Keşfete dön'),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle('Anahtarlar', 'Sana gelen cevaplar burada.'),
              const SizedBox(height: 28),
              Card(
                elevation: 0,
                color: OpenApp.soft,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: const AppSvg(AppIcons.key, size: 48),
                  title: const Text('Ece sana bir anahtar gönderdi', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: const Text('“Kahve, sahil ve uzun bir yürüyüş.”'),
                  trailing: FilledButton(
                    style: FilledButton.styleFrom(minimumSize: const Size(72, 44), padding: const EdgeInsets.symmetric(horizontal: 18)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen())),
                    child: const Text('Aç'),
                  ),
                ),
              ),
            ],
          ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppSvg(AppIcons.unlock, size: 160, card: true),
                const SizedBox(height: 24),
                const Text('Kilit açıldı.', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                const Text('Artık birbirinizi görebilir ve konuşabilirsiniz.', textAlign: TextAlign.center),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                  child: const Text('Mesaj gönder'),
                ),
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
              Container(
                decoration: BoxDecoration(color: OpenApp.soft, borderRadius: BorderRadius.circular(22)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                  leading: const AppSvg(AppIcons.profile, size: 48),
                  title: const Text('Ece', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: const Text('Selam 👋'),
                ),
              ),
            ],
          ),
        ),
      );
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Ece')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    elevation: 0,
                    color: OpenApp.soft,
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('Selam! Cevabını sevdim 😊'),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Mesaj yaz...'))),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(padding: EdgeInsets.zero, shape: const CircleBorder()),
                      child: const AppSvg(AppIcons.send, size: 26),
                    ),
                  ),
                ],
              ),
            ],
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
              Text('Tayfun', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              Text('3 kilit sorusu aktif', style: TextStyle(color: OpenApp.muted)),
            ],
          ),
        ),
      );
}
