#!/bin/bash
set -e
#variables
APP_NAME="myapp"
APP_URL="http://34.10.42.236:8081"
LOG_FILE="/var/log/health-check.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
DISK_THRESHOLD=80
MEMORY_THRESHOLD=90

log(){
echo "[$DATE] $1" | sudo tee -a $LOG_FILE 
}

check_app(){
log "checking app health..."
response=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)
if [ "$response"="200" ]; then 
log "app is healthy! HTTP: $response"
else
log "app is down!  HTTP: $response"
sudo docker restart $APP_NAME 
log "app restarted"
fi
}
check_disk(){
log "checking disk space...."
usage=$(df / |awk 'NR==2 {print $5}' | tr -d "%")
if [ "$usage" -gt "$DISK_THRESHOLD" ]; then
log "dish usage is HIGH:${usage}%"
log "please run disk cleanup!!!!"
else 
log "disk usage is ok: ${usage}%"
fi
}
check_memory(){
log "checking memory usage....."
usage=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ "$usage" -gt "$MEMORY_THRESHOLD" ]; then
log "momory usage is HIGH:${usage}%"
else 
log "momory usage is OK:${usage}%"
fi
}
check_container(){
log "checking docker container...."
container=$(sudo docker ps | grep $APP_NAME)
if [ -z "$container" ]; then
log "container is not running !!"
log "starting container ....."
sudo docker start $APP_NAME
log "container started !!!"
else 
log "container is running !!"
fi 
}
log "========================================="
log "🚀 Health Check Started"
log "========================================="

check_container
check_app
check_disk
check_memory

log "========================================="
log "✅ Health Check Completed"
log "========================================="
