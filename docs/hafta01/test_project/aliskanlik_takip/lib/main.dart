import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'providers/aliskanlik_provider.dart';
import 'services/veritabani_servisi.dart';
import 'services/bildirim_servisi.dart';
import 'services/ayarlar_servisi.dart';
import 'screens/ana_sayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final veritabaniServisi = VeritabaniServisi();
  await veritabaniServisi.initialize();

  final bildirimServisi = BildirimServisi();
  await bildirimServisi.initialize();

  final ayarlarServisi = AyarlarServisi();
  await ayarlarServisi.initialize();

  runApp(MyApp(
    veritabaniServisi: veritabaniServisi,
    bildirimServisi: bildirimServisi,
    ayarlarServisi: ayarlarServisi,
  ));
}

class MyApp extends StatelessWidget {
  final VeritabaniServisi veritabaniServisi;
  final BildirimServisi bildirimServisi;
  final AyarlarServisi ayarlarServisi;

  const MyApp({
    super.key,
    required this.veritabaniServisi,
    required this.bildirimServisi,
    required this.ayarlarServisi,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AliskanlikProvider(
        veritabaniServisi: veritabaniServisi,
        bildirimServisi: bildirimServisi,
        ayarlarServisi: ayarlarServisi,
      ),
      child: MaterialApp(
        title: 'Alışkanlık Takip',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AnaSayfa(),
      ),
    );
  }
}
