import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'data/open_backend.dart';
import 'main.dart' as ui;

class RealKeysScreen extends StatefulWidget {
  const RealKeysScreen({super.key});

  @override
  State<RealKeysScreen> createState() => _RealKeysScreenState();
}

class _RealKeysScreenState extends State<RealKeysScreen> {
  late Future<List<Map<String, dynamic>>> future;
  String? busyId;

  @override
  void initState() {
    super.initState();
    future = OpenBackend.instance.incomingKeys();
  }

  void reload() => setState(() {
        future = OpenBackend.instance.incomingKeys();
      });

  Future<void> accept(Map<String, dynamic> item) async {
    final id = item['id'].toString();
    if (busyId != null) return;
    setState(() => busyId = id);

    try {
      final matchId = await OpenBackend.instance.acceptKey(id);
      if (!mounted) return;

      final senderId = item['sender_id']?.toString();
      Map<String, dynamic> sender = item['profiles'] is Map
          ? Map<String, dynamic>.from(item['profiles'])
          : <String, dynamic>{};

      if (senderId != null && senderId.isNotEmpty) {
        final profile = await OpenBackend.instance.client
            .from('profiles')
            .select('id,display_name,avatar_url,city')
            .eq('id', senderId)
            .maybeSingle();
        if (profile != null) sender = Map<String, dynamic>.from(profile);
      }

      if (!mounted) return;

      await Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder<void>(
          opaque: true,
          fullscreenDialog: true,
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 240),
          pageBuilder: (_, __, ___) => RealMatchScreen(
            matchId: matchId,
            otherProfile: sender,
          ),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: .97, end: 1).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );

      if (mounted) reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kabul edilemedi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => busyId = null);
    }
  }

  Future<void> reject(String id) async {
    if (busyId != null) return;
    setState(() => busyId = id);
    try {
      await OpenBackend.instance.rejectKey(id);
      if (mounted) reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reddedilemedi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: ui.PageTitle(
                    'Anahtarlar',
                    'Sana gelen cevapları değerlendir.',
                  ),
                ),
                IconButton(
                  onPressed: reload,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _EmptyState(
                      title: 'Anahtarlar yüklenemedi',
                      subtitle: '${snapshot.error}',
                      onTap: reload,
                    );
                  }

                  final items = snapshot.data ?? const <Map<String, dynamic>>[];
                  if (items.isEmpty) {
                    return _EmptyState(
                      title: 'Henüz anahtar yok.',
                      subtitle: 'Biri sorularından birini cevapladığında burada göreceksin.',
                      onTap: reload,
                    );
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final sender = item['profiles'] is Map
                          ? Map<String, dynamic>.from(item['profiles'])
                          : <String, dynamic>{};
                      final question = item['profile_questions'] is Map
                          ? Map<String, dynamic>.from(item['profile_questions'])
                          : <String, dynamic>{};
                      final status = (item['status'] ?? 'pending').toString();
                      final id = item['id'].toString();
                      final pending = status == 'pending';
                      final loading = busyId == id;

                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: ui.OpenApp.soft,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: ui.AppSvg(ui.AppIcons.key, size: 26),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    (sender['display_name'] ?? 'Open kullanıcısı').toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Text(
                                  _statusText(status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: pending ? ui.OpenApp.ink : ui.OpenApp.muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              (question['question'] ?? 'Kilit sorusu').toString(),
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '“${(item['answer'] ?? '').toString()}”',
                              style: const TextStyle(fontSize: 16, height: 1.35),
                            ),
                            if (pending) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: loading ? null : () => reject(id),
                                      child: const Text('Reddet'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: loading ? null : () => accept(item),
                                      child: Text(loading ? 'Açılıyor...' : 'Kabul et'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Kabul edildi';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Bekliyor';
    }
  }
}

class RealMatchScreen extends StatefulWidget {
  const RealMatchScreen({
    super.key,
    required this.matchId,
    required this.otherProfile,
  });

  final String matchId;
  final Map<String, dynamic> otherProfile;

  @override
  State<RealMatchScreen> createState() => _RealMatchScreenState();
}

class _RealMatchScreenState extends State<RealMatchScreen>
    with TickerProviderStateMixin {
  late final AnimationController introController;
  late final AnimationController confettiController;
  late final Animation<double> titleFade;
  late final Animation<double> avatarsScale;
  late final Animation<double> buttonsFade;
  late final Animation<double> lockPulse;

  bool unlocked = false;
  Map<String, dynamic> myProfile = const {};

  @override
  void initState() {
    super.initState();

    introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1650),
    );
    confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    titleFade = CurvedAnimation(
      parent: introController,
      curve: const Interval(0, .28, curve: Curves.easeOut),
    );
    avatarsScale = CurvedAnimation(
      parent: introController,
      curve: const Interval(.15, .58, curve: Curves.elasticOut),
    );
    buttonsFade = CurvedAnimation(
      parent: introController,
      curve: const Interval(.62, 1, curve: Curves.easeOut),
    );
    lockPulse = Tween<double>(begin: .82, end: 1).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(.28, .70, curve: Curves.elasticOut),
      ),
    );

    _loadMine();
    introController.forward();

    Future.delayed(const Duration(milliseconds: 720), () {
      if (!mounted) return;
      setState(() => unlocked = true);
    });
  }

  Future<void> _loadMine() async {
    final id = OpenBackend.instance.userId;
    if (id == null) return;
    final profile = await OpenBackend.instance.client
        .from('profiles')
        .select('id,display_name,avatar_url')
        .eq('id', id)
        .maybeSingle();
    if (mounted && profile != null) {
      setState(() => myProfile = Map<String, dynamic>.from(profile));
    }
  }

  @override
  void dispose() {
    introController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherName = (widget.otherProfile['display_name'] ?? 'Yeni eşleşme').toString();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: confettiController,
                  builder: (_, __) => CustomPaint(
                    painter: _CelebrationPainter(
                      progress: confettiController.value,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    FadeTransition(
                      opacity: titleFade,
                      child: const Text(
                        'Eşleştiniz!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 46,
                          height: 1,
                          letterSpacing: -1.8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: titleFade,
                      child: Text(
                        'Artık birbirinizi daha yakından\ntanıyabilirsiniz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.35,
                          color: ui.OpenApp.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    ScaleTransition(
                      scale: avatarsScale,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _MatchAvatar(profile: myProfile),
                          const SizedBox(width: 8),
                          ScaleTransition(
                            scale: lockPulse,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 380),
                              curve: Curves.easeOutBack,
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                color: ui.OpenApp.lime,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: ui.OpenApp.lime.withValues(
                                      alpha: unlocked ? .46 : .18,
                                    ),
                                    blurRadius: unlocked ? 38 : 14,
                                    spreadRadius: unlocked ? 8 : 2,
                                  ),
                                ],
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 420),
                                transitionBuilder: (child, animation) {
                                  return RotationTransition(
                                    turns: Tween<double>(begin: -.08, end: 0)
                                        .animate(animation),
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Icon(
                                  unlocked
                                      ? Icons.lock_open_rounded
                                      : Icons.lock_rounded,
                                  key: ValueKey(unlocked),
                                  size: 54,
                                  color: ui.OpenApp.ink,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _MatchAvatar(profile: widget.otherProfile),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    FadeTransition(
                      opacity: buttonsFade,
                      child: Text(
                        '$otherName ile kilit açıldı 🔓',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    FadeTransition(
                      opacity: buttonsFade,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RealChatScreen(
                                      matchId: widget.matchId,
                                      profile: widget.otherProfile,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Mesaj gönder'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(58),
                                shape: const StadiumBorder(),
                                foregroundColor: ui.OpenApp.ink,
                                side: BorderSide(
                                  color: Colors.black.withValues(alpha: .15),
                                ),
                              ),
                              child: const Text(
                                'Keşfe devam et',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchAvatar extends StatelessWidget {
  const _MatchAvatar({required this.profile});

  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    final avatar = profile['avatar_url']?.toString();
    final hasAvatar = avatar != null && avatar.isNotEmpty;

    return Container(
      width: 110,
      height: 110,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ui.OpenApp.lime, width: 2),
        boxShadow: [
          BoxShadow(
            color: ui.OpenApp.lime.withValues(alpha: .26),
            blurRadius: 24,
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: ui.OpenApp.soft,
        backgroundImage: hasAvatar ? NetworkImage(avatar) : null,
        child: hasAvatar
            ? null
            : const Icon(
                Icons.person_rounded,
                size: 48,
                color: ui.OpenApp.ink,
              ),
      ),
    );
  }
}

class _CelebrationPainter extends CustomPainter {
  _CelebrationPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final lime = Paint()..color = ui.OpenApp.lime.withValues(alpha: .74);
    final gold = Paint()..color = const Color(0xFFE8D36F).withValues(alpha: .58);

    const points = [
      (.08, .26, 2.4),
      (.17, .34, 3.0),
      (.29, .28, 2.2),
      (.39, .39, 2.4),
      (.67, .31, 2.2),
      (.78, .23, 2.8),
      (.90, .34, 3.0),
      (.13, .58, 2.4),
      (.25, .67, 2.0),
      (.74, .65, 2.5),
      (.88, .57, 2.0),
      (.55, .72, 2.4),
    ];

    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      final wave = math.sin((progress * math.pi * 2) + i) * 9;
      final center = Offset(
        size.width * p.$1,
        size.height * p.$2 + wave,
      );
      canvas.drawCircle(center, p.$3, i.isEven ? lime : gold);
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class RealMessagesScreen extends StatefulWidget {
  const RealMessagesScreen({super.key});

  @override
  State<RealMessagesScreen> createState() => _RealMessagesScreenState();
}

class _RealMessagesScreenState extends State<RealMessagesScreen> {
  late Future<List<Map<String, dynamic>>> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final matches = await OpenBackend.instance.activeMatches();
    final me = OpenBackend.instance.userId;
    final result = <Map<String, dynamic>>[];

    for (final match in matches) {
      final otherId = match['user_a'] == me ? match['user_b'] : match['user_a'];
      final profile = await OpenBackend.instance.client
          .from('profiles')
          .select('id,display_name,avatar_url,city')
          .eq('id', otherId)
          .maybeSingle();
      result.add({...match, 'other_profile': profile});
    }

    return result;
  }

  void reload() => setState(() => future = _load());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: ui.PageTitle(
                    'Mesajlar',
                    'Eşleştiğin kişilerle konuş.',
                  ),
                ),
                IconButton(
                  onPressed: reload,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _EmptyState(
                      title: 'Mesajlar yüklenemedi',
                      subtitle: '${snapshot.error}',
                      onTap: reload,
                    );
                  }

                  final items = snapshot.data ?? const <Map<String, dynamic>>[];
                  if (items.isEmpty) {
                    return _EmptyState(
                      title: 'Henüz eşleşme yok.',
                      subtitle: 'Bir anahtar kabul edildiğinde sohbet burada açılacak.',
                      onTap: reload,
                    );
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final match = items[i];
                      final profile = match['other_profile'] is Map
                          ? Map<String, dynamic>.from(match['other_profile'])
                          : <String, dynamic>{};
                      final avatar = profile['avatar_url']?.toString();
                      final hasAvatar = avatar != null && avatar.isNotEmpty;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RealChatScreen(
                                matchId: match['id'].toString(),
                                profile: profile,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: ui.OpenApp.soft,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 27,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    hasAvatar ? NetworkImage(avatar) : null,
                                child: hasAvatar
                                    ? null
                                    : const Icon(Icons.person_rounded),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (profile['display_name'] ?? 'Open kullanıcısı').toString(),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      (profile['city'] ?? 'Yeni eşleşme').toString(),
                                      style: const TextStyle(color: ui.OpenApp.muted),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RealChatScreen extends StatefulWidget {
  const RealChatScreen({
    super.key,
    required this.matchId,
    required this.profile,
  });

  final String matchId;
  final Map<String, dynamic> profile;

  @override
  State<RealChatScreen> createState() => _RealChatScreenState();
}

class _RealChatScreenState extends State<RealChatScreen> {
  final controller = TextEditingController();
  bool busy = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> send() async {
    if (controller.text.trim().isEmpty) return;
    final text = controller.text;
    controller.clear();
    setState(() => busy = true);

    try {
      await OpenBackend.instance.sendMessage(widget.matchId, text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mesaj gönderilemedi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = (widget.profile['display_name'] ?? 'Open kullanıcısı').toString();
    final me = OpenBackend.instance.userId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: OpenBackend.instance.messageStream(widget.matchId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'İlk mesajı sen gönder ✨',
                        style: TextStyle(color: ui.OpenApp.muted),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final message = messages[i];
                      final mine = message['sender_id'] == me;
                      return Align(
                        alignment:
                            mine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          margin: const EdgeInsets.only(bottom: 9),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: mine ? ui.OpenApp.lime : ui.OpenApp.soft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text((message['body'] ?? '').toString()),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => send(),
                      decoration: const InputDecoration(
                        hintText: 'Mesaj yaz...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: busy ? null : send,
                    style: IconButton.styleFrom(
                      backgroundColor: ui.OpenApp.lime,
                      foregroundColor: ui.OpenApp.ink,
                    ),
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: ui.OpenApp.soft,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ui.AppSvg(ui.AppIcons.key, size: 62),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ui.OpenApp.muted),
            ),
            const SizedBox(height: 14),
            TextButton(onPressed: onTap, child: const Text('Yenile')),
          ],
        ),
      ),
    );
  }
}
