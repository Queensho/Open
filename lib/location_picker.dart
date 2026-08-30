import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationSelection {
  const LocationSelection(this.country, this.state, this.district);
  final String country;
  final String state;
  final String district;

  String get label =>
      [country, state, district].where((e) => e.isNotEmpty).join(' · ');
}

class LocationPicker {
  static const _base = 'https://countriesnow.space/api/v0.1/countries';

  static Future<List<String>> _post(
    String path,
    Map<String, dynamic> body,
    String key,
  ) async {
    final response = await http
        .post(
          Uri.parse('$_base/$path'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Konum servisine ulaşılamadı');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'];
    dynamic raw;
    if (data is Map<String, dynamic>) {
      raw = data[key];
    } else {
      raw = data;
    }
    if (raw is! List) return <String>[];
    final result = raw
        .map((e) => e is Map ? (e['name'] ?? '').toString() : e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toSet()
        .toList();
    result.sort();
    return result;
  }

  static Future<List<String>> countries() async {
    final response = await http
        .get(Uri.parse('$_base/positions'))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Ülkeler yüklenemedi');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'];
    if (data is! List) return <String>[];
    final result = data
        .whereType<Map>()
        .map((e) => (e['name'] ?? '').toString())
        .where((e) => e.trim().isNotEmpty)
        .toSet()
        .toList();
    result.sort();
    return result;
  }

  static Future<List<String>> states(String country) =>
      _post('states', {'country': country}, 'states');

  static Future<List<String>> districts(String country, String state) =>
      _post('state/cities', {'country': country, 'state': state}, 'data');

  static Future<String?> _pick(
    BuildContext context,
    String title,
    Future<List<String>> future,
  ) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _PickerSheet(title: title, future: future),
    );
  }

  static Future<LocationSelection?> show(
    BuildContext context, {
    String country = '',
    String state = '',
    String district = '',
  }) async {
    final selectedCountry = await _pick(context, 'Ülke seç', countries());
    if (selectedCountry == null || !context.mounted) return null;

    final selectedState =
        await _pick(context, 'İl / bölge seç', states(selectedCountry));
    if (selectedState == null || !context.mounted) return null;

    final selectedDistrict = await _pick(
      context,
      'İlçe / şehir seç',
      districts(selectedCountry, selectedState),
    );
    if (selectedDistrict == null) return null;

    return LocationSelection(
      selectedCountry,
      selectedState,
      selectedDistrict,
    );
  }
}

class _PickerSheet extends StatefulWidget {
  const _PickerSheet({required this.title, required this.future});
  final String title;
  final Future<List<String>> future;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .72,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Column(
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) =>
                    setState(() => query = value.trim().toLowerCase()),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Ara',
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: widget.future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Konumlar yüklenemedi.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    final items = (snapshot.data ?? <String>[])
                        .where((e) =>
                            query.isEmpty || e.toLowerCase().contains(query))
                        .toList();
                    if (items.isEmpty) {
                      return const Center(child: Text('Sonuç bulunamadı'));
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          items[index],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.pop(context, items[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
