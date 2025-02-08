# Dart Programlama Dili Temelleri

![Dart Logo](https://upload.wikimedia.org/wikipedia/commons/a/a4/Dart-logo-wordmark.svg)

Dart, Flutter için geliştirilmiş bir programlama dilidir. Dart, modern, güvenli ve etkili bir dil olarak tasarlanmıştır. 

## Değişkenler ve Veri Tipleri

### Temel Veri Tipleri
```dart
// Sayısal veri tipleri
int tamsayi = 42;
double ondalikli = 3.14;
num herhangiSayi = 123; // int veya double olabilir

// Metin veri tipi
String metin = "Merhaba Dünya";

// Mantıksal veri tipi
bool dogruMu = true;

// Dinamik tip
dynamic dinamikDeger = "Bu değer herhangi bir tipte olabilir";
var otomatikTip = "Tip çıkarımı yapılır";
```

### Null Safety

Dart 2.12 ile gelen null safety özelliği, null referans (null pointer) hatalarını önlemeye yardımcı olur: 
```dart
// Nullable değişkenler
String? nullOlabilir = null;
String nullOlamaz = "Bu değişken her zaman bir değer içermeli";

// Late değişkenler
late String gecikmeliDeger;
// Değer sonradan atanabilir
gecikmeliDeger = "Şimdi değer atandı";
```

## Koleksiyonlar

### Listeler
```dart
// Sabit uzunluklu liste
List<int> sayilar = [1, 2, 3, 4, 5];

// Dinamik liste
var dinamikListe = <String>[];
dinamikListe.add("Eleman 1");

// Spread operatörü
var liste1 = [1, 2, 3];
var liste2 = [...liste1, 4, 5]; // [1, 2, 3, 4, 5]
```

### Map (Sözlük)
```dart
// Key-Value çiftleri
Map<String, int> puanlar = {
  'Ahmet': 85,
  'Mehmet': 92,
  'Ayşe': 88,
};

// Değer ekleme ve erişim
puanlar['Fatma'] = 95;
print(puanlar['Ahmet']); // 85
```

### Set
```dart
// Benzersiz elemanlar
Set<String> renkler = {'kırmızı', 'mavi', 'yeşil'};
renkler.add('sarı');
renkler.add('kırmızı'); // Tekrar eklenmez
```

## Fonksiyonlar

### Temel Fonksiyon Yapısı

Fonksiyonlar, bir işi yapan kod bloklarıdır. Bu bloklar, isimleriyle çağrılabilir ve birden fazla kere kullanılabilir.

```dart
// Basit fonksiyon
int topla(int a, int b) {
  return a + b;
}

// Ok fonksiyonu (Lambda)
int cikar(int a, int b) => a - b;

// Opsiyonel parametreler
String selamla([String? isim]) {
  return "Merhaba ${isim ?? 'Misafir'}";
}

// İsimli parametreler
void kullaniciOlustur({
  required String ad,
  required String soyad,
  int? yas,
}) {
  print('$ad $soyad, ${yas ?? "yaş belirtilmedi"}');
}
```

## Sınıflar ve Kalıtım

### Temel Sınıf Yapısı

Sınıflar, nesnelerin oluşturulmasını sağlayan yapılardır. Bu yapılar, nesnelerin özelliklerini ve davranışlarını tanımlamak için kullanılır.

```dart
class Kullanici {
  // Özellikler
  final String ad;
  final String soyad;
  int _yas; // private değişken

  // Constructor
  Kullanici(this.ad, this.soyad, this._yas);

  // Getter
  int get yas => _yas;

  // Setter
  set yas(int yeniYas) {
    if (yeniYas >= 0) {
      _yas = yeniYas;
    }
  }

  // Metot
  String tamAd() => '$ad $soyad';
}
```

### Kalıtım

Kalıtım, bir sınıfın başka bir sınıfın özelliklerini miras almasını sağlayan bir yapıdır. Bu sayede, bir sınıfın özelliklerini başka bir sınıfa aktarabiliriz.
```dart
// Temel sınıf
abstract class Canli {
  void nefesAl();
}

// Alt sınıf
class Insan extends Canli {
  @override
  void nefesAl() {
    print('İnsan nefes alıyor');
  }
}

// Mixin kullanımı
mixin Yuzebilir {
  void yuz() {
    print('Yüzüyor');
  }
}

class Balik extends Canli with Yuzebilir {
  @override
  void nefesAl() {
    print('Balık solungaçlarıyla nefes alıyor');
  }
}
```

## Asenkron Programlama

### Future ve Async-Await

Future, gelecekte tamamlanacak bir işlemin sonucunu temsil eden bir yapıdır. Örneğin bir API'den veri çekme, dosya okuma gibi zaman alan işlemlerin sonuçlarını Future ile bekleyebiliriz.

async-await ise asenkron programlamayı daha okunabilir hale getiren özel anahtar kelimelerdir:
- **async:** Bir fonksiyonun asenkron olduğunu belirtir
- **await:** Future döndüren bir işlemin tamamlanmasını beklemek için kullanılır

Bu yapılar sayesinde, uygulamanın ana akışını bloklamadan uzun süren işlemleri yönetebiliriz.

```dart
// Future kullanımı
Future<String> veriGetir() async {
  // Simüle edilmiş ağ gecikmesi
  await Future.delayed(Duration(seconds: 2));
  return "Veri geldi";
}

// Async fonksiyon kullanımı
void veriIsle() async {
  print('Veri bekleniyor...');
  String sonuc = await veriGetir();
  print(sonuc);
}
```

### Stream

Stream, birden fazla değer üreten veya alan bir yapıdır. Örneğin bir API'den sürekli veri çekme, bir dosyadan sürekli okuma gibi işlemlerde Stream kullanılabilir.

```dart
// Stream oluşturma
Stream<int> sayiUret() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// Stream dinleme
void streamDinle() async {
  await for (int sayi in sayiUret()) {
    print(sayi);
  }
}
```

## Hata Yönetimi

### Try-Catch

Try-Catch yapısı, hataları yönetmek için kullanılır. Bu yapı, hataları yönetmek için kullanılır.

```dart
void hataYonetimi() {
  try {
    // Potansiyel hata oluşturabilecek kod
    int sonuc = 12 ~/ 0; // Sıfıra bölme hatası
  } on IntegerDivisionByZeroException {
    print('Sıfıra bölme hatası!');
  } catch (e) {
    print('Bir hata oluştu: $e');
  } finally {
    print('Bu blok her durumda çalışır');
  }
}
```

## Önemli Dart Özellikleri

### Cascade Notation

Cascade Notation (..), bir nesne üzerinde ardışık işlemler yapmayı sağlayan kullanışlı bir özelliktir. Bu notasyon, aynı nesne üzerinde birden fazla işlem yaparken kodu daha okunabilir hale getirir.

```dart
// Cascade kullanımı
var liste = []
  ..add(1)
  ..add(2)
  ..add(3);
```

### Extension Methods

Extension Methods, var olan bir sınıfın özelliklerini genişletmek için kullanılır. Bu sayede, var olan bir sınıfın özelliklerini genişletebilir ve yeni metotlar ekleyebilirsiniz. 

```dart
extension StringExtension on String {
  String ilkHarfiBuyut() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// Kullanımı
print('merhaba'.ilkHarfiBuyut()); // Merhaba
```

Bu temel Dart özellikleri, Flutter uygulamaları geliştirirken sıkça kullanacağınız yapı taşlarıdır. Dart'ın modern ve güçlü özellikleri, Flutter'da temiz ve etkili kod yazmanıza yardımcı olur. 