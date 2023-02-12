#!/bin/bash

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

#default script name
mainScript="app.js"
netCoreDir="$home/$user/web/$domain/netcoreapp"

mkdir $netCoreDir
chown -R $user:$user $netCoreDir

rm "$netCoreDir/app.sock"

runuser -l $user -c "$envFile PORT=$netCoreDir/app.sock HOST=127.0.0.1 PWD=$netCoreDir NODE_ENV=production pm2 start $pmPath --name $scriptName $nodeInterpreter"

if [ ! -f "$netCoreDir/app.sock" ]; then
    echo "Allow nginx access to the socket $netCoreDir/app.sock"
    chmod 777 "$netCoreDir/app.sock"
else
    echo "Sock file not present disable NetCore app"
    rm $netCoreDir/app.sock
fi
