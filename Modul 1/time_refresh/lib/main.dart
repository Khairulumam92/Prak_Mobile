import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  debugPrint('main(): starting TimeRefreshApp');
  runApp(
    ChangeNotifierProvider(
      create: (_) => TimeHistory(),
      child: const TimeRefreshApp(),
    ),
  );
}

class TimeRefreshApp extends StatelessWidget {
  const TimeRefreshApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('TimeRefreshApp.build()');
    return MaterialApp(
      title: 'Refresh Waktu Sekarang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const HomePage(),
        StatelessRefreshPage.routeName: (_) => const StatelessRefreshPage(),
        StatefulRefreshPage.routeName: (_) => const StatefulRefreshPage(),
        TimeDetailPage.routeName: (_) => const TimeDetailPage(),
      },
    );
  }
}

enum TimeRecordSource { statelessWorkaround, statefulWidget }

extension on TimeRecordSource {
  String get label {
    switch (this) {
      case TimeRecordSource.statelessWorkaround:
        return 'StatelessWidget (workaround)';
      case TimeRecordSource.statefulWidget:
        return 'StatefulWidget';
    }
  }
}

class TimeHistory extends ChangeNotifier {
  final List<DateTime> _entries = <DateTime>[];

  List<DateTime> get entries => List.unmodifiable(_entries);
  DateTime? get latest => _entries.isEmpty ? null : _entries.last;

  void record(DateTime time, TimeRecordSource source) {
    _entries.add(time);
    debugPrint(
      'TimeHistory.record(): ${time.toIso8601String()} via ${source.label}',
    );
    notifyListeners();
  }

  void clear() {
    debugPrint('TimeHistory.clear()');
    _entries.clear();
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('HomePage.build()');
    final historyCount = context.watch<TimeHistory>().entries.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Refresh Waktu Sekarang')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          _NavigationTile(
            icon: Icons.flash_off,
            title: 'Versi StatelessWidget (workaround)',
            subtitle:
                'Tombol memicu pembaruan lewat state eksternal (Provider).',
            onTap: () =>
                Navigator.pushNamed(context, StatelessRefreshPage.routeName),
          ),
          _NavigationTile(
            icon: Icons.bolt,
            title: 'Versi StatefulWidget',
            subtitle:
                'Memanfaatkan setState() untuk menyimpan dan merender ulang waktu.',
            onTap: () =>
                Navigator.pushNamed(context, StatefulRefreshPage.routeName),
          ),
          _NavigationTile(
            icon: Icons.analytics,
            title: 'Eksperimen Lanjutan',
            subtitle:
                'Lihat riwayat pembaruan, analisis rebuild, dan reset data.',
            onTap: () => Navigator.pushNamed(context, TimeDetailPage.routeName),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Aktivitas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text('Total pembaruan waktu: $historyCount'),
                  const SizedBox(height: 8),
                  const Text(
                    'Gunakan Flutter DevTools untuk memantau rebuild dan performa.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class StatelessRefreshPage extends StatelessWidget {
  const StatelessRefreshPage({super.key});

  static const String routeName = '/stateless';

  @override
  Widget build(BuildContext context) {
    debugPrint('StatelessRefreshPage.build()');
    final history = context.watch<TimeHistory>();
    final latest = history.latest;
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless Widget')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'StatelessWidget tidak memiliki state internal. Di contoh ini, tombol tetap bekerja karena kita mengandalkan Provider sebagai sumber state eksternal.',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Waktu terakhir (dari Provider):'),
                    const SizedBox(height: 8),
                    Text(
                      latest?.toIso8601String() ?? 'Belum pernah diperbarui',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final now = DateTime.now();
                context.read<TimeHistory>().record(
                  now,
                  TimeRecordSource.statelessWorkaround,
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Perbarui via sumber eksternal'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Perhatikan bahwa tanpa Provider, widget ini tidak akan menyimpan data pembaruan.',
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, TimeDetailPage.routeName),
              child: const Text('Lihat riwayat pembaruan'),
            ),
          ],
        ),
      ),
    );
  }
}

class StatefulRefreshPage extends StatefulWidget {
  const StatefulRefreshPage({super.key});

  static const String routeName = '/stateful';

  @override
  State<StatefulRefreshPage> createState() => _StatefulRefreshPageState();
}

class _StatefulRefreshPageState extends State<StatefulRefreshPage> {
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    debugPrint(
      '_StatefulRefreshPageState.initState(): ${_currentTime.toIso8601String()}',
    );
  }

  void _refreshTime() {
    setState(() {
      _currentTime = DateTime.now();
      debugPrint(
        '_StatefulRefreshPageState.setState(): ${_currentTime.toIso8601String()}',
      );
    });
    context.read<TimeHistory>().record(
      _currentTime,
      TimeRecordSource.statefulWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'StatefulRefreshPage.build(): ${_currentTime.toIso8601String()}',
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Widget')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'StatefulWidget menyimpan state internal. Menggunakan setState() akan men-trigger rebuild sehingga DateTime.now() ditampilkan secara langsung.',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Waktu dari state internal:'),
                    const SizedBox(height: 8),
                    Text(
                      _currentTime.toIso8601String(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshTime,
              icon: const Icon(Icons.update),
              label: const Text('Perbarui dengan setState()'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, TimeDetailPage.routeName),
              child: const Text('Bandingkan dengan riwayat Provider'),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeDetailPage extends StatelessWidget {
  const TimeDetailPage({super.key});

  static const String routeName = '/details';

  @override
  Widget build(BuildContext context) {
    debugPrint('TimeDetailPage.build()');
    final history = context.watch<TimeHistory>();
    final entries = history.entries.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembaruan'),
        actions: [
          IconButton(
            onPressed: entries.isEmpty
                ? null
                : () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Kosongkan riwayat?'),
                        content: const Text(
                          'Tindakan ini akan menghapus semua catatan waktu.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<TimeHistory>().clear();
                            },
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Kosongkan riwayat',
          ),
        ],
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pembaruan waktu. Coba jalankan salah satu eksperimen terlebih dahulu.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, index) {
                final time = entries[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${entries.length - index}'),
                  ),
                  title: Text(time.toIso8601String()),
                  subtitle: Text(
                    'Gunakan data ini untuk analisis performa atau navigasi lanjutan.',
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: entries.length,
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Tip: gunakan debugPrint() atau Flutter DevTools untuk melacak rebuild dan navigasi.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
