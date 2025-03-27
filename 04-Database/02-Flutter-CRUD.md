# Flutter ile To-Do Uygulaması Arayüz Tasarımı

## 1. Flutter Projesinin Oluşturulması
Öncelikle, Flutter ile bir proje oluşturalım:

```sh
flutter create todo_app
cd todo_app
```

Bu komutlar, yeni bir Flutter projesi oluşturur ve proje dizinine geçiş yapar.

Gerekli bağımlılıkları ekleyelim:

```sh
flutter pub add http provider
```

- `http`: Web servis istekleri için kullanılır.
- `provider`: State management (durum yönetimi) için kullanılır.

---

## 2. Ana Yapının Belirlenmesi
Ana dosya olan `main.dart` içinde temel yapılandırmayı yapacağız:

```dart
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
```

---

## 3. Ana Sayfa Tasarımı
Ana sayfa için `home_screen.dart` dosyasını oluşturalım:

```dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    var fetchedTasks = await ApiService.getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          var task = tasks[index];
          return ListTile(
            title: Text(task['title']),
            subtitle: Text(task['description'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ApiService.deleteTask(task['id']);
                fetchTasks();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Görev Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Başlık')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Açıklama')),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Ekle'),
              onPressed: () {
                ApiService.addTask(titleController.text, descController.text);
                fetchTasks();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
```

- `flutter/material.dart`: Flutter'ın temel UI bileşenlerini içeren kütüphane.
- `../services/api_service.dart`: API işlemlerini gerçekleştiren servis sınıfını içe aktarıyoruz.
- `HomeScreen`: Ana ekranı temsil eden bir StatefulWidget sınıfı.
- `super.key`: Widget'ın anahtarını üst sınıfa geçirir, widget ağacındaki benzersizliği sağlar.
- `createState`: StatefulWidget için durum (state) sınıfını oluşturur.
- `_HomeScreenState`: `HomeScreen` widget'ının durumunu yöneten sınıf.
- `tasks`: Görevlerin tutulduğu bir liste.
- `initState`: Widget oluşturulduğunda bir kez çağrılır. Burada görevleri API'den çekmek için `fetchTasks` çağrılır.
- `fetchTasks`: API'den görevleri çeker.
- `ApiService.getTasks()`: Görevleri API'den almak için çağrılan metod.
- `setState`: Widget'ı yeniden oluşturur ve `tasks` listesini günceller.
- `build`: Widget'ın UI'ını oluşturur.
- `Scaffold`: Flutter'da temel bir ekran düzeni sağlar.
- `AppBar`: Üstte bir uygulama çubuğu oluşturur. Başlık olarak "To-Do List" yazılır.
- `ListView.builder`: Dinamik olarak liste öğeleri oluşturur.
- `itemCount`: Görev sayısını belirtir.
- `itemBuilder`: Her bir liste öğesini oluşturur.
- `ListTile`: Liste öğesi için bir yapı sağlar.
  - `title`: Görevin başlığını gösterir.
  - `subtitle`: Görevin açıklamasını gösterir (yoksa boş bırakılır).
  - `trailing`: Sağ tarafta bir silme düğmesi ekler.
- `IconButton`: Silme işlemi için bir düğme.
  - `onPressed`: Görev silindiğinde API çağrısı yapar ve listeyi yeniler.
- `floatingActionButton`: Ekranın sağ alt köşesinde bir düğme ekler.
  - `onPressed`: Yeni görev ekleme diyalogunu açar.
  - `Icon(Icons.add)`: "+" simgesi gösterir.
- `_showAddTaskDialog`: Yeni görev eklemek için bir diyalog kutusu açar.
- `TextEditingController`: Metin alanlarının kontrolü için kullanılır.
  - `titleController`: Başlık metin alanını kontrol eder.
  - `descController`: Açıklama metin alanını kontrol eder.
- `showDialog`: Bir diyalog kutusu açar.
- `AlertDialog`: Görev ekleme için bir diyalog kutusu oluşturur.
  - `title`: Diyalog başlığı.
  - `content`: Kullanıcıdan başlık ve açıklama girmesini isteyen metin alanları.
  - `actions`: Diyalogdaki düğmeler.
    - `TextButton`: "İptal" düğmesi diyalogu kapatır.
    - `TextButton`: "Ekle" düğmesi, API'ye yeni görev ekler ve listeyi yeniler.
---

## 4. API Servis Katmanı
API isteklerini yönetecek `api_service.dart` dosyasını oluşturalım:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  static Future<List> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }

  static Future<void> addTask(String title, String description) async {
    await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'description': description}),
    );
  }

  static Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('$baseUrl/tasks/$id'));
  }
}
```

- `import 'dart:convert';`: JSON verilerini çözümlemek ve oluşturmak için kullanılan Dart kütüphanesi.
- `import 'package:http/http.dart' as http;`: HTTP isteklerini gerçekleştirmek için kullanılan Flutter kütüphanesi.
- `class ApiService`: API işlemlerini yöneten bir sınıf.
- `baseUrl`: API'nin temel URL'sini tanımlar. Bu URL, tüm isteklerde kullanılacak.
- `getTasks`: 
  - API'den tüm görevleri almak için bir GET isteği gönderir.
  - `http.get`: Belirtilen URL'ye bir GET isteği yapar.
  - `json.decode(response.body)`: API'den dönen JSON verisini Dart nesnesine dönüştürür.
  - `response.statusCode == 200`: İstek başarılıysa görev listesini döndürür, aksi halde boş bir liste döner.
- `addTask`: 
  - Yeni bir görev eklemek için bir POST isteği gönderir.
  - `http.post`: Belirtilen URL'ye bir POST isteği yapar.
  - `headers`: İstek başlıklarını tanımlar, burada JSON formatında veri gönderileceğini belirtir.
  - `body`: Gönderilecek veriyi JSON formatına dönüştürür.
- `deleteTask`: 
  - Belirli bir görevi silmek için bir DELETE isteği gönderir.
  - `http.delete`: Belirtilen URL'ye bir DELETE isteği yapar.
  - Görev ID'si URL'ye eklenerek hangi görevin silineceği belirtilir.
---

# Sonuç

Bu rehberde, Flutter kullanarak bir To-Do uygulamasının temel arayüz tasarımını ve CRUD işlemlerini nasıl gerçekleştirebileceğinizi öğrendiniz. Flutter'ın güçlü widget yapısı ve HTTP kütüphanesi sayesinde, kullanıcı dostu bir uygulama geliştirmek oldukça kolaydır. Ayrıca, API servis katmanı ile uygulamanızın backend ile iletişimini sağlam bir şekilde yapılandırabilirsiniz. Bundan sonraki adımlarda, uygulamanıza kullanıcı kimlik doğrulama, görevlerin tamamlanma durumu gibi ek özellikler ekleyerek daha işlevsel hale getirebilirsiniz. Başarılar! 🚀
