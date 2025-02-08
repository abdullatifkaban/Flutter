# Flutter'da Temel Navigasyon

Flutter'da sayfalar arası geçişleri ve yönlendirmeleri öğreneceğiz. Bu bölümde, temel navigasyon işlemlerini ele alacağız.

## 1. Navigator Nedir?

Navigator, Flutter'da sayfa yönetimini sağlayan bir widget'tır. Sayfaları bir yığın (stack) yapısında tutar:
- Yeni bir sayfa açıldığında yığının üstüne eklenir (push)
- Geri dönüldüğünde yığının en üstündeki sayfa çıkarılır (pop)

## 2. Route Nedir?

Route, Flutter'da bir sayfayı temsil eden yapıdır. Üç tür route vardır:

1. **MaterialPageRoute**: Material Design geçiş animasyonları kullanır
   - Android tarzı geçiş animasyonları sağlar
   - Sayfa sağdan sola kayarak açılır
   - Geri dönüşte soldan sağa kayar
   - Özellikle Android uygulamaları için uygundur
   - Örnek kullanım:
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => YeniSayfa(),
     ),
   );
   ```

2. **CupertinoPageRoute**: iOS tarzı geçiş animasyonları kullanır
   - iOS tarzı geçiş animasyonları sağlar
   - Sayfa sağdan sola kayarak ve hafif bir örtü efektiyle açılır
   - Geri dönüşte soldan sağa kayar ve önceki sayfa açığa çıkar
   - Özellikle iOS uygulamaları için uygundur
   - Örnek kullanım:
   ```dart
   Navigator.push(
     context,
     CupertinoPageRoute(
       builder: (context) => YeniSayfa(),
     ),
   );
   ```

3. **PageRouteBuilder**: Özel geçiş animasyonları için kullanılır
   - Web ve masaüstü uygulamaları için özelleştirilebilir geçişler sağlar
   - Fade, scale, slide gibi özel animasyonlar tanımlayabilirsiniz
   - Platform bağımsız çalışır
   - Örnek kullanım:
   ```dart
   Navigator.push(
     context,
     PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => YeniSayfa(),
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         // Fade efekti örneği
         return FadeTransition(
           opacity: animation,
           child: child,
         );
       },
     ),
   );
   ```

> [!NOTE]
> - Web uygulamalarında genellikle fade veya slide animasyonları tercih edilir
> - Masaüstü uygulamalarında minimal ve hızlı geçişler önerilir
> - `PageRouteBuilder` ile platformunuza en uygun geçiş animasyonunu özelleştirerek kullanabilirsiniz
> - Tüm platformlarda aynı route tipini kullanarak tutarlı bir deneyim sahibi olabilirsiniz

## 3. Temel Navigasyon İşlemleri

### 3.1. Yeni Sayfaya Geçiş (Push)

`Navigator` widget'ını kullanarak yeni bir sayfaya geçiş yapabilirsiniz: 

```dart
// Basit geçiş
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => YeniSayfa()),
);

// İsimlendirilmiş route ile geçiş
Navigator.pushNamed(context, '/yeniSayfa');
```

### 3.2. Geri Dönüş (Pop)

```dart
// Mevcut sayfadan çıkış
Navigator.pop(context);

// Veri döndürerek çıkış
Navigator.pop(context, 'dönen veri');
```

### 3.3. Tüm Sayfaları Kapatıp Yeni Sayfaya Geçiş

```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => AnaSayfa()),
  (route) => false,
);
```

## 4. Named Routes (İsimlendirilmiş Rotalar)

MaterialApp widget'ında route'ları tanımlayabilirsiniz:

```dart
MaterialApp(
  initialRoute: '/',  // Başlangıç sayfası
  routes: {
    '/': (context) => AnaSayfa(),
    '/detay': (context) => DetaySayfasi(),
    '/ayarlar': (context) => AyarlarSayfasi(),
  },
);
```

## 5. Veri Aktarımı

### 5.1. İleri Yönlü Veri Aktarımı

```dart
// Veri gönderme
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetaySayfasi(veri: 'Gönderilen Veri'),
  ),
);

// Veriyi alma (DetaySayfasi widget'ında)
class DetaySayfasi extends StatelessWidget {
  final String veri;
  
  const DetaySayfasi({required this.veri});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(veri),
      ),
    );
  }
}
```

### 5.2. Geri Dönüş Verisi Alma

```dart
// Veri bekleyerek sayfa açma
final sonuc = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => VeriGirisEkrani()),
);

// Veri döndürme (VeriGirisEkrani'nda)
Navigator.pop(context, 'girilen veri');
```

## 6. Pratik İpuçları

1. Her zaman `context`'in geçerli olduğundan emin olun
2. Pop işlemlerinde yığında en az bir sayfa kalmasına dikkat edin
3. Büyük veriler yerine ID gibi küçük veriler aktarmayı tercih edin
4. Karmaşık navigasyon işlemleri için state management çözümleri kullanın
