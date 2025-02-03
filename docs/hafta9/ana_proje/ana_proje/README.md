# Hafta 11 - Alışkanlık Takip Uygulaması: Kullanıcı Geri Bildirimleri ve Destek

Bu hafta, uygulamamıza kullanıcı geri bildirim sistemini ve destek özelliklerini ekleyeceğiz.

## 📱 Bu Haftanın Yenilikleri

- Kullanıcı geri bildirim sistemi
- Destek merkezi
- Sık sorulan sorular (SSS)
- Otomatik yanıt sistemi
- Analitik takibi

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  freshdesk_flutter: ^1.0.0
  firebase_analytics: ^10.7.4
  feedback: ^3.0.0
  url_launcher: ^6.2.2
  shared_preferences: ^2.2.0
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `screens/destek_merkezi.dart`
   - `screens/geri_bildirim.dart`
   - `services/destek_servisi.dart`
   - `widgets/sss_widget.dart`
   - `utils/analitik_yardimcisi.dart`

## 🔍 Kod İncelemesi

### 1. Geri Bildirim Ekranı
```dart
class GeriBildirimEkrani extends StatefulWidget {
  @override
  _GeriBildirimEkraniState createState() => _GeriBildirimEkraniState();
}

class _GeriBildirimEkraniState extends State<GeriBildirimEkrani> {
  final _formKey = GlobalKey<FormState>();
  String _konu = '';
  String _mesaj = '';
  double _memnuniyet = 5.0;

  Future<void> _geriBildirimGonder() async {
    if (_formKey.currentState!.validate()) {
      try {
        await DestekServisi.geriBildirimOlustur(
          konu: _konu,
          mesaj: _mesaj,
          memnuniyetPuani: _memnuniyet,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geri bildiriminiz için teşekkürler!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Geri Bildirim')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Konu'),
              validator: (value) =>
                  value!.isEmpty ? 'Lütfen bir konu girin' : null,
              onSaved: (value) => _konu = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Mesajınız'),
              maxLines: 5,
              validator: (value) =>
                  value!.isEmpty ? 'Lütfen mesajınızı girin' : null,
              onSaved: (value) => _mesaj = value!,
            ),
            Slider(
              value: _memnuniyet,
              min: 1,
              max: 5,
              divisions: 4,
              label: '${_memnuniyet.round()}',
              onChanged: (value) => setState(() => _memnuniyet = value),
            ),
            ElevatedButton(
              onPressed: _geriBildirimGonder,
              child: Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. Destek Servisi
```dart
class DestekServisi {
  static final _freshdesk = FreshdeskFlutter(
    domain: 'sirketiniz.freshdesk.com',
    apiKey: 'your_api_key',
  );

  static Future<void> geriBildirimOlustur({
    required String konu,
    required String mesaj,
    required double memnuniyetPuani,
  }) async {
    final ticket = {
      'subject': konu,
      'description': mesaj,
      'status': 2,
      'priority': 1,
      'custom_fields': {
        'memnuniyet_puani': memnuniyetPuani,
      },
    };

    await _freshdesk.createTicket(ticket);
    await _analitikKaydet('geri_bildirim_gonderildi', {
      'memnuniyet_puani': memnuniyetPuani,
    });
  }

  static Future<void> _analitikKaydet(
    String olay,
    Map<String, dynamic> parametreler,
  ) async {
    final analytics = FirebaseAnalytics.instance;
    await analytics.logEvent(
      name: olay,
      parameters: parametreler,
    );
  }
}
```

### 3. SSS Widget
```dart
class SSSWidget extends StatelessWidget {
  final List<Map<String, String>> sorular = [
    {
      'soru': 'Alışkanlık nasıl oluşturulur?',
      'cevap': 'Ana sayfada + butonuna tıklayarak yeni alışkanlık ekleyebilirsiniz.',
    },
    {
      'soru': 'Bildirimler nasıl özelleştirilir?',
      'cevap': 'Ayarlar > Bildirimler menüsünden bildirim tercihlerinizi düzenleyebilirsiniz.',
    },
    // Diğer SSS öğeleri...
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sorular.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(sorular[index]['soru']!),
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(sorular[index]['cevap']!),
            ),
          ],
        );
      },
    );
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Geri bildirim sistemi entegrasyonunu
- Destek merkezi oluşturmayı
- Analitik takibini
- Kullanıcı deneyimi iyileştirmelerini
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Geri Bildirim:
   - Ekran görüntüsü ekleme
   - Ses kaydı gönderme
   - Çevrimdışı geri bildirim

2. Destek Merkezi:
   - Canlı sohbet desteği
   - Video yardım içerikleri
   - Topluluk forumu

3. Analitik:
   - Özel olay takibi
   - Kullanıcı segmentasyonu
   - A/B test raporları

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Premium özellikler
- Ödeme sistemi
- Abonelik yönetimi
- Gelir analizi

## 🔍 Önemli Notlar

- Geri bildirimleri düzenli kontrol edin
- Kullanıcı şikayetlerini önceliklendirin
- Destek yanıt sürelerini takip edin
- Analitik verilerini düzenli analiz edin 