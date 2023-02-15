#!/bin/bash
# https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-7.0&tabs=linux-ubuntu
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

# create netcoreapp dir
mkdir $netCoreDir
chown -R $user:$user $netCoreDir

# create netcoreapp service
# nano /etc/systemd/system/$domain.service

cat <<EOF > /etc/systemd/system/$domain.service
[Unit]
Description=$domain

[Service]
Type=notify
WorkingDirectory=$netCoreDir
ExecStart=/usr/bin/dotnet $netCoreDir/$domain.dll
SyslogIdentifier=$domain
Restart=always
RestartSec=5
KillSignal=SIGINT
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false
Environment=ASPNETCORE_URLS=$netCoreDir/app.sock

[Install]
WantedBy=multi-user.target
EOF

# systemctl daemon-reload
# systemctl enable $domain.service
# systemctl start $domain.service

# allow nginx access
# chown nginx:nginx $netCoreDir/app.sock