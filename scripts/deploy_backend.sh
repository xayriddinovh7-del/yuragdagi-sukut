#!/bin/bash
# ─── Backend Deploy Script ─────────────────────────────────────────────────────
# Dart Shelf backend ni remote serverga deploy qilish
# Server: 109.94.175.237:22 (SSH)
# App port: 4422
# User: pittsmoo

set -e

SERVER_IP="109.94.175.237"
SERVER_USER="pittsmoo"
SERVER_PASS="test123!"
APP_PORT="4422"
REMOTE_DIR="/home/pittsmoo/yuragdagi_sukut_backend"
BACKEND_DIR="$(cd "$(dirname "$0")/../backend" && pwd)"

echo "🚀 Backend deploy boshlandi..."
echo "📍 Local: $BACKEND_DIR"
echo "📡 Remote: $SERVER_USER@$SERVER_IP:$REMOTE_DIR"
echo ""

# ─── 1. Remote directory yaratish ─────────────────────────────────────────────
echo "📁 Remote directory yaratilmoqda..."
sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" \
  "mkdir -p $REMOTE_DIR/bin $REMOTE_DIR/lib/routes $REMOTE_DIR/lib/data $REMOTE_DIR/lib/models $REMOTE_DIR/lib/middleware"

# ─── 2. Backend fayllarni yuborish ────────────────────────────────────────────
echo "📤 Fayllar yuborilmoqda..."

# pubspec.yaml
sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
  "$BACKEND_DIR/pubspec.yaml" \
  "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/"

# bin/server.dart
sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
  "$BACKEND_DIR/bin/server.dart" \
  "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/bin/"

# lib files
sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
  "$BACKEND_DIR/lib/routes/book_routes.dart" \
  "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/lib/routes/"

sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
  "$BACKEND_DIR/lib/routes/health_routes.dart" \
  "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/lib/routes/"

sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
  "$BACKEND_DIR/lib/data/book_content.dart" \
  "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/lib/data/"

sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
  "$BACKEND_DIR/lib/models/api_response.dart" \
  "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/lib/models/"

sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
  "$BACKEND_DIR/lib/middleware/cors_middleware.dart" \
  "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/lib/middleware/"

echo "✅ Fayllar yuborildi"

# ─── 3. Remote serverda Dart o'rnatish va app ishga tushirish ─────────────────
echo "⚙️  Serverda sozlanmoqda..."

sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" << REMOTE_SCRIPT
set -e

# Dart borligini tekshirish
if ! command -v dart &> /dev/null; then
  echo "📦 Dart o'rnatilmoqda..."
  # Dart SDK o'rnatish (Linux)
  sudo apt-get update -qq
  sudo apt-get install -y apt-transport-https
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  sudo apt-get update -qq
  sudo apt-get install -y dart
  echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.bashrc
  export PATH="\$PATH:/usr/lib/dart/bin"
fi

# Dart versiyasini ko'rsatish
dart --version 2>/dev/null || /usr/lib/dart/bin/dart --version

# Dependencies olish
cd $REMOTE_DIR
export PATH="\$PATH:/usr/lib/dart/bin"
dart pub get

echo "✅ Dependencies o'rnatildi"
REMOTE_SCRIPT

# ─── 4. systemd service yaratish ──────────────────────────────────────────────
echo "⚙️  systemd service yaratilmoqda..."

sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" << SERVICE_SCRIPT
# Eski processni to'xtatish
pkill -f "dart.*server.dart" 2>/dev/null || true
sleep 1

# systemd service fayli (sudo kerak)
sudo tee /etc/systemd/system/yuragdagi-sukut-api.service > /dev/null << 'EOF'
[Unit]
Description=Yuragdagi Sukut API Server
After=network.target
Wants=network.target

[Service]
Type=simple
User=pittsmoo
WorkingDirectory=/home/pittsmoo/yuragdagi_sukut_backend
Environment="PORT=4422"
Environment="PATH=/usr/lib/dart/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart=/usr/lib/dart/bin/dart run bin/server.dart
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable yuragdagi-sukut-api
sudo systemctl restart yuragdagi-sukut-api

sleep 3

# Status tekshirish
sudo systemctl status yuragdagi-sukut-api --no-pager || true
SERVICE_SCRIPT

echo ""
echo "✅ Deploy tugadi!"
echo "🌐 API: http://$SERVER_IP:$APP_PORT/api/books"
echo "❤️  Health: http://$SERVER_IP:$APP_PORT/health"
