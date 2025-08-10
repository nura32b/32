#!/bin/bash
set -e

echo "================================"
echo "   Streamdeck Quick Installer   "
echo "================================"
echo

read -p "Mulai instalasi? (y/n): " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && echo "Instalasi dibatalkan." && exit 1

echo "[1/8] Update sistem..."
sudo apt update && sudo apt upgrade -y

echo "[2/8] Install Node.js..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "[3/8] Install FFmpeg & Git..."
sudo apt install -y ffmpeg git

echo "[4/8] Clone repository..."
git clone https://github.com/nura32b/32.git
cd 32

echo "[5/8] Install dependencies & generate secret..."
npm install
npm run generate-secret || true

echo "[6/8] Set timezone (Asia/Makassar)..."
# Ganti ke Asia/Jakarta bila mau: sudo timedatectl set-timezone Asia/Jakarta
sudo timedatectl set-timezone Asia/Makassar || true

echo "[7/8] Firewall (UFW)..."
sudo ufw allow ssh
sudo ufw allow 7575/tcp
sudo ufw --force enable

echo "[8/8] Install PM2 & start app..."
sudo npm install -g pm2
pm2 start app.js --name streamdeck
pm2 save

echo
echo "================================"
echo "✅ INSTALASI SELESAI!"
echo "================================"

SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
echo
echo "🌐 URL Akses:  http://$SERVER_IP:7575"
echo
echo "📋 Langkah selanjutnya:"
echo "1) Buka URL di browser"
echo "2) Buat username & password"
echo "3) Setelah membuat akun, Sign Out lalu login kembali untuk sinkronisasi database"
echo "================================"
