FROM mcr.microsoft.com/dotnet/core/sdk
EXPOSE 5000
WORKDIR /srv
RUN dotnet new -i IdentityServer4.Templates
RUN dotnet new is4ef --allow-scripts no
RUN dotnet add package Microsoft.AspNetCore.Authentication.MicrosoftAccount -v 3.0.2
RUN mkdir Data
COPY appsettings.patch /srv
COPY Startup.patch /srv
RUN apt-get update 
RUN apt-get install patch
RUN patch -p1 < Startup.patch
RUN patch -p1 < appsettings.patch 
RUN rm appsettings.patch
RUN rm Startup.patch
COPY ./etc/secrets.json /srv
RUN dotnet user-secrets init
RUN cat secrets.json | dotnet user-secrets set
RUN rm secrets.json 
ENTRYPOINT ["./bin/Debug/netcoreapp3.0/srv", "--urls", "http://0.0.0.0:5000"]
