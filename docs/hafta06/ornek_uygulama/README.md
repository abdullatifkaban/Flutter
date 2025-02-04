# Hafta 6 - Örnek Uygulama: Alışveriş Sepeti

Bu örnek uygulama, Flutter'da durum yönetimi (state management) yöntemlerini kullanarak basit bir alışveriş sepeti uygulaması geliştirmeyi gösterecek.

## 🎯 Uygulama Özellikleri

1. Ürün Yönetimi (Provider):
   - Ürün listesi görüntüleme
   - Ürün detay sayfası
   - Ürün arama
   - Kategori filtreleme

2. Sepet Yönetimi (Riverpod):
   - Sepete ürün ekleme/çıkarma
   - Ürün miktarını güncelleme
   - Toplam fiyat hesaplama
   - Sepeti temizleme

3. Favoriler ve Tema (Bloc):
   - Favori ürünleri kaydetme
   - Favori listesi görüntüleme
   - Tema değiştirme (açık/koyu)
   - Tema ayarlarını kaydetme

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   └── category.dart
├── providers/
│   ├── cart_provider.dart
│   ├── product_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart
│   └── favorites_screen.dart
├── widgets/
│   ├── product_card.dart
│   ├── cart_item_card.dart
│   └── category_filter.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bir Flutter projesi oluşturun:

```bash
flutter create shopping_cart
cd shopping_cart
```

2. Gerekli bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  flutter_riverpod: ^2.4.9
  flutter_bloc: ^8.1.3
  shared_preferences: ^2.2.2
  cached_network_image: ^3.3.0
```

## 💻 Adım Adım Geliştirme

### 1. Veri Modelleri

`lib/models/product.dart`:

```dart
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
```

`lib/models/cart_item.dart`:

```dart
class CartItem {
  final String id;
  final int productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });
}
```

### 2. Provider ile Ürün Yönetimi

`lib/providers/product_provider.dart`:

```dart
class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 1,
      title: 'Kırmızı Tişört',
      description: 'Rahat ve şık bir tişört',
      price: 29.99,
      imageUrl: 'assets/images/tshirt.jpg',
      category: 'Giyim',
    ),
    // Diğer ürünler...
  ];

  List<Product> get items => [..._items];
  
  List<Product> get favorites {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  List<Product> findByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    return _items.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void toggleFavorite(int id) {
    final product = findById(id);
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }
}
```

### 3. Riverpod ile Sepet Yönetimi

`lib/providers/cart_provider.dart`:

```dart
final cartProvider = StateNotifierProvider<CartNotifier, Map<int, CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<int, CartItem>> {
  CartNotifier() : super({});

  void addItem(Product product) {
    state = {
      ...state,
      if (state.containsKey(product.id))
        product.id: CartItem(
          id: state[product.id]!.id,
          productId: product.id,
          title: product.title,
          quantity: state[product.id]!.quantity + 1,
          price: product.price,
        )
      else
        product.id: CartItem(
          id: DateTime.now().toString(),
          productId: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
    };
  }

  void removeItem(int productId) {
    state = {
      for (final entry in state.entries)
        if (entry.key != productId) entry.key: entry.value,
    };
  }

  void clear() {
    state = {};
  }

  double get totalAmount {
    return state.values.fold(0.0, (sum, item) {
      return sum + (item.price * item.quantity);
    });
  }
}
```

### 4. Bloc ile Tema Yönetimi

`lib/blocs/theme_bloc.dart`:

```dart
// Events
abstract class ThemeEvent {}
class ToggleThemeEvent extends ThemeEvent {}

// States
class ThemeState {
  final ThemeMode themeMode;
  final bool isDark;

  ThemeState({
    required this.themeMode,
    required this.isDark,
  });
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.light, isDark: false)) {
    on<ToggleThemeEvent>((event, emit) async {
      final newIsDark = !state.isDark;
      final newThemeMode = newIsDark ? ThemeMode.dark : ThemeMode.light;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', newIsDark);
      
      emit(ThemeState(
        themeMode: newThemeMode,
        isDark: newIsDark,
      ));
    });

    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    
    add(ToggleThemeEvent());
  }
}
```

### 5. Ana Uygulama

`lib/main.dart`:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        Provider(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = context.watch<ThemeBloc>().state;
    final cart = ref.watch(cartProvider);

    return MaterialApp(
      title: 'Alışveriş Sepeti',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
      ),
      themeMode: themeState.themeMode,
      home: HomeScreen(),
    );
  }
}
```

## 🎯 Ödevler

1. Provider:
   - [ ] Ürün sıralama özelliği ekleyin
   - [ ] Ürün filtreleme özelliği ekleyin
   - [ ] Ürün detay sayfasını geliştirin
   - [ ] Ürün yorumları ekleyin

2. Riverpod:
   - [ ] Sepet geçmişi ekleyin
   - [ ] Sepet özeti ekleyin
   - [ ] Kupon sistemi ekleyin
   - [ ] Teslimat seçenekleri ekleyin

3. Bloc:
   - [ ] Kullanıcı tercihleri ekleyin
   - [ ] Bildirim sistemi ekleyin
   - [ ] Dil desteği ekleyin
   - [ ] Erişilebilirlik ayarları ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] State değişiklikleri doğru çalışıyor mu?
- [ ] Widget'lar gereksiz rebuild olmuyor mu?
- [ ] Memory leak var mı?
- [ ] Error handling düzgün çalışıyor mu?

## 💡 İpuçları

1. State Management:
   - State'i immutable tutun
   - Gereksiz notifyListeners çağrılarından kaçının
   - State değişimlerini debug edin
   - Provider kombinasyonlarını optimize edin

2. Architecture:
   - Business logic'i UI'dan ayırın
   - Repository pattern kullanın
   - Dependency injection kullanın
   - SOLID prensiplerine uyun

3. Performance:
   - Selector kullanın
   - const constructor kullanın
   - Lazy loading yapın
   - Caching mekanizmaları ekleyin

## 📚 Faydalı Kaynaklar

- [Provider Documentation](https://pub.dev/packages/provider)
- [Riverpod Documentation](https://riverpod.dev)
- [Bloc Library](https://bloclibrary.dev)
- [Flutter State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro) 