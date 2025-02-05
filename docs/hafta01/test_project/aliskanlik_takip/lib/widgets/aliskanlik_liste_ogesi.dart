import 'package:flutter/material.dart';
import '../models/aliskanlik.dart';

class AliskanlikListeOgesi extends StatefulWidget {
  final Aliskanlik aliskanlik;
  final VoidCallback onDuzenle;
  final VoidCallback onSil;
  final ValueChanged<bool> onDurumDegistir;

  const AliskanlikListeOgesi({
    super.key,
    required this.aliskanlik,
    required this.onDuzenle,
    required this.onSil,
    required this.onDurumDegistir,
  });

  @override
  State<AliskanlikListeOgesi> createState() => _AliskanlikListeOgesiState();
}

class _AliskanlikListeOgesiState extends State<AliskanlikListeOgesi>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.aliskanlik.aktif
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Hero(
                    tag: 'aliskanlik_${widget.aliskanlik.id}',
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        _getKategoriIcon(),
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.aliskanlik.baslik,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.aliskanlik.aciklama.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.aliskanlik.aciklama,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: widget.aliskanlik.gunler
                            .map(
                              (gun) => Chip(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                label: Text(
                                  gun,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: widget.aliskanlik.aktif,
                        onChanged: widget.onDurumDegistir,
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: widget.onDuzenle,
                            child: const ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Düzenle'),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: widget.onSil,
                            child: const ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Sil'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getKategoriIcon() {
    switch (widget.aliskanlik.kategori) {
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
