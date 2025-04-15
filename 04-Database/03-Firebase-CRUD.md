# Flutter ile Firebase Firestore Kullanarak To-Do Uygulaması

Bu derste, sıfırdan yeni bir Flutter projesi oluşturarak Firebase Firestore kullanarak basit bir To-Do uygulamasını nasıl geliştireceğimizi öğreneceğiz. Firebase, Google tarafından sunulan bir mobil ve web uygulama geliştirme platformudur ve Firestore, NoSQL tabanlı, gerçek zamanlı bir bulut veritabanıdır.

## 1. Firebase'e Giriş

**Firebase Nedir?**
Firebase, geliştiricilere uygulama oluşturma, yönetme ve büyütme süreçlerinde yardımcı olan kapsamlı bir araç setidir. Backend hizmetleri (veritabanı, kimlik doğrulama, depolama), analiz araçları, test ve dağıtım hizmetleri gibi birçok özellik sunar.

**Firestore Nedir?**
Cloud Firestore, Firebase'in sunduğu esnek, ölçeklenebilir bir NoSQL bulut veritabanıdır. Verileri dokümanlar (documents) halinde saklar ve bu dokümanları koleksiyonlar (collections) içinde organize eder. Gerçek zamanlı senkronizasyon özelliği sayesinde, veritabanındaki değişiklikler anında bağlı tüm istemcilere yansıtılır.

**Flutter ile Firebase Kullanmanın Avantajları:**
*   **Hızlı Geliştirme:** Hazır backend hizmetleri sayesinde sunucu tarafı kod yazma ihtiyacını azaltır.
*   **Gerçek Zamanlı Veri:** Firestore ile verilerdeki değişiklikler anında uygulamaya yansır.
*   **Ölçeklenebilirlik:** Uygulamanız büyüdükçe Firebase hizmetleri de otomatik olarak ölçeklenir.
*   **Kolay Entegrasyon:** Flutter için özel olarak geliştirilmiş `firebase_flutter` eklentileri sayesinde entegrasyon basittir.

---

## 2. Firebase Projesi Oluşturma ve Flutter Entegrasyonu

**Adım 1: Firebase Projesi Oluşturma**
1.  [Firebase Konsolu](https://console.firebase.google.com/)'na gidin ve Google hesabınızla giriş yapın.
2.  "Proje ekle" (Create a Firebase project) seçeneğine tıklayın.
3.  Projenize bir isim verin (örn: `flutter-todo-app`) ve devam edin.
4.  Google Analytics'i etkinleştirip etkinleştirmemeyi seçin (bu proje için isteğe bağlıdır) ve "Proje oluştur" (Create project) butonuna tıklayın.

**Adım 2: Yeni Flutter Projesi Oluşturma**
Öncelikle Firebase entegrasyonu yapacağımız yeni bir Flutter projesi oluşturalım:

```sh
flutter create firebase_todo_app
cd firebase_todo_app
```

Bu komutlar, `firebase_todo_app` adında yeni bir Flutter projesi oluşturur ve proje dizinine geçiş yapar.

**Adım 3: Flutter Projesine Firebase Ekleme (FlutterFire CLI ile)**
Firebase'i Flutter projenize eklemenin en kolay yolu FlutterFire CLI kullanmaktır.

1.  **FlutterFire CLI Kurulumu:** Henüz kurulu değilse, terminalde şu komutu çalıştırın:
    ```sh
    dart pub global activate flutterfire_cli
    ```
2.  **Firebase CLI Kurulumu:** FlutterFire CLI, Firebase CLI'a ihtiyaç duyar. Kurulu değilse [Firebase CLI Kurulum Talimatları](https://firebase.google.com/docs/cli#setup_update_cli)'nı takip edin. Genellikle şu komutla kurulur:
    ```sh
    npm install -g firebase-tools
    # veya curl -sL https://firebase.tools | bash
    ```
3.  **Firebase'e Giriş Yapma:** Terminalde şu komutu çalıştırın ve tarayıcıda açılan pencereden Google hesabınızla giriş yapın:
    ```sh
    firebase login
    ```
4.  **Flutter Projesini Firebase'e Bağlama:** Yeni oluşturduğunuz Flutter projenizin ana dizininde (`firebase_todo_app`) şu komutu çalıştırın:
    ```sh
    flutterfire configure
    ```

> **⚠️ Hata ve Çözüm: `zsh: command not found: flutterfire`**
>
> Eğer `flutterfire configure` komutunu çalıştırdığınızda `zsh: command not found: flutterfire` gibi bir hata alırsanız, bu genellikle Dart'ın global olarak yüklediği komutların bulunduğu dizinin (`/home/abdullatif/.pub-cache/bin`) sisteminizin `PATH` ortam değişkenine eklenmemiş olmasından kaynaklanır.
>
> **Çözüm (zsh için):**
> 1.  Terminalde şu komutu çalıştırarak Dart'ın bin dizinini `.zshrc` dosyanıza ekleyin:
>     ```sh
>     echo 'export PATH="$PATH:/home/abdullatif/.pub-cache/bin"' >> /home/abdullatif/.zshrc
>     ```
> 2.  Değişikliklerin geçerli olması için terminalinizi yeniden başlatın veya şu komutu çalıştırın:
>     ```sh
>     source /home/abdullatif/.zshrc
>     ```
> Bu adımlardan sonra `flutterfire configure` komutu çalışmalıdır. Diğer kabuklar (bash vb.) için benzer adımlar `.bashrc` veya ilgili profil dosyası üzerinde yapılır.

    *   Komut sizden oluşturduğunuz Firebase projesini seçmenizi isteyecektir.
    *   Hangi platformları (android, ios, web vb.) yapılandırmak istediğinizi soracaktır. İhtiyacınız olanları seçin (genellikle android ve ios).
    *   Bu komut, gerekli platform özgü yapılandırma dosyalarını (`google-services.json` vb.) otomatik olarak oluşturacak ve `lib/firebase_options.dart` dosyasını projenize ekleyecektir.

**Adım 4: Gerekli Firebase Paketlerini Ekleme**
Projenizin `pubspec.yaml` dosyasına aşağıdaki Firebase paketlerini ekleyin ve kaydedin (FlutterFire CLI bunları otomatik eklemediyse veya eksikse):

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Cupertino Icons varsayılan olarak gelir
  cupertino_icons: ^1.0.2 
  
  # Firebase paketleri
  firebase_core: ^latest # Firebase'i başlatmak için temel paket
  cloud_firestore: ^latest # Firestore veritabanı için paket
  
  # İsteğe bağlı: State management için provider eklenebilir, 
  # ancak bu örnekte doğrudan setState kullanılmıştır.
  # provider: ^latest 
```

Paketleri yüklemek için terminalde şu komutu çalıştırın:
```sh
flutter pub get
```

---

## 3. Flutter Uygulamasını Firebase'e Bağlama

Uygulamanızın Firebase hizmetlerini kullanabilmesi için başlatılması gerekir. `main.dart` dosyanızı aşağıdaki gibi güncelleyin:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core ekleyin
// Proje adını kendi projenize göre güncelleyin (eğer farklıysa)
import 'package:firebase_todo_app/firebase_options.dart'; 
import 'package:firebase_todo_app/screens/home_screen_firebase.dart'; // Yeni home screen kullanacağız

void main() async { // main fonksiyonunu async yapın
  WidgetsFlutterBinding.ensureInitialized(); // Flutter binding'in başlatıldığından emin olun
  await Firebase.initializeApp( // Firebase'i başlatın
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase To-Do',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Temayı değiştirebiliriz
      ),
      home: const HomeScreenFirebase(), // Firebase için yeni ana ekran
    );
  }
}
```

**Önemli Değişiklikler:**
*   `main` fonksiyonu `async` olarak işaretlendi.
*   `WidgetsFlutterBinding.ensureInitialized();` eklendi. Bu, Firebase başlatılmadan önce Flutter motorunun hazır olmasını sağlar.
*   `Firebase.initializeApp()` çağrısı ile Firebase başlatıldı. `firebase_options.dart` dosyasındaki platforma özgü ayarlar kullanıldı.
*   `home` olarak `HomeScreenFirebase` adında yeni bir widget belirledik (bir sonraki adımda oluşturacağız).

---

## 4. Firestore ile CRUD İşlemleri

Şimdi, yeni projemizde (`firebase_todo_app`) `lib` klasörü altında `screens` adında bir klasör oluşturalım ve içine `home_screen_firebase.dart` adında yeni bir dosya ekleyelim. Bu dosya, Firestore işlemlerini yapacağımız ana ekranımız olacak.

**`lib/screens/home_screen_firebase.dart` İçeriği:**

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore ekleyin

class HomeScreenFirebase extends StatefulWidget {
  const HomeScreenFirebase({super.key});

  @override
  _HomeScreenFirebaseState createState() => _HomeScreenFirebaseState();
}

class _HomeScreenFirebaseState extends State<HomeScreenFirebase> {
  // API Service yerine doğrudan Firestore referansı kullanacağız
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // initState ve fetchTasks metodlarına artık gerek yok, StreamBuilder kullanacağız.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase To-Do List'),
        backgroundColor: Colors.orange, // AppBar rengini değiştirelim
      ),
      // ListView.builder yerine StreamBuilder kullanacağız
      body: StreamBuilder<QuerySnapshot>(
        stream: _tasksCollection.orderBy('createdAt', descending: true).snapshots(), // Firestore'dan stream alınır
        builder: (context, snapshot) {
          // Veri bekleniyor veya hata varsa gösterilecekler
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu!'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Henüz görev eklenmemiş.'));
          }

          // Veri başarıyla geldiyse ListView oluşturulur
          var tasks = snapshot.data!.docs; // Doküman listesi

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              var taskData = task.data() as Map<String, dynamic>; // Doküman verisi

              return ListTile(
                leading: Checkbox(
                  value: taskData['is_completed'] ?? false,
                  onChanged: (bool? value) {
                    // Update işlemi
                    _tasksCollection.doc(task.id).update({'is_completed': value ?? false});
                  },
                ),
                title: Text(taskData['title'] ?? 'Başlık Yok'),
                subtitle: Text(taskData['description'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete işlemi
                    _tasksCollection.doc(task.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.orange,
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
          title: const Text('Yeni Görev Ekle (Firebase)'),
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
                if (titleController.text.isNotEmpty) {
                  // Create işlemi
                  _tasksCollection.add({
                    'title': titleController.text,
                    'description': descController.text,
                    'is_completed': false,
                    'createdAt': Timestamp.now(), // Eklenme zamanı
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
```

**Önemli Değişiklikler ve Açıklamalar:**
*   **`cloud_firestore` import edildi.**
*   **`ApiService` kaldırıldı:** Doğrudan Firestore referansı (`_tasksCollection`) kullanıldı.
*   **`initState` ve `fetchTasks` kaldırıldı:** Verileri almak için `StreamBuilder` kullanıldı. `StreamBuilder`, Firestore'daki `tasks` koleksiyonunu dinler (`_tasksCollection.snapshots()`) ve herhangi bir değişiklik olduğunda (ekleme, silme, güncelleme) arayüzü otomatik olarak günceller.
*   **`orderBy('createdAt', descending: true)`:** Görevleri eklenme zamanına göre en yeniden eskiye doğru sıralar. Bunun için `createdAt` alanı ekledik.
*   **`StreamBuilder` Kullanımı:**
    *   `stream`: Dinlenecek olan Firestore akışını belirtir.
    *   `builder`: Akışın durumuna göre (veri bekleniyor, hata var, veri geldi) farklı widget'lar döndürür.
    *   `snapshot.data!.docs`: Firestore'dan gelen doküman listesini içerir.
*   **CRUD İşlemleri:**
    *   **Create:** `_showAddTaskDialog` içinde `_tasksCollection.add({...})` kullanılarak yeni bir doküman eklenir. `createdAt` alanı için `Timestamp.now()` kullanıldı.
    *   **Read:** `StreamBuilder` ile otomatik olarak yapılır.
    *   **Update:** `Checkbox`'ın `onChanged` callback'inde `_tasksCollection.doc(task.id).update({...})` kullanılarak ilgili dokümanın `is_completed` alanı güncellenir. `task.id` ile dokümanın benzersiz kimliğine erişilir.
    *   **Delete:** Silme butonunun `onPressed` callback'inde `_tasksCollection.doc(task.id).delete()` kullanılarak ilgili doküman silinir.
*   **Veri Erişimi:** `task.data() as Map<String, dynamic>` ile dokümanın içeriği bir Map olarak alınır ve alanlara erişilir (`taskData['title']`). Null kontrolü (`??`) eklendi.

---

## 5. Firebase Servis Katmanı (Opsiyonel)

Kod tekrarını önlemek ve Firestore işlemlerini merkezi bir yerden yönetmek için, bir servis sınıfı oluşturmak iyi bir pratiktir.

**`lib/services/firebase_service.dart` (Örnek - Yeni Proje İçin):**

Bu dosyayı `firebase_todo_app/lib/services/` dizinine oluşturabilirsiniz.

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // Görevleri stream olarak al
  Stream<QuerySnapshot> getTasksStream() {
    return _tasksCollection.orderBy('createdAt', descending: true).snapshots();
  }

  // Yeni görev ekle
  Future<void> addTask(String title, String description) {
    return _tasksCollection.add({
      'title': title,
      'description': description,
      'is_completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  // Görev durumunu güncelle
  Future<void> updateTaskStatus(String docId, bool isCompleted) {
    return _tasksCollection.doc(docId).update({'is_completed': isCompleted});
  }

  // Görevi sil
  Future<void> deleteTask(String docId) {
    return _tasksCollection.doc(docId).delete();
  }
}
```

Bu servisi kullanmak için `home_screen_firebase.dart` içinde bir `FirebaseService` nesnesi oluşturup ilgili metodları çağırabilirsiniz. Bu, widget'ın doğrudan Firestore detaylarıyla ilgilenmesini engeller.

---

## 6. Önceki Yöntemle Karşılaştırma (Özel Backend vs. Firebase Firestore)

| Özellik             | Özel Backend (Flask API)                     | Firebase Firestore                      |
| :------------------ | :------------------------------------------- | :-------------------------------------- |
| **Kurulum**         | Sunucu kurulumu, veritabanı yönetimi gerekir | Hızlı kurulum, sunucusuz (serverless)   |
| **Gerçek Zamanlı**  | Ekstra kütüphane/yapılandırma (örn: WebSocket) | Dahili özellik (`snapshots()`)          |
| **Ölçeklenebilirlik**| Manuel yönetim gerektirir                  | Otomatik ölçeklenir                     |
| **Maliyet**         | Sunucu maliyeti (genellikle sabit)           | Kullanıma göre (okuma/yazma/depolama)   |
| **Kontrol**         | Tam kontrol                                  | Firebase limitleri dahilinde            |
| **Backend Kodu**    | Gerekli (örn: Python, Node.js)             | Gerekli değil (çoğunlukla)              |
| **Veritabanı**      | SQL veya NoSQL (seçime bağlı)                | NoSQL (Doküman tabanlı)                 |

**Ne Zaman Hangisi?**
*   **Firebase:** Hızlı prototipleme, MVP (Minimum Viable Product), gerçek zamanlı uygulamalar, backend yönetimiyle uğraşmak istemeyenler için idealdir.
*   **Özel Backend:** Tam kontrolün gerektiği, karmaşık iş mantığı olan, belirli bir veritabanı türüne ihtiyaç duyan veya maliyet optimizasyonu kritik olan projeler için daha uygun olabilir.

---

## 7. Sonuç

Bu derste, sıfırdan bir Flutter projesi oluşturup Firebase Firestore'u nasıl entegre edeceğinizi ve temel CRUD işlemlerini (Create, Read, Update, Delete) nasıl gerçekleştireceğinizi öğrendiniz. Firestore'un `StreamBuilder` ile birlikte kullanımı, gerçek zamanlı veri güncellemelerini kolayca uygulamanıza olanak tanır. Firebase, Flutter ile uygulama geliştirme sürecini önemli ölçüde hızlandırabilen güçlü bir araçtır.

Artık sıfırdan bir Flutter projesi oluşturup Firebase Firestore ile basit bir To-Do uygulaması geliştirebilirsiniz. Projenizin gereksinimlerine göre bu temeli genişletebilirsiniz. Başarılar! 🔥
