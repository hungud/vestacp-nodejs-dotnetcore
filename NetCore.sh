#!/bin/bash

# fix for .sh to run on unix
#notepad++ => https://stackoverflow.com/a/24013333
#cd /usr/local/vesta/data/templates/web/nginx/
#sed -i -e 's/\r$//' NetCore.sh

#run debug: 
#/usr/local/vesta/data/templates/web/nginx/NetCore.sh admin domain 127.0.0.1 /home

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

netCoreDir="$home/$user/web/$domain/netcoreapp"

mkdir $netCoreDir
chown -R $user:$user $netCoreDir

rm "$netCoreDir/app.sock"

#remove blank spaces
pmPath=$(echo "$netCoreDir" | tr -d ' ')
runuser -l $user -c "dotnet run $pmPath --urls=$netCoreDir/app.sock"

if [ ! -f "$netCoreDir/app.sock" ]; then
    echo "Allow nginx access to the socket $netCoreDir/app.sock"
    chmod 777 "$netCoreDir/app.sock"
else
    echo "Sock file not present disable NetCore app"
    rm $netCoreDir/app.sock
fi
