#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build

WORKDIR /src
COPY *.sln .
COPY ["FurnitureApi/DataServiceApi.csproj", "FurnitureApi/"]
COPY ["TestDataServicesApi/TestDataServicesApi.csproj", "TestDataServicesApi/"]
RUN dotnet restore "FurnitureApi/DataServiceApi.csproj"
COPY . .
WORKDIR "/src/FurnitureApi"
RUN dotnet build "DataServiceApi.csproj" -c Release -o /app/build




COPY . .

# testing
FROM build AS testing
WORKDIR /src/TestDataServicesApi
RUN dotnet test

FROM build AS publish
RUN dotnet publish "DataServiceApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ProductService.dll"]
