import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/aliskanlik_provider.dart';
import '../widgets/aliskanlik_form.dart';

class AliskanlikDetay extends StatelessWidget {
  final String aliskanlikId;

  const AliskanlikDetay({
    super.key,
    required this.aliskanlikId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AliskanlikProvider>(
      builder: (context, provider, child) {
        final aliskanlik = provider.aliskanliklar
            .firstWhere((a) => a.id == aliskanlikId);

        return Scaffold(
          appBar: AppBar(
            title: Text(aliskanlik.baslik),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AliskanlikForm(
                      aliskanlik: aliskanlik,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final onay = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Alışkanlığı Sil'),
                      content: const Text(
                        'Bu alışkanlığı silmek istediğinize emin misiniz?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('İptal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sil'),
                        ),
                      ],
                    ),
                  );

                  if (onay == true) {
                    await provider.aliskanlikSil(aliskanlikId);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'aliskanlik_$aliskanlikId',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            radius: 30,
                            child: Icon(
                              _getKategoriIcon(aliskanlik.kategori),
                              size: 32,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aliskanlik.baslik,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  aliskanlik.kategori,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (aliskanlik.aciklama.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Açıklama'),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(aliskanlik.aciklama),
                  ),
                  const SizedBox(height: 24),
                ],
                _buildSectionTitle(context, 'Günler'),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: aliskanlik.gunler.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(aliskanlik.gunler[index]),
                        leading: const Icon(Icons.calendar_today),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Hatırlatma Saati'),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 16),
                      Text(
                        aliskanlik.hatirlatmaSaati.format(context),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Aktif'),
                  subtitle: Text(
                    aliskanlik.aktif ? 'Hatırlatmalar açık' : 'Hatırlatmalar kapalı',
                  ),
                  value: aliskanlik.aktif,
                  onChanged: (value) async {
                    await provider.durumGuncelle(aliskanlikId, value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  IconData _getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'Sağlık':
        return Icons.favorite;
      case 'Spor':
        return Icons.fitness_center;
      case 'Eğitim':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}
