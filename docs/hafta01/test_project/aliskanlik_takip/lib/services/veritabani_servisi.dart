import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/aliskanlik.dart';

class VeritabaniServisi {
  static final VeritabaniServisi _instance = VeritabaniServisi._internal();
  factory VeritabaniServisi() => _instance;
  VeritabaniServisi._internal();

  Database? _db;
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'aliskanlik.db');

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE aliskanliklar(
              id TEXT PRIMARY KEY,
              baslik TEXT NOT NULL,
              aciklama TEXT,
              kategori TEXT NOT NULL,
              gunler TEXT NOT NULL,
              hatirlatmaSaati TEXT NOT NULL,
              aktif INTEGER NOT NULL,
              baslangicTarihi TEXT NOT NULL,
              sonTamamlanmaTarihi TEXT
            )
          ''');
        },
      );
    }
  }

  Future<void> aliskanlikEkle(Aliskanlik aliskanlik) async {
    final map = aliskanlik.toJson();
    map['gunler'] = jsonEncode(map['gunler']);
    map['aktif'] = map['aktif'] ? 1 : 0;
    
    if (kIsWeb) {
      final aliskanliklar = await tumAliskanliklarGetir();
      aliskanliklar.add(aliskanlik);
      await _prefs?.setString('aliskanliklar', jsonEncode(
        aliskanliklar.map((a) => a.toJson()).toList(),
      ));
    } else {
      await _db?.insert(
        'aliskanliklar',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> aliskanlikGuncelle(Aliskanlik aliskanlik) async {
    final map = aliskanlik.toJson();
    map['gunler'] = jsonEncode(map['gunler']);
    map['aktif'] = map['aktif'] ? 1 : 0;
    
    if (kIsWeb) {
      final aliskanliklar = await tumAliskanliklarGetir();
      final index = aliskanliklar.indexWhere((a) => a.id == aliskanlik.id);
      if (index != -1) {
        aliskanliklar[index] = aliskanlik;
        await _prefs?.setString('aliskanliklar', jsonEncode(
          aliskanliklar.map((a) => a.toJson()).toList(),
        ));
      }
    } else {
      await _db?.update(
        'aliskanliklar',
        map,
        where: 'id = ?',
        whereArgs: [aliskanlik.id],
      );
    }
  }

  Future<void> aliskanlikSil(String id) async {
    if (kIsWeb) {
      final aliskanliklar = await tumAliskanliklarGetir();
      aliskanliklar.removeWhere((a) => a.id == id);
      await _prefs?.setString('aliskanliklar', jsonEncode(
        aliskanliklar.map((a) => a.toJson()).toList(),
      ));
    } else {
      await _db?.delete(
        'aliskanliklar',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<Aliskanlik>> tumAliskanliklarGetir() async {
    if (kIsWeb) {
      final json = _prefs?.getString('aliskanliklar');
      if (json == null) return [];
      
      final List<dynamic> list = jsonDecode(json);
      return list.map((map) {
        final aliskanlikMap = Map<String, dynamic>.from(map);
        aliskanlikMap['gunler'] = jsonDecode(aliskanlikMap['gunler'] as String);
        aliskanlikMap['aktif'] = aliskanlikMap['aktif'] == 1;
        return Aliskanlik.fromJson(aliskanlikMap);
      }).toList();
    } else {
      final List<Map<String, dynamic>> maps = await _db?.query('aliskanliklar') ?? [];
      return List.generate(maps.length, (i) {
        final map = Map<String, dynamic>.from(maps[i]);
        map['gunler'] = jsonDecode(map['gunler'] as String);
        map['aktif'] = map['aktif'] == 1;
        return Aliskanlik.fromJson(map);
      });
    }
  }

  Future<Aliskanlik?> aliskanlikGetir(String id) async {
    if (kIsWeb) {
      final aliskanliklar = await tumAliskanliklarGetir();
      return aliskanliklar.firstWhere((a) => a.id == id);
    } else {
      final List<Map<String, dynamic>> maps = await _db?.query(
        'aliskanliklar',
        where: 'id = ?',
        whereArgs: [id],
      ) ?? [];

      if (maps.isEmpty) return null;
      
      final map = Map<String, dynamic>.from(maps.first);
      map['gunler'] = jsonDecode(map['gunler'] as String);
      map['aktif'] = map['aktif'] == 1;
      return Aliskanlik.fromJson(map);
    }
  }

  Future<void> durumGuncelle(String id, bool yeniDurum) async {
    if (kIsWeb) {
      final aliskanlik = await aliskanlikGetir(id);
      if (aliskanlik != null) {
        final yeniAliskanlik = aliskanlik.copyWith(aktif: yeniDurum);
        await aliskanlikGuncelle(yeniAliskanlik);
      }
    } else {
      await _db?.update(
        'aliskanliklar',
        {'aktif': yeniDurum ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
