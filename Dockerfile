# https://hub.docker.com/_/microsoft-dotnet

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY LeilaoApi/*.csproj ./LeilaoApi/
COPY LeilaoApi.Test/*.csproj ./LeilaoApi.Test/
RUN dotnet restore

# copy everything else and build app
COPY LeilaoApi/. ./LeilaoApi/
COPY LeilaoApi.Test/. ./LeilaoApi.Test/
WORKDIR /source/LeilaoApi
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "LeilaoApi.dll"]