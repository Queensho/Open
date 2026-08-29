import 'package:flutter/material.dart';

void main() => runApp(const OpenApp());

class OpenApp extends StatelessWidget {
  const OpenApp({super.key});

  static const lime = Color(0xFFC9FF3D);
  static const ink = Color(0xFF111217);
  static const bg = Color(0xFFF8F8F6);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: lime,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: bg,
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: OpenApp.ink,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.lock_open_rounded,
                  color: OpenApp.lime,
                  size: 38,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Open',
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kaydırma.\nÖnce kilidimi aç.',
                style: TextStyle(
                  fontSize: 28,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bir fotoğraftan fazlasını keşfet. Soruyu cevapla, profili aç ve gerçek bir bağlantı kur.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: OpenApp.lime,
                    foregroundColor: OpenApp.ink,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LockSetupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Başlayalım',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
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

class LockSetupScreen extends StatelessWidget {
  const LockSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: OpenApp.ink,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.key_rounded,
                  color: OpenApp.lime,
                  size: 30,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Profilinin kilidini\nsoruların belirlesin.',
                style: TextStyle(
                  fontSize: 32,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Seni görmek isteyen biri önce seçtiğin sorulardan birini cevaplayacak.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.45,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 32),
              const _QuestionCard(
                number: '01',
                text: 'Sence iyi bir ilk buluşma nasıl olmalı?',
              ),
              const SizedBox(height: 12),
              const _QuestionCard(
                number: '02',
                text: 'Bir insanda seni en hızlı etkileyen şey ne?',
              ),
              const SizedBox(height: 12),
              const _QuestionCard(
                number: '03',
                text: 'Şu an birlikte yapabileceğimiz en spontane şey ne?',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: OpenApp.ink,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DiscoverDemoScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Devam et',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
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

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7E7E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: OpenApp.lime,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              number,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverDemoScreen extends StatelessWidget {
  const DiscoverDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Keşfet',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                  ),
                  CircleAvatar(
                    backgroundColor: OpenApp.ink,
                    child: Icon(Icons.person_rounded, color: OpenApp.lime),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: OpenApp.ink,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text('KİLİTLİ'),
                              backgroundColor: OpenApp.lime,
                            ),
                            Icon(Icons.lock_rounded, color: Colors.white),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          'Fotoğraf henüz kilitli',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .55),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Deniz, 27',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Text(
                            '“Bir insanda seni en hızlı etkileyen şey ne?”',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              height: 1.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: OpenApp.lime,
                              foregroundColor: OpenApp.ink,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cevap ekranı sıradaki adımda eklenecek.'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.key_rounded),
                            label: const Text(
                              'Kilidi açmayı dene',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
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
