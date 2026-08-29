import 'package:flutter/material.dart';

void main() => runApp(const OpenApp());

class OpenApp extends StatelessWidget {
  const OpenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC9FF3D),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8F6),
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
                  color: const Color(0xFF111217),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.lock_open_rounded,
                    color: Color(0xFFC9FF3D), size: 38),
              ),
              const SizedBox(height: 28),
              const Text('Open',
                  style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              const Text(
                'Kaydırma.\nÖnce kilidimi aç.',
                style: TextStyle(fontSize: 28, height: 1.15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Text(
                'Bir fotoğraftan fazlasını keşfet. Soruyu cevapla, profili aç ve gerçek bir bağlantı kur.',
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey.shade700),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC9FF3D),
                    foregroundColor: const Color(0xFF111217),
                  ),
                  onPressed: () {},
                  child: const Text('Başlayalım',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
