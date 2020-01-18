# IdentityServer4 bootstrap

This script is intended to build an [IdentityServer4](http://docs.identityserver.io/en/latest/) instance with Microsoft Oauth2 authentication feature included.

First, create the file `./etc/secrets.json`. It should contain records about your Azure application credentials:

```json
{
    "Authentication:Client:Microsoft:Id": "xx2exxx2-dxxb-xx1x-x0xe-5ccx3x5exx1x",
    "Authentication:Client:Microsoft:Secret": "xxvxLxxBmxe:5xxx6:H=@mxxxXuDx69P",
}
```

Then you can run

```bash
./bootstrap.sh
```

This script will create `is4ef` directory with binary release of your server. Just go into `./is4ef/bin/Release/netcoreapp3.0/publish/` and run `./is4ef`.

Microsoft [recommends](https://docs.microsoft.com/ru-ru/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-3.1) also to create an ini-script for starting the servise and to configure Nginx as a proxy-server for IdentityServer4, that runs on port 5000. There is example configurations:

```bash
sudo vim /etc/systemd/system/is4boot.service
```

```ini
[Unit]
Description=Example .NET Web API App running on Ubuntu

[Service]
WorkingDirectory=/var/www/helloapp
ExecStart=/usr/bin/dotnet /var/www/helloapp/helloapp.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-example
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
```

```conf
server {
    listen        80;
    server_name   example.com *.example.com;
    location / {
        proxy_pass         http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
}
```
## Using in docker

There is also Dockerfile. Use it to build an image:

```bash
sudo docker build . --tag is4boot:publish
```

Then run it:

```bash
sudo docker run -p 5000:5000 -v /path/to/auth.db/dir/:/srv/bin/Release/netcoreapp3.0/publish/Data -it is4boot:publish
```
After starting you can start IS4 as

```bash
cd /srv/bin/Release/netcoreapp3.0/publish/ && ./srv --urls http://0.0.0.0:5000
```

or create another docker-image with

```docker
FROM is4boot:publish
WORKDIR /srv/bin/Release/netcoreapp3.0/publish/
ENTRYPOINT ["./srv", "--urls", "http://0.0.0.0:5000"]
```


