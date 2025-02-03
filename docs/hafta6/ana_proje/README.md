# Hafta 6 - Alışkanlık Takip Uygulaması: Performans ve Çevrimdışı Mod

Bu hafta, uygulamamıza çevrimdışı çalışma modu ekleyecek ve performans iyileştirmeleri yapacağız.

## 📱 Bu Haftanın Yenilikleri

- Çevrimdışı çalışma modu
- SQLite entegrasyonu
- Veri senkronizasyonu
- Performans iyileştirmeleri
- Hata ayıklama sistemi

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
  connectivity_plus: ^5.0.2
  flutter_bloc: ^8.1.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `database/local_database.dart`: SQLite veritabanı işlemleri
   - `services/connectivity_service.dart`: İnternet bağlantısı kontrolü
   - `services/sync_service.dart`: Veri senkronizasyonu
   - `bloc/connectivity_bloc.dart`: Bağlantı durumu yönetimi
   - `utils/performance.dart`: Performans iyileştirmeleri

## 🔍 Kod İncelemesi

### 1. Yerel Veritabanı
```dart
class LocalDatabase {
  static Database? _database;
  
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'aliskanlik_takip.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE aliskanliklar (
            id TEXT PRIMARY KEY,
            baslik TEXT,
            aciklama TEXT,
            tamamlandi INTEGER,
            olusturulma_tarihi TEXT,
            senkronize_edildi INTEGER DEFAULT 0
          )
        ''');
        // Diğer tablolar...
      },
    );
  }
}
```

### 2. Bağlantı Kontrolü
```dart
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityChanged>((event, emit) {
      if (event.hasConnection) {
        emit(ConnectivityAvailable());
      } else {
        emit(ConnectivityUnavailable());
      }
    });

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      add(ConnectivityChanged(result != ConnectivityResult.none));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

### 3. Veri Senkronizasyonu
```dart
class SyncService {
  final LocalDatabase _localDb;
  final FirebaseServisi _firebaseDb;
  final ConnectivityBloc _connectivityBloc;

  Future<void> senkronizeEt() async {
    if (_connectivityBloc.state is ConnectivityUnavailable) {
      return;
    }

    // Yerel değişiklikleri gönder
    final senkronizeEdilmeyenler = await _localDb.getSenkronizeEdilmeyenler();
    for (var veri in senkronizeEdilmeyenler) {
      await _firebaseDb.guncelle(veri);
      await _localDb.senkronizeEdildiIsaretle(veri.id);
    }

    // Sunucudaki değişiklikleri al
    final sonGuncelleme = await _localDb.getSonGuncellemeTarihi();
    final yeniVeriler = await _firebaseDb.getGuncellemeler(sonGuncelleme);
    await _localDb.topluGuncelle(yeniVeriler);
  }
}
```

### 4. Performans İyileştirmeleri
```dart
class PerformanceOptimizer {
  static void listeyiOptimizeEt(ListView liste) {
    // ListView.builder kullan
    // Gereksiz build'leri önle
    // Resimleri önbellekle
  }

  static void bellegiOptimizeEt() {
    // Gereksiz verileri temizle
    // Önbellek boyutunu sınırla
    // Büyük nesneleri dispose et
  }

  static void animasyonlariOptimizeEt() {
    // Donanım hızlandırma kullan
    // Karmaşık animasyonları basitleştir
    // Frame düşmelerini önle
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- SQLite veritabanı kullanımını
- Çevrimdışı mod geliştirmeyi
- Veri senkronizasyonunu
- Performans optimizasyonunu
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Veritabanı:
   - Migrations ekleyin
   - Veritabanı şifreleme ekleyin
   - Yedekleme sistemi geliştirin

2. Senkronizasyon:
   - Çakışma çözümleme ekleyin
   - Kısmi senkronizasyon ekleyin
   - Senkronizasyon geçmişi tutun

3. Performans:
   - Lazy loading ekleyin
   - Önbellek stratejisi geliştirin
   - Widget ağacını optimize edin

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Gelişmiş analitik
- A/B testleri
- Kullanıcı geri bildirimleri
- Hata raporlama sistemi

## 🔍 Önemli Notlar

- Çevrimdışı modda veri tutarlılığını sağlayın
- Batarya kullanımını optimize edin
- Bellek kullanımını kontrol edin
- Düzenli performans testleri yapın 