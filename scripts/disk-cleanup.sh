#!/bin/bash

set -e

DATE=$(date '+%y-%m-%d %H:%M:%S')
log()
{
echo "[$DATE] $1"
}
check_disk(){
usage=$(df / | awk 'NR==2 {print $5}')
log "current disk usage:$usage"
}


# Remove unused Docker images
remove_docker_image(){
log "removing unsused docker images!!!"
sudo docker image prune -f
log "docker images cleaned!!"
}

# Remove stopped containers
remove_stopped_container(){
log "removed unused docker container!!!"
sudo docker container prune -f
log "removed containers"
}

# Remove unused volumes
remove_volumns(){
log "clean unwanted volumns"
sudo docker volume prune -f
log "log cleaned successfully"
}

# Remove temp files older than 7 days
remove-temporary(){
log "remove older files!!!.."
sudo find /tmp -type f -mtime +7 -delete
log "cleaned older files!!!"
}
check_disk
log "========================================="
log "Disk Cleanup Started"
log "========================================="


#call functions
check_disk
remove_docker_image
remove_stopped_container
remove_volumns
remove-temporary

# Missing these!!
log "========================================="
log "Disk Cleanup completed"
log "========================================="

