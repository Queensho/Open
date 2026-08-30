import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/open_backend.dart';

const lime = Color(0xFFBFFF00);
const ink = Color(0xFF111111);

class OpenConnectedApp extends StatelessWidget {
  const OpenConnectedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: lime),
      ),
      home: OpenBackend.instance.isAuthenticated
          ? const HomeShell()
          : const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();
  bool register = true;
  bool phoneMode = false;
  bool codeSent = false;
  bool busy = false;
  String? error;

  Future<void> emailSubmit() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final response = register
          ? await OpenBackend.instance.registerEmail(email.text, password.text)
          : await OpenBackend.instance.loginEmail(email.text, password.text);
      if (!mounted) return;
      if (response.session == null) {
        setState(() {
          error = 'E-posta doğrulaması gerekiyorsa gelen kutunu kontrol et.';
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileSetup()),
        );
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void phoneSubmit() {
    if (!codeSent) {
      setState(() {
        codeSent = true;
        error = null;
      });
      return;
    }
    if (otp.text.trim() != '123456') {
      setState(() => error = 'Test kodu: 123456');
      return;
    }
    setState(() {
      error = 'Mock SMS doğrulandı. Gerçek veriler için e-posta ile giriş yap.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(28),
          children: [
            const SizedBox(height: 60),
            const Icon(Icons.lock_open_rounded, size: 72),
            const Text(
              'Open',
              style: TextStyle(fontSize: 46, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            if (phoneMode) ...[
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefon numarası'),
              ),
              if (codeSent)
                TextField(
                  controller: otp,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Onay kodu'),
                ),
              FilledButton(
                onPressed: phoneSubmit,
                child: Text(codeSent ? 'Doğrula' : 'Kod gönder'),
              ),
            ] else ...[
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-posta'),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Şifre'),
              ),
              FilledButton(
                onPressed: busy ? null : emailSubmit,
                child: Text(register ? 'Kayıt ol' : 'Giriş yap'),
              ),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(error!),
              ),
            TextButton(
              onPressed: () => setState(() => phoneMode = !phoneMode),
              child: Text(
                phoneMode ? 'E-posta ile devam et' : 'Telefon ile devam et (mock)',
              ),
            ),
            if (!phoneMode)
              TextButton(
                onPressed: () => setState(() => register = !register),
                child: Text(register ? 'Giriş yap' : 'Kayıt ol'),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final name = TextEditingController();
  final city = TextEditingController();
  String gender = 'Kadın';

  Future<void> next() async {
    if (name.text.trim().isEmpty || city.text.trim().isEmpty) return;
    await OpenBackend.instance.saveProfile(name.text, city.text, gender);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const QuestionSetup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Seni tanıyalım',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
          ),
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Adın'),
          ),
          TextField(
            controller: city,
            decoration: const InputDecoration(labelText: 'Şehir'),
          ),
          Wrap(
            spacing: 8,
            children: ['Kadın', 'Erkek', 'Belirtmek istemiyorum']
                .map(
                  (value) => ChoiceChip(
                    label: Text(value),
                    selected: gender == value,
                    onSelected: (_) => setState(() => gender = value),
                  ),
                )
                .toList(),
          ),
          FilledButton(onPressed: next, child: const Text('Devam et')),
        ],
      ),
    );
  }
}

class QuestionSetup extends StatefulWidget {
  const QuestionSetup({super.key});

  @override
  State<QuestionSetup> createState() => _QuestionSetupState();
}

class _QuestionSetupState extends State<QuestionSetup> {
  final chosen = <int>{};
  final questions = const [
    'Bir pazar sabahı seni nerede bulurum?',
    'Seni güldüren küçük şey ne?',
    'Birine hemen güvenmeni sağlayan şey?',
    'Hayalindeki plansız gün nasıl geçer?',
    'Bir şarkı seni hangi ana götürür?',
    'İlk buluşmada en çok neye dikkat edersin?',
  ];

  Future<void> save() async {
    await OpenBackend.instance.saveLockQuestions(
      chosen.map((index) => questions[index]).toList(),
    );
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '3 kilit sorusu seç',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (_, index) => CheckboxListTile(
                value: chosen.contains(index),
                title: Text(questions[index]),
                onChanged: (_) {
                  setState(() {
                    if (chosen.contains(index)) {
                      chosen.remove(index);
                    } else if (chosen.length < 3) {
                      chosen.add(index);
                    }
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
              onPressed: chosen.length == 3 ? save : null,
              child: Text('${chosen.length}/3 · Tamamla'),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DiscoverScreen(),
      const KeysScreen(),
      const MatchesScreen(),
      const AccountScreen(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'Keşfet'),
          NavigationDestination(icon: Icon(Icons.key), label: 'Anahtarlar'),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Mesajlar',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Future<List<Map<String, dynamic>>> data;
  int index = 0;

  @override
  void initState() {
    super.initState();
    data = OpenBackend.instance.discover();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: data,
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          final rows = snapshot.data ?? [];
          if (rows.isEmpty) {
            return const Center(child: Text('Henüz keşfedilecek profil yok.'));
          }
          final profile = rows[index % rows.length];
          final questions = List<Map<String, dynamic>>.from(
            profile['profile_questions'] ?? const [],
          );
          return Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keşfet ✨',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ink,
                      borderRadius: BorderRadius.circular(40),
                      image: profile['avatar_url'] != null
                          ? DecorationImage(
                              image: NetworkImage(profile['avatar_url'] as String),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${profile['display_name']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${profile['city'] ?? ''}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => setState(() => index++),
                      icon: const Icon(Icons.close),
                    ),
                    IconButton.filled(
                      onPressed: questions.isEmpty
                          ? null
                          : () => showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => KeySheet(
                                  profile: profile,
                                  questions: questions,
                                ),
                              ),
                      style: IconButton.styleFrom(
                        backgroundColor: lime,
                        foregroundColor: ink,
                      ),
                      icon: const Icon(Icons.key),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class KeySheet extends StatefulWidget {
  const KeySheet({super.key, required this.profile, required this.questions});
  final Map<String, dynamic> profile;
  final List<Map<String, dynamic>> questions;

  @override
  State<KeySheet> createState() => _KeySheetState();
}

class _KeySheetState extends State<KeySheet> {
  int selected = 0;
  final answer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            widget.questions.length,
            (index) => ListTile(
              title: Text('${widget.questions[index]['question']}'),
              leading: Icon(
                index == selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              onTap: () => setState(() => selected = index),
            ),
          ),
          TextField(
            controller: answer,
            decoration: const InputDecoration(labelText: 'Cevabın'),
          ),
          FilledButton(
            onPressed: () async {
              if (answer.text.trim().isEmpty) return;
              await OpenBackend.instance.sendKey(
                widget.profile['id'] as String,
                widget.questions[selected]['id'] as String,
                answer.text,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Anahtarı gönder'),
          ),
        ],
      ),
    );
  }
}

class KeysScreen extends StatefulWidget {
  const KeysScreen({super.key});

  @override
  State<KeysScreen> createState() => _KeysScreenState();
}

class _KeysScreenState extends State<KeysScreen> {
  late Future<List<Map<String, dynamic>>> data;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    data = OpenBackend.instance.incomingKeys();
  }

  void reload() {
    setState(load);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: data,
        builder: (_, snapshot) {
          final rows = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const Text(
                'Anahtarlar',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
              ),
              if (snapshot.connectionState != ConnectionState.done)
                const Center(child: CircularProgressIndicator()),
              if (snapshot.hasError) Text('Hata: ${snapshot.error}'),
              ...rows.map(
                (row) => Card(
                  child: ListTile(
                    title: Text('${row['answer']}'),
                    subtitle: Text('${row['status']}'),
                    trailing: row['status'] == 'pending'
                        ? Wrap(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await OpenBackend.instance.rejectKey(
                                    row['id'] as String,
                                  );
                                  reload();
                                },
                                icon: const Icon(Icons.close),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await OpenBackend.instance.acceptKey(
                                    row['id'] as String,
                                  );
                                  reload();
                                },
                                icon: const Icon(Icons.check),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: OpenBackend.instance.activeMatches(),
        builder: (_, snapshot) {
          final rows = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const Text(
                'Mesajlar',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
              ),
              if (snapshot.connectionState != ConnectionState.done)
                const Center(child: CircularProgressIndicator()),
              if (snapshot.hasError) Text('Hata: ${snapshot.error}'),
              ...rows.map(
                (match) => ListTile(
                  title: const Text('Eşleşme'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(matchId: match['id'] as String),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.matchId});
  final String matchId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sohbet')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: OpenBackend.instance.messageStream(widget.matchId),
              builder: (_, snapshot) {
                final rows = snapshot.data ?? [];
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: rows
                      .map(
                        (message) => Align(
                          alignment: message['sender_id'] ==
                                  OpenBackend.instance.userId
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Chip(label: Text('${message['body']}')),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(child: TextField(controller: text)),
                IconButton(
                  onPressed: () async {
                    await OpenBackend.instance.sendMessage(
                      widget.matchId,
                      text.text,
                    );
                    text.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
            ),
            Text(
              Supabase.instance.client.auth.currentUser?.email ??
                  'Open kullanıcısı',
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (_) => false,
                );
              },
              child: const Text('Çıkış yap'),
            ),
          ],
        ),
      ),
    );
  }
}
