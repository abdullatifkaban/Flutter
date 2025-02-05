import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/aliskanlik_provider.dart';
import '../widgets/aliskanlik_liste_ogesi.dart';
import '../widgets/aliskanlik_form.dart';
import 'ayarlar.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  void _yeniAliskanlikEkle(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AliskanlikForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AliskanlikProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlıklarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AyarlarSayfasi(
                    ayarlarServisi: provider.ayarlarServisi,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AliskanlikProvider>(
        builder: (context, provider, child) {
          if (provider.aliskanliklar.isEmpty) {
            return const Center(
              child: Text('Henüz alışkanlık eklenmedi'),
            );
          }

          return ListView.builder(
            itemCount: provider.aliskanliklar.length,
            itemBuilder: (context, index) {
              final aliskanlik = provider.aliskanliklar[index];
              return AliskanlikListeOgesi(
                aliskanlik: aliskanlik,
                onDuzenle: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const AliskanlikForm(),
                  );
                },
                onSil: () async {
                  final onay = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Alışkanlığı Sil'),
                      content: const Text('Bu alışkanlığı silmek istediğinize emin misiniz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hayır'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Evet'),
                        ),
                      ],
                    ),
                  );

                  if (onay == true) {
                    await provider.aliskanlikSil(aliskanlik.id);
                  }
                },
                onDurumDegistir: (yeniDurum) async {
                  await provider.durumGuncelle(aliskanlik.id, yeniDurum);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _yeniAliskanlikEkle(context),
        child: const Icon(Icons.add),
      ),
    );
  }
} 