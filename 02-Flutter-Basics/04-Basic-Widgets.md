# Temel Flutter Widget'ları

![Basic Widgets](https://docs.flutter.dev/assets/images/docs/widget-catalog/material-app-bar.png)

## Layout Widget'ları

### Container
En temel layout widget'ı, padding, margin, decoration gibi özellikleri vardır:

```dart
Container(
  margin: EdgeInsets.all(10.0),
  padding: EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 10.0,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Text('Container Örneği'),
)
```

### Row ve Column
Yatay ve dikey düzenleme için kullanılır:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Birinci Satır'),
    Text('İkinci Satır'),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
      ],
    ),
  ],
)
```

### Stack
Widget'ları üst üste yerleştirmek için kullanılır:

```dart
Stack(
  children: [
    Image.network('https://picsum.photos/200/300'),
    Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.black54,
        child: Text(
          'Resim Açıklaması',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
)
```

## Temel UI Widget'ları

### Text
Metin gösterimi için kullanılır:

```dart
Text(
  'Merhaba Flutter!',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    letterSpacing: 1.2,
    shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(1, 1),
        blurRadius: 2,
      ),
    ],
  ),
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### Image
Görsel gösterimi için kullanılır:

```dart
// Ağdan resim yükleme
Image.network(
  'https://picsum.photos/200/300',
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator();
  },
)

// Asset'ten resim yükleme
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)
```

### Icon
Simge gösterimi için kullanılır:

```dart
Icon(
  Icons.favorite,
  color: Colors.red,
  size: 24.0,
)
```

## Input Widget'ları

### TextField
Metin girişi için kullanılır:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Kullanıcı Adı',
    hintText: 'Kullanıcı adınızı giriniz',
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 2.0),
    ),
  ),
  onChanged: (value) {
    print('Girilen değer: $value');
  },
  obscureText: false, // Şifre girişi için true
  keyboardType: TextInputType.text,
)
```

### Button'lar
Çeşitli buton tipleri:

```dart
// Elevated Button
ElevatedButton(
  onPressed: () {
    print('Butona tıklandı');
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Text('Elevated Button'),
)

// Text Button
TextButton(
  onPressed: () {},
  child: Text('Text Button'),
)

// Outlined Button
OutlinedButton(
  onPressed: () {},
  child: Text('Outlined Button'),
)

// Icon Button
IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {},
)
```

## Liste Widget'ları

### ListView
Kaydırılabilir liste için kullanılır:

```dart
// Basit ListView
ListView(
  children: [
    ListTile(
      leading: Icon(Icons.person),
      title: Text('Kullanıcı 1'),
      subtitle: Text('Açıklama'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    ),
    ListTile(
      leading: Icon(Icons.person),
      title: Text('Kullanıcı 2'),
    ),
  ],
)

// ListView.builder
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Öğe $index'),
    );
  },
)

// ListView.separated
ListView.separated(
  itemCount: 100,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Öğe $index'),
    );
  },
)
```

### GridView
Izgara düzeninde liste için kullanılır:

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 1,
  ),
  itemCount: 100,
  itemBuilder: (context, index) {
    return Card(
      child: Center(
        child: Text('Öğe $index'),
      ),
    );
  },
)
```

## Kart ve Liste Öğeleri

### Card
Kartlar için kullanılır:

```dart
Card(
  elevation: 4.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        Image.network('https://picsum.photos/200/300'),
        SizedBox(height: 8.0),
        Text(
          'Kart Başlığı',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text('Kart içeriği buraya gelecek...'),
      ],
    ),
  ),
)
```

### ListTile
Liste öğeleri için kullanılır:

```dart
ListTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://picsum.photos/200'),
  ),
  title: Text('Kullanıcı Adı'),
  subtitle: Text('Kullanıcı açıklaması'),
  trailing: Icon(Icons.more_vert),
  onTap: () {
    print('Liste öğesine tıklandı');
  },
)
```

## Dialog ve Bottom Sheet

### AlertDialog
Uyarı dialogları için kullanılır:

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Uyarı'),
    content: Text('Bu bir uyarı mesajıdır.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('İptal'),
      ),
      TextButton(
        onPressed: () {
          // İşlem
          Navigator.pop(context);
        },
        child: Text('Tamam'),
      ),
    ],
  ),
);
```

### BottomSheet
Alt sayfalar için kullanılır:

```dart
showModalBottomSheet(
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (context) => Container(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Bottom Sheet Başlığı',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text('Bottom Sheet içeriği...'),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Kapat'),
        ),
      ],
    ),
  ),
);
```

Bu temel widget'lar, Flutter uygulamalarının yapı taşlarıdır. Bu widget'ları birleştirerek karmaşık kullanıcı arayüzleri oluşturabilirsiniz. 