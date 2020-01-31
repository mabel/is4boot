FROM mcr.microsoft.com/dotnet/core/sdk
RUN apt-get update 
RUN apt-get install patch
EXPOSE 5000
WORKDIR /srv
RUN  dotnet new mvc --auth Individual
RUN  dotnet add package Microsoft.AspNetCore.Authentication.MicrosoftAccount -v 3.0.2
RUN  dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
RUN  dotnet add package Microsoft.EntityFrameworkCore.SqlServer
RUN  dotnet new tool-manifest
RUN  dotnet tool install dotnet-aspnet-codegenerator
RUN  dotnet aspnet-codegenerator identity -dc srv.Data.ApplicationDbContext --files "Account.Register;Account.Login"
ADD  roles.tgz /srv
COPY etc/secrets.json /srv
COPY Startup.patch /srv
COPY appsettings.patch /srv
COPY Program.patch /srv
RUN  rm app.db
RUN  ln -s /data/app.db app.db
RUN  patch -p1 < Program.patch 
RUN  patch -p1 < Startup.patch
RUN  rm *.patch
ENTRYPOINT ["dotnet", "watch", "run", "--urls", "http://0.0.0.0:5000"]
#ENTRYPOINT ["/bin/bash"]

