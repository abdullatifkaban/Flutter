# Hafta 6: MongoDB ve Gerçek Zamanlı Veri

Bu haftada HabitMaster uygulamamıza MongoDB entegrasyonu yapacağız ve gerçek zamanlı veri senkronizasyonunu öğreneceğiz.

## 🎯 Hedefler

- MongoDB veritabanı kurulumu
- NoSQL veri modelleme
- Gerçek zamanlı veri senkronizasyonu
- Socket.IO implementasyonu

## 📝 Konu Başlıkları

1. MongoDB Veritabanı
   - MongoDB Atlas kurulumu
   - NoSQL veri modelleme
   - CRUD operasyonları
   - Mongoose şemaları

2. Gerçek Zamanlı Veri
   - WebSocket protokolü
   - Socket.IO kurulumu
   - Event-driven mimari
   - Bağlantı yönetimi

3. Senkronizasyon
   - Offline-first yaklaşımı
   - Veri çakışması çözümü
   - Optimistic UI updates
   - Error handling

## 💻 Adım Adım Uygulama Geliştirme

### 1. MongoDB Şemaları

```javascript
// Mongoose şemaları
const habitSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: String,
  type: {
    type: String,
    enum: ['daily', 'weekly', 'monthly'],
    required: true
  },
  reminderTime: {
    type: Date,
    required: true
  },
  frequency: {
    type: Number,
    required: true
  },
  isCompleted: {
    type: Boolean,
    default: false
  },
  streak: {
    type: Number,
    default: 0
  },
  completionHistory: [{
    date: Date,
    completed: Boolean,
    notes: String
  }]
}, { timestamps: true });
```

### 2. Socket.IO Server

```javascript
// Socket.IO server kurulumu
const io = require('socket.io')(server);

io.on('connection', (socket) => {
  console.log('Client connected');

  socket.on('join-room', (userId) => {
    socket.join(`user-${userId}`);
  });

  socket.on('habit-completed', async (data) => {
    try {
      const habit = await Habit.findByIdAndUpdate(
        data.habitId,
        { 
          $set: { isCompleted: true },
          $push: { 
            completionHistory: {
              date: new Date(),
              completed: true,
              notes: data.notes
            }
          }
        },
        { new: true }
      );

      io.to(`user-${habit.userId}`).emit('habit-updated', habit);
    } catch (err) {
      socket.emit('error', err.message);
    }
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});
```

### 3. Flutter'da Socket.IO Client

```dart
class HabitSocketService {
  late IO.Socket socket;
  final String userId;

  HabitSocketService(this.userId) {
    socket = IO.io('https://api.habitmaster.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('Socket connected');
      socket.emit('join-room', userId);
    });

    socket.onDisconnect((_) => print('Socket disconnected'));
    socket.connect();
  }

  void listenToHabitUpdates(Function(Habit) onHabitUpdated) {
    socket.on('habit-updated', (data) {
      final habit = Habit.fromJson(data);
      onHabitUpdated(habit);
    });
  }

  void completeHabit(String habitId, {String? notes}) {
    socket.emit('habit-completed', {
      'habitId': habitId,
      'notes': notes,
    });
  }

  void dispose() {
    socket.dispose();
  }
}
```

## 📝 Ödevler

1. Offline-first yaklaşımını implemente edin
2. Gerçek zamanlı bildirimler ekleyin
3. Veri senkronizasyon çakışmalarını çözün

## 🔍 Sonraki Adımlar

Gelecek hafta:
- Bildirim sistemi
- Firebase Cloud Messaging
- Local notifications 