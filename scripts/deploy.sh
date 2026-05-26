#!/bin/bash

set -e

APP_NAME="myapp"
VERSION=$1

if [ -z "$VERSION" ]; then
    echo "❌ Please provide version!"
    echo "Usage: ./deploy.sh v1"
    exit 1
fi

echo "🚀 Building $APP_NAME:$VERSION..."
sudo docker build -t $APP_NAME:$VERSION .

echo "🐳 Running container..."
sudo docker stop $APP_NAME 2>/dev/null || true
sudo docker rm $APP_NAME 2>/dev/null || true
sudo docker run -d -p 8081:8080 --name $APP_NAME $APP_NAME:$VERSION

echo "✅ $APP_NAME:$VERSION is live!!"
