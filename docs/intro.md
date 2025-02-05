# Flutter'a Giriş

## 1. Yazılım Geliştirici Olma Yolculuğu

### Temel Bilgi ve Beceriler
- **Programlama Temelleri**
  - Algoritma ve mantıksal düşünme
    * Veri tipleri ve değişkenler
    * Kontrol yapıları (if, loop)
    * Fonksiyonlar ve modüller
    * Hata yönetimi (try-catch)
  - Veri yapıları
    * Diziler ve listeler
    * Hash tablolar
    * Ağaç yapıları
    * Yığın ve kuyruk
  - Nesne yönelimli programlama (OOP)
    * Sınıflar ve nesneler
    * Kalıtım ve polimorfizm
    * Kapsülleme ve soyutlama
    * Interface ve abstract sınıflar
  - Versiyon kontrol sistemleri (Git)
    * Temel Git komutları
    * Branch yönetimi
    * Merge ve rebase
    * Conflict çözümleri
  - Terminal/Komut satırı kullanımı
    * Temel terminal komutları
    * Shell scripting
    * Paket yönetimi
    * Dosya sistemi işlemleri

- **Yazılım Mimarisi**
  - Tasarım desenleri (Design Patterns)
    * Creational Patterns
    * Structural Patterns
    * Behavioral Patterns
  - SOLID prensipleri
    * Single Responsibility
    * Open/Closed
    * Liskov Substitution
    * Interface Segregation
    * Dependency Inversion
  - Clean Code yaklaşımı
    * Kod okunabilirliği
    * Fonksiyon ve sınıf tasarımı
    * Yorum yazma kuralları
    * Kod tekrarını önleme
  - Yazılım yaşam döngüsü
    * Gereksinim analizi
    * Tasarım
    * Geliştirme
    * Test
    * Deployment
    * Bakım

- **Veritabanı Bilgisi**
  - İlişkisel veritabanları (SQL)
    * Tablo tasarımı
    * İlişki tipleri
    * Normalizasyon
    * Kompleks sorgular
  - NoSQL veritabanları
    * Document-based (MongoDB)
    * Key-value (Redis)
    * Column-family (Cassandra)
    * Graph databases (Neo4j)
  - Temel sorgu yazma
    * CRUD işlemleri
    * Joins
    * Aggregation
    * Indexing
  - Veritabanı tasarımı
    * Schema tasarımı
    * Performance optimizasyonu
    * Backup stratejileri
    * Scaling çözümleri

### Modern Bir Uygulamanın Anatomisi

```mermaid
graph LR
    A[Modern Uygulama]
    subgraph Frontend
        B[UI Katmanı]
        B1[Kullanıcı Arayüzü]
        B2[State Yönetimi]
        B3[API İletişimi]
        B4[Responsive Design]
        B --> B1
        B --> B2
        B --> B3
        B --> B4
    end
    subgraph Backend
        C[Sunucu Katmanı]
        C1[REST API]
        C2[İş Mantığı]
        C3[Güvenlik]
        C4[Cache]
        C --> C1
        C --> C2
        C --> C3
        C --> C4
    end
    subgraph Database
        D[Veri Katmanı]
        D1[Veri Modelleri]
        D2[Veri Güvenliği]
        D3[Backup]
        D --> D1
        D --> D2
        D --> D3
    end
    subgraph DevOps
        E[Altyapı]
        E1[CI/CD]
        E2[Monitoring]
        E3[Scaling]
        E --> E1
        E --> E2
        E --> E3
    end
    A --> Frontend
    A --> Backend
    A --> Database
    A --> DevOps
```

### Frontend Geliştirici için Gereksinimler
1. **Temel Teknolojiler**
   - HTML, CSS, JavaScript
   - UI/UX prensipleri
   - Responsive tasarım
   - State yönetimi

2. **Modern Frontend Araçları**
   - Framework bilgisi (Flutter, React, Vue vb.)
   - Paket yöneticileri
   - Build araçları
   - Test yazma

3. **Performans ve Optimizasyon**
   - Lazy loading
   - Caching stratejileri
   - Asset optimizasyonu
   - Memory management

### Backend Entegrasyonu
1. **API Mimarisi**
   - REST API prensipleri
   - GraphQL
   - WebSocket
   - Authentication/Authorization

2. **Veri İşleme**
   - CRUD operasyonları
   - Veri formatları (JSON, XML)
   - Error handling
   - Logging ve monitoring

3. **Güvenlik**
   - SSL/TLS
   - Token bazlı güvenlik
   - Veri şifreleme
   - Input validasyonu

### Modern Uygulama Geliştirme Süreçleri
1. **Proje Yönetimi**
   - Agile metodolojiler
   - Sprint planlama
   - Code review süreçleri
   - Dokümantasyon

2. **DevOps Pratikleri**
   - CI/CD pipeline
   - Konteynerizasyon (Docker)
   - Cloud servisleri
   - Monitoring ve logging

3. **Test ve Kalite**
   - Unit testing
   - Integration testing
   - UI testing
   - Performance testing

## 2. Flutter Nedir ve Kurulum

### Flutter Nedir?
Flutter, Google tarafından geliştirilen açık kaynaklı bir UI yazılım geliştirme kitidir. Tek bir kod tabanından iOS, Android, web, Windows, macOS ve Linux için uygulama geliştirmenize olanak sağlar. Flutter'ın öne çıkan özellikleri:

- Hızlı geliştirme (Hot Reload özelliği)
- Zengin widget kütüphanesi
- Yüksek performans
- Özelleştirilebilir tasarım
- Geniş topluluk desteği

### Gerekli Araçların Kurulumu

#### 1. Flutter SDK Kurulumu
```bash
# Linux için kurulum adımları
cd ~/development
tar xf ~/Downloads/flutter_linux_3.x.x-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

#### 2. Dart SDK
Flutter SDK ile birlikte otomatik olarak gelir.

#### 3. IDE Kurulumu
**VS Code için:**
1. VS Code'u yükleyin
2. Flutter ve Dart eklentilerini kurun
3. Flutter Doctor komutunu çalıştırın

**Android Studio için:**
1. Android Studio'yu yükleyin
2. Flutter ve Dart pluginlerini kurun
3. Android SDK'yı yapılandırın

#### 4. Platform Araçları
**Android için:**
- Android SDK
- Android Studio veya Command-line tools
- Android Emulator

**iOS için (macOS gereklidir):**
- Xcode
- iOS Simulator
- CocoaPods

### Yapılandırma ve Doğrulama

Kurulumun başarılı olduğunu doğrulamak için terminal'de şu komutu çalıştırın:
```bash
flutter doctor
```

Bu komut, eksik bileşenleri ve yapılandırma sorunlarını gösterecektir.

### İlk Projeyi Oluşturma
```bash
flutter create ilk_uygulama
cd ilk_uygulama
flutter run
```

### Önerilen VS Code Eklentileri
- Flutter
- Dart
- Flutter Widget Snippets
- Awesome Flutter Snippets
- Flutter Tree
- pubspec Assist

Bu kurulum ve yapılandırma adımlarını tamamladıktan sonra Flutter ile uygulama geliştirmeye başlayabilirsiniz. 
