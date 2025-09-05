import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'env.dart';
import 'features/cards/providers/cards_provider.dart';
import 'features/cards/ui/card_screen.dart';
import 'features/cards/ui/categories_screen.dart';
import 'features/cards/ui/create_card_screen.dart';
import 'features/players/providers/players_provider.dart';
import 'features/players/ui/players_screen.dart';
import 'features/sync/sync_provider.dart';
import 'services/sync_service.dart';
import 'ui/app_theme.dart';
import 'ui/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final playersBox = await Hive.openBox('players');
  final cardsBox = await Hive.openBox('user_cards');
  final deviceBox = await Hive.openBox('device');
  String deviceId = deviceBox.get('id');
  if (deviceId == null) {
    deviceId = const Uuid().v4();
    await deviceBox.put('id', deviceId);
  }
  final syncService = SyncService();

  runApp(MyApp(playersBox: playersBox, cardsBox: cardsBox, deviceId: deviceId, syncService: syncService));
}

class MyApp extends StatelessWidget {
  final Box playersBox;
  final Box cardsBox;
  final String deviceId;
  final SyncService syncService;

  MyApp({super.key, required this.playersBox, required this.cardsBox, required this.deviceId, required this.syncService});

  late final _router = GoRouter(routes: [
    GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/categories', builder: (c, s) => const CategoriesScreen()),
    GoRoute(path: '/card/:category', builder: (c, s) => CardScreen(s.pathParameters['category']!)),
    GoRoute(path: '/players', builder: (c, s) => const PlayersScreen()),
    GoRoute(path: '/create', builder: (c, s) => const CreateCardScreen()),
  ]);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayersProvider(playersBox)),
        ChangeNotifierProvider(create: (_) => CardsProvider(cardsBox, deviceId, syncService)),
      ],
      child: Builder(builder: (context) {
        final cards = context.read<CardsProvider>();
        final sync = SyncProvider(cards, syncService, deviceId);
        sync.sync();
        return MaterialApp.router(
          title: 'JALO',
          routerConfig: _router,
          theme: jaloTheme(),
        );
      }),
    );
  }
}
