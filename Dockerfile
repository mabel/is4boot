FROM mcr.microsoft.com/dotnet/core/sdk
EXPOSE 5000
WORKDIR /srv
RUN dotnet new -i IdentityServer4.Templates
RUN dotnet new is4ef --allow-scripts no
RUN dotnet add package Microsoft.AspNetCore.Authentication.MicrosoftAccount -v 3.0.2
RUN mkdir Data
RUN apt-get update 
RUN apt-get install patch
COPY Startup.patch /srv
COPY appsettings.patch /srv
COPY Program.patch /srv
RUN patch -p1 < Startup.patch
RUN patch -p1 < appsettings.patch 
RUN patch -p1 < Program.patch 
RUN rm *.patch
COPY ./etc/secrets.json /srv
RUN dotnet publish -c Release
ENTRYPOINT ["/bin/bash"]
# cd /srv/bin/Release/netcoreapp3.0/publish/ && ./srv --urls http://0.0.0.0:5000

