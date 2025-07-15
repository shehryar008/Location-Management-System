# ┌─────────────── Build Stage ───────────────┐
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# copy csproj and restore only its dependencies first (cache layer)
COPY LocationCRUD.csproj .
RUN dotnet restore LocationCRUD.csproj

# copy everything else and publish release build
COPY . .
RUN dotnet publish LocationCRUD.csproj -c Release -o /app/publish

# └───────────────────────────────────────────┘


# ┌─────────────── Runtime Stage ─────────────┐
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime
WORKDIR /app

# copy published app from build stage
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:5175
EXPOSE 5175


# start your API
ENTRYPOINT ["dotnet", "LocationCRUD.dll"]
# └───────────────────────────────────────────┘
