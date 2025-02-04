# Hafta 6 - Durum Yönetimi

Bu hafta, Flutter uygulamalarında durum yönetimi (state management) konusunu öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Durum Yönetimi Temelleri
   - Durum (state) nedir?
   - Neden durum yönetimine ihtiyaç duyarız?
   - Durum yönetimi yaklaşımları
   - Hangi durum yönetimi çözümünü seçmeliyiz?

2. Provider
   - ChangeNotifier
   - ChangeNotifierProvider
   - Consumer ve Selector
   - MultiProvider
   - Provider.of vs context.read/watch

3. Riverpod
   - Provider türleri
   - StateNotifier
   - ConsumerWidget
   - Ref ve Watch
   - Otomatik dispose

4. Bloc
   - Event ve State
   - BlocProvider
   - BlocBuilder
   - BlocListener
   - Cubit

## 📚 Konu Anlatımı

### Provider

1. **Kurulum**:
   ```yaml
   dependencies:
     provider: ^6.1.1
   ```

2. **Basit Örnek**:
   ```dart
   // Model
   class Counter with ChangeNotifier {
     int _count = 0;
     int get count => _count;

     void increment() {
       _count++;
       notifyListeners();
     }
   }

   // Provider Kurulumu
   void main() {
     runApp(
       ChangeNotifierProvider(
         create: (_) => Counter(),
         child: const MyApp(),
       ),
     );
   }

   // Widget'da Kullanım
   class CounterWidget extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return Consumer<Counter>(
         builder: (context, counter, child) {
           return Text('${counter.count}');
         },
       );
     }
   }
   ```

### Riverpod

1. **Kurulum**:
   ```yaml
   dependencies:
     flutter_riverpod: ^2.4.9
   ```

2. **Basit Örnek**:
   ```dart
   // Provider Tanımı
   final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
     return CounterNotifier();
   });

   class CounterNotifier extends StateNotifier<int> {
     CounterNotifier() : super(0);

     void increment() => state++;
   }

   // Widget'da Kullanım
   class CounterWidget extends ConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final count = ref.watch(counterProvider);
       return Text('$count');
     }
   }
   ```

### Bloc

1. **Kurulum**:
   ```yaml
   dependencies:
     flutter_bloc: ^8.1.3
   ```

2. **Basit Örnek**:
   ```dart
   // Event
   abstract class CounterEvent {}
   class IncrementEvent extends CounterEvent {}

   // Bloc
   class CounterBloc extends Bloc<CounterEvent, int> {
     CounterBloc() : super(0) {
       on<IncrementEvent>((event, emit) {
         emit(state + 1);
       });
     }
   }

   // Widget'da Kullanım
   class CounterWidget extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return BlocBuilder<CounterBloc, int>(
         builder: (context, count) {
           return Text('$count');
         },
       );
     }
   }
   ```

## 💻 Örnek Uygulama: Alışveriş Sepeti

Bu haftaki örnek uygulamamızda, öğrendiğimiz durum yönetimi yöntemlerini kullanarak bir alışveriş sepeti uygulaması geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Provider ile alışkanlık verilerini yönetme
2. Riverpod ile tema ve ayarları yönetme
3. Bloc ile istatistikleri yönetme
4. Durum yönetimi mimarisi oluşturma

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Provider:
   - [ ] Çoklu provider kullanın
   - [ ] Selector ile optimizasyon yapın
   - [ ] ProxyProvider kullanın
   - [ ] Provider kombinasyonları deneyin

2. Riverpod:
   - [ ] Farklı provider türlerini deneyin
   - [ ] AsyncValue kullanın
   - [ ] Provider override yapın
   - [ ] Provider ailesi oluşturun

3. Bloc:
   - [ ] Farklı event türleri ekleyin
   - [ ] BlocListener kullanın
   - [ ] Bloc transformers kullanın
   - [ ] MultiBlocProvider kullanın

## 🔍 Hata Ayıklama İpuçları

- Memory leak kontrolü yapın
- Gereksiz build'leri önleyin
- State değişimlerini izleyin
- Debug modunda test edin

## 📚 Faydalı Kaynaklar

- [Provider Documentation](https://pub.dev/packages/provider)
- [Riverpod Documentation](https://riverpod.dev)
- [Bloc Library](https://bloclibrary.dev)
- [State Management Comparison](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options) 