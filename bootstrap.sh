#!/bin/bash

dotnet new -i IdentityServer4.Templates
dotnet new is4ef --allow-scripts no -o is4ef
cd is4ef
    dotnet add package Microsoft.AspNetCore.Authentication.MicrosoftAccount -v 3.0.2
    patch -p1 < ../Startup.patch
    patch -p1 < ../appsettings.patch 
    mkdir Data
    dotnet user-secrets init
    cat ../etc/secrets.json | dotnet user-secrets set
    dotnet run /seed
    dotnet publish -c Release

