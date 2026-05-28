#!/bin/bash

set -e

APP_NAME="webserver"
VERSION=$1

if [ -z "$VERSION" ]; then
    echo "❌ Please provide version!"
    echo "Usage: ./deploy.sh v1"
    exit 1
fi
build_image(){
echo "🚀 Building $APP_NAME:$VERSION..."
sudo docker build -t $APP_NAME:$VERSION .
}

stop_container(){
echo "🐳 Running container..."
sudo docker stop $APP_NAME 2>/dev/null || true
sudo docker rm $APP_NAME 2>/dev/null || true
}
create_container(){
sudo docker run -d -p 9090:8080 --name $APP_NAME $APP_NAME:$VERSION
}
#call functions
build_image
stop_container
create_container

echo "✅ $APP_NAME:$VERSION is live!!"
