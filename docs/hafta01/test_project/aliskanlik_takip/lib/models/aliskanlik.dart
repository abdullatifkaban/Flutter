import 'package:flutter/material.dart';

class Aliskanlik {
  final String id;
  final String baslik;
  final String aciklama;
  final String kategori;
  final List<String> gunler;
  final TimeOfDay hatirlatmaSaati;
  final bool aktif;
  final DateTime baslangicTarihi;
  final DateTime? sonTamamlanmaTarihi;

  Aliskanlik({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.kategori,
    required this.gunler,
    required this.hatirlatmaSaati,
    required this.aktif,
    required this.baslangicTarihi,
    this.sonTamamlanmaTarihi,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'aciklama': aciklama,
      'kategori': kategori,
      'gunler': gunler,
      'hatirlatmaSaati': '${hatirlatmaSaati.hour}:${hatirlatmaSaati.minute}',
      'aktif': aktif,
      'baslangicTarihi': baslangicTarihi.toIso8601String(),
      'sonTamamlanmaTarihi': sonTamamlanmaTarihi?.toIso8601String(),
    };
  }

  factory Aliskanlik.fromJson(Map<String, dynamic> json) {
    final saatParcalari = (json['hatirlatmaSaati'] as String).split(':');
    return Aliskanlik(
      id: json['id'] as String,
      baslik: json['baslik'] as String,
      aciklama: json['aciklama'] as String,
      kategori: json['kategori'] as String,
      gunler: List<String>.from(json['gunler']),
      hatirlatmaSaati: TimeOfDay(
        hour: int.parse(saatParcalari[0]),
        minute: int.parse(saatParcalari[1]),
      ),
      aktif: json['aktif'] as bool,
      baslangicTarihi: DateTime.parse(json['baslangicTarihi'] as String),
      sonTamamlanmaTarihi: json['sonTamamlanmaTarihi'] != null
          ? DateTime.parse(json['sonTamamlanmaTarihi'] as String)
          : null,
    );
  }

  Aliskanlik copyWith({
    String? id,
    String? baslik,
    String? aciklama,
    String? kategori,
    List<String>? gunler,
    TimeOfDay? hatirlatmaSaati,
    bool? aktif,
    DateTime? baslangicTarihi,
    DateTime? sonTamamlanmaTarihi,
  }) {
    return Aliskanlik(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      kategori: kategori ?? this.kategori,
      gunler: gunler ?? List.from(this.gunler),
      hatirlatmaSaati: hatirlatmaSaati ?? this.hatirlatmaSaati,
      aktif: aktif ?? this.aktif,
      baslangicTarihi: baslangicTarihi ?? this.baslangicTarihi,
      sonTamamlanmaTarihi: sonTamamlanmaTarihi ?? this.sonTamamlanmaTarihi,
    );
  }
}
