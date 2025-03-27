# PostgreSQL ile Flutter Bağlantısı

## Giriş
Bu bölümde, Flutter ile PostgreSQL kullanarak basit bir "To-Do" uygulaması geliştireceğiz. Aşağıdaki adımları takip edeceğiz:

1. PostgreSQL veri tabanı yapısını oluşturma
2. Verileri servis eden bir web servisi oluşturma

---

## 1. PostgreSQL Veri Tabanı Yapısını Oluşturma

Öncelikle PostgreSQL üzerinde "To-Do" uygulaması için bir veri tabanı oluşturacağız. Terminali açıp PostgreSQL'e bağlanalım:

```sh
psql -U postgres
```

Yeni bir veri tabanı oluşturalım:

```sql
CREATE DATABASE todo_app;
```

Oluşturulan veri tabanına bağlanalım:

```sh
\c todo_app
```

Şimdi "tasks" tablosunu oluşturalım:

```sql
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 2. Web Servisi Oluşturma

Verileri sağlayan bir REST API oluşturacağız. `Flask` ve `Psycopg2` kullanarak basit bir web servisi yazalım. Önce bir proje dizini oluşturun ve içine girin:

```sh
mkdir todo_api && cd todo_api
```

Gerekli paketleri yükleyin:

```sh
pip install flask psycopg2 flask-cors
```

Şimdi bir `service.py` dosyası oluşturup içine aşağıdaki kodları ekleyelim:

```python
from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2

app = Flask(__name__)
CORS(app)

# PostgreSQL bağlantısı
conn = psycopg2.connect(
    dbname="todo_app",
    user="postgres",
    password="sifre", # <--- buradaki  şifreyi değiştirmeyi unutmayın
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

@app.route('/tasks', methods=['GET'])
def get_tasks():
    cursor.execute("SELECT * FROM tasks")
    tasks = cursor.fetchall()
    task_list = [
        {"id": row[0], "title": row[1], "description": row[2], "is_completed": row[3], "created_at": row[4]} 
        for row in tasks
    ]
    return jsonify(task_list)

@app.route('/tasks', methods=['POST'])
def add_task():
    data = request.json
    cursor.execute("INSERT INTO tasks (title, description, is_completed) VALUES (%s, %s, %s) RETURNING id", 
                   (data['title'], data.get('description', ''), data.get('is_completed', False)))
    conn.commit()
    return jsonify({"id": cursor.fetchone()[0]}), 201

@app.route('/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    cursor.execute("DELETE FROM tasks WHERE id = %s", (task_id,))
    conn.commit()
    return jsonify({"message": "Task deleted"})

if __name__ == '__main__':
    app.run(debug=True, port=5000)
```

Bu aşamadan sonra web servisi çalıştırarak Flutter uygulamamızı geliştirmeye başlayabiliriz.

```sh
python server.py
```

# Sonuç

Bu bölümde, PostgreSQL veri tabanı ve Flask web servisi kurulumunu tamamladık. Oluşturduğumuz API endpoints ile temel CRUD işlemlerini gerçekleştirebilecek bir altyapı hazırladık. Bu web servisi, Flutter uygulamamız için gerekli veri altyapısını sağlayacaktır. Bir sonraki adımda Flutter uygulamasını geliştirerek bu servisle iletişim kuracağız.