FROM mcr.microsoft.com/dotnet/core/sdk
EXPOSE 5000
WORKDIR /srv
RUN dotnet new -i IdentityServer4.Templates
RUN dotnet new is4ef --allow-scripts no
RUN dotnet add package Microsoft.AspNetCore.Authentication.MicrosoftAccount -v 3.0.2
RUN mkdir Data
