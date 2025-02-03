# Hafta 2 - TODO Uygulaması Örneği

Bu örnek, Flutter'da state yönetimi ve temel widget'ların kullanımını gösteren basit bir TODO uygulamasıdır.

## 📱 Uygulama Özellikleri

- Yeni görev ekleme
- Görevleri tamamlandı olarak işaretleme
- Görev silme
- Tamamlanan görevleri farklı stil ile gösterme

## 🔍 Kod İncelemesi

### 1. Veri Modeli
```dart
class TodoItem {
  String baslik;
  bool tamamlandi;

  TodoItem({
    required this.baslik,
    required this.tamamlandi,
  });
}
```
- Görev başlığı ve durumu için basit bir veri modeli
- `required` anahtar kelimesi ile zorunlu parametreler

### 2. Ana Uygulama Yapısı
```dart
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}
```
- Material tasarım kullanılıyor
- Ana ekran olarak `TodoListScreen` belirleniyor

### 3. State Yönetimi
```dart
class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _ekleGorev() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _todos.add(TodoItem(
        baslik: _controller.text,
        tamamlandi: false,
      ));
      _controller.clear();
    });
  }
}
```
- Görev listesi bir `List` içinde tutuluyor
- `TextEditingController` ile metin girişi kontrol ediliyor
- `setState` ile UI güncelleniyor

### 4. Kullanılan Widget'lar

#### TextField ve Button
```dart
Row(
  children: [
    Expanded(
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Yeni Görev',
          hintText: 'Görev başlığını girin',
          border: OutlineInputBorder(),
        ),
      ),
    ),
    ElevatedButton(
      onPressed: _ekleGorev,
      child: Text('Ekle'),
    ),
  ],
)
```
- `TextField` görev girişi için
- `ElevatedButton` görev eklemek için
- `Row` ve `Expanded` ile yatay düzen

#### ListView.builder
```dart
ListView.builder(
  itemCount: _todos.length,
  itemBuilder: (context, index) {
    final todo = _todos[index];
    return Card(
      child: ListTile(
        leading: Checkbox(...),
        title: Text(...),
        trailing: IconButton(...),
      ),
    );
  },
)
```
- Dinamik liste görünümü
- Her görev için bir `Card` ve `ListTile`
- `Checkbox` durum değişimi için
- `IconButton` silme işlemi için

## 🎯 Öğrenme Hedefleri

Bu örnek ile:
- StatefulWidget kullanımı
- Liste bazlı veri yönetimi
- Kullanıcı girişi alma
- Dinamik UI güncelleme
- Widget ağacı oluşturma
konularını öğrenmiş olacaksınız.

## 🔄 Nasıl Çalıştırılır?

1. Yeni bir Flutter projesi oluşturun:
```bash
flutter create todo_app
cd todo_app
```

2. `lib/main.dart` dosyasının içeriğini bu örnekteki kodla değiştirin.

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📝 Alıştırmalar

1. Görevlere öncelik ekleyin (düşük, orta, yüksek)
2. Görevleri önceliğe göre sıralayın
3. Görevleri düzenleme özelliği ekleyin
4. Tamamlanan görevleri filtreleme özelliği ekleyin
5. Görevlere son tarih ekleme özelliği ekleyin

## 💡 İpuçları

1. State Yönetimi:
   - State'i değiştiren her işlemde `setState` kullanın
   - State değişkenlerini `final` yapın
   - State'i uygun seviyede tutun

2. UI Tasarımı:
   - Material Design prensiplerini takip edin
   - Yeterli padding ve spacing kullanın
   - Kullanıcı geri bildirimi ekleyin (SnackBar, Dialog vb.)

3. Kod Organizasyonu:
   - Fonksiyonları mantıklı parçalara bölün
   - Tekrar eden kodları method'lara çıkarın
   - Widget'ları gerektiğinde ayrı dosyalara taşıyın 