FROM mcr.microsoft.com/dotnet/sdk:9.0

WORKDIR /app

COPY LocationCRUD.csproj ./
RUN dotnet restore --disable-parallel

COPY . ./
RUN dotnet publish LocationCRUD.csproj -c Release -o out

ENV ASPNETCORE_URLS=http://+:5175
EXPOSE 5175

ENTRYPOINT ["dotnet", "out/LocationCRUD.dll"]
