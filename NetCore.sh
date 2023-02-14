#!/bin/bash

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

netCoreDir="$home/$user/web/$domain/netcoreapp"

mkdir $netCoreDir
chown -R $user:$user $netCoreDir

rm "$netCoreDir/app.sock"

runuser -l $user -c "dotnet run --urls=$netCoreDir/app.sock"

if [ ! -f "$netCoreDir/app.sock" ]; then
    echo "Allow nginx access to the socket $netCoreDir/app.sock"
    chmod 777 "$netCoreDir/app.sock"
else
    echo "Sock file not present disable NetCore app"
    rm $netCoreDir/app.sock
fi
