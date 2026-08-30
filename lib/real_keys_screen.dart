import 'package:flutter/material.dart';

import 'data/open_backend.dart';
import 'main.dart' as ui;
import 'real_social_flow.dart';

class FixedRealKeysScreen extends StatefulWidget {
  const FixedRealKeysScreen({super.key});

  @override
  State<FixedRealKeysScreen> createState() => _FixedRealKeysScreenState();
}

class _FixedRealKeysScreenState extends State<FixedRealKeysScreen> {
  late Future<List<Map<String, dynamic>>> future;
  String? busyId;

  @override
  void initState() {
    super.initState();
    future = OpenBackend.instance.incomingKeys();
  }

  void reload() => setState(() => future = OpenBackend.instance.incomingKeys());

  Future<Map<String, dynamic>> _senderProfile(Map<String, dynamic> item) async {
    final senderId = item['sender_id']?.toString();
    if (senderId == null || senderId.isEmpty) {
      return item['profiles'] is Map
          ? Map<String, dynamic>.from(item['profiles'])
          : <String, dynamic>{};
    }
    final row = await OpenBackend.instance.client
        .from('profiles')
        .select('id,display_name,avatar_url,city')
        .eq('id', senderId)
        .maybeSingle();
    if (row != null) return Map<String, dynamic>.from(row);
    return item['profiles'] is Map
        ? Map<String, dynamic>.from(item['profiles'])
        : <String, dynamic>{};
  }

  Future<void> accept(Map<String, dynamic> item) async {
    final id = item['id'].toString();
    setState(() => busyId = id);
    try {
      final sender = await _senderProfile(item);
      final matchId = await OpenBackend.instance.acceptKey(id);
      if (!mounted) return;

      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => RealMatchScreen(
            matchId: matchId,
            otherProfile: sender,
          ),
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

  String statusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Kabul edildi';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Bekliyor';
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
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
                  IconButton(onPressed: reload, icon: const Icon(Icons.refresh_rounded)),
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
                      return _State(
                        title: 'Anahtarlar yüklenemedi',
                        subtitle: '${snapshot.error}',
                        onTap: reload,
                      );
                    }
                    final items = snapshot.data ?? const <Map<String, dynamic>>[];
                    if (items.isEmpty) {
                      return _State(
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
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Text(
                                    statusText(status),
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
                                        child: Text(loading ? 'Bekle...' : 'Kabul et'),
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

class _State extends StatelessWidget {
  const _State({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Center(
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
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
              const SizedBox(height: 7),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: ui.OpenApp.muted)),
              const SizedBox(height: 14),
              TextButton(onPressed: onTap, child: const Text('Yenile')),
            ],
          ),
        ),
      );
}
