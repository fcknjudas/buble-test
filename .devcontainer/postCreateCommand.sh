#!/bin/bash

set -e

echo "🚀 Starting Piped setup in GitHub Codespaces..."

# Установка JDK 17 (требуется для Piped Backend)
echo "📦 Installing OpenJDK 17..."
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk

# Проверка установки Java
java -version

# Установка Node.js и npm (для фронтенда)
echo "📦 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

node --version
npm --version

# Клонирование Piped Backend
echo "⬇️ Cloning Piped Backend..."
git clone https://github.com/TeamPiped/Piped.git piped-backend
cd piped-backend

# Сборка бэкенда (Gradle)
echo "🔨 Building Piped Backend with Gradle..."
./gradlew build -x test  # пропускаем тесты для ускорения

# Запуск бэкенда в фоне
echo "🟢 Starting Piped Backend on port 8080..."
nohup ./gradlew bootRun > backend.log 2>&1 &

cd ..

# Клонирование Piped Frontend
echo "⬇️ Cloning Piped Frontend..."
git clone https://github.com/TeamPiped/Piped-Frontend.git piped-frontend
cd piped-frontend

# Установка зависимостей фронтенда
echo "📦 Installing frontend dependencies..."
npm install

# Создание .env файла с указанием на локальный бэкенд
cat > .env <<EOF
VITE_API_URL=http://localhost:8080
VITE_INVIDIOUS_API_URL=https://invidious.io  # fallback, можно заменить
EOF

# Сборка и запуск фронтенда в фоне
echo "🔨 Building and starting Piped Frontend on port 3000..."
nohup npm run dev -- --host --port 3000 > frontend.log 2>&1 &

cd ..

echo "✅ Piped Backend запущен на порту 8080"
echo "✅ Piped Frontend запущен на порту 3000"
echo "📌 В GitHub Codespaces открой Ports и пробрось порты 8080 и 3000"
echo "🌐 Открой Preview для порта 3000 — это будет интерфейс Piped"

# Опционально: вывод логов в реальном времени (можно закомментировать)
# tail -f piped-backend/backend.log &
# tail -f piped-frontend/frontend.log &
