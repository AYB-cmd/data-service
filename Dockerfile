FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

WORKDIR /src
COPY *.sln .
COPY TestDataServicesApi/*.csproj TestDataServicesApi/
COPY FurnitureApi/*.csproj FurnitureApi/
RUN dotnet restore
COPY . .

# testing
FROM build AS testing
WORKDIR /src/FurnitureApi
RUN dotnet build
WORKDIR /src/TestDataServicesApi
RUN dotnet test

# publish
FROM build AS publish
WORKDIR /src/FurnitureApi
RUN dotnet publish -c Release -o /src/publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
# ENTRYPOINT ["dotnet", "Colors.API.dll"]
# heroku uses the following
CMD ASPNETCORE_URLS=http://*:$PORT dotnet TestDataServicesApi.dll