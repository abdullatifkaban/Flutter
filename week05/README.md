# Hafta 5: PostgreSQL ve REST API

Bu haftada HabitMaster uygulamamıza PostgreSQL veritabanı entegrasyonu yapacağız ve REST API tasarlayacağız.

## 🎯 Hedefler

- PostgreSQL veritabanı kurulumu
- REST API tasarımı
- Backend servisleri
- API entegrasyonu

## 📝 Konu Başlıkları

1. PostgreSQL Veritabanı
   - PostgreSQL kurulumu
   - Veritabanı tasarımı
   - SQL sorguları
   - Migration yönetimi

2. REST API
   - API tasarım prensipleri
   - Endpoint tasarımı
   - HTTP metodları
   - Status kodları

3. Backend Servisleri
   - Node.js/Express kurulumu
   - API route'ları
   - Middleware yapısı
   - Error handling

## 💻 Adım Adım Uygulama Geliştirme

### 1. PostgreSQL Veritabanı Tasarımı

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE habits (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    reminder_time TIME NOT NULL,
    frequency INTEGER NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE habit_logs (
    id SERIAL PRIMARY KEY,
    habit_id INTEGER REFERENCES habits(id),
    completed_at TIMESTAMP NOT NULL,
    notes TEXT
);
```

### 2. REST API Endpoint'leri

```javascript
// Express.js route tanımlamaları
const router = express.Router();

// Habits endpoints
router.get('/habits', authenticateUser, async (req, res) => {
  try {
    const habits = await db.query(
      'SELECT * FROM habits WHERE user_id = $1',
      [req.user.id]
    );
    res.json(habits.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/habits', authenticateUser, async (req, res) => {
  const { title, description, type, reminderTime, frequency } = req.body;
  try {
    const result = await db.query(
      `INSERT INTO habits (user_id, title, description, type, reminder_time, frequency)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [req.user.id, title, description, type, reminderTime, frequency]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
```

### 3. Flutter'da API Entegrasyonu

```dart
class HabitApiService {
  final String baseUrl = 'https://api.habitmaster.com';
  final String token;

  HabitApiService(this.token);

  Future<List<Habit>> getHabits() async {
    final response = await http.get(
      Uri.parse('$baseUrl/habits'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> habitsJson = jsonDecode(response.body);
      return habitsJson.map((json) => Habit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load habits');
    }
  }

  Future<Habit> createHabit(Habit habit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/habits'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(habit.toJson()),
    );

    if (response.statusCode == 201) {
      return Habit.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create habit');
    }
  }
}
```

## 📝 Ödevler

1. JWT authentication ekleyin
2. API rate limiting implementasyonu yapın
3. API dokümantasyonu oluşturun (Swagger/OpenAPI)

## 🔍 Sonraki Adımlar

Gelecek hafta:
- MongoDB entegrasyonu
- NoSQL veritabanı yönetimi
- Gerçek zamanlı veri senkronizasyonu 