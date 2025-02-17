# 빌드 스테이지
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY src/Battle/. .
RUN dotnet restore

RUN dotnet publish -c Release -o /app/publish  \
    --no-restore  \
    /p:UseAppHost=false \
    --self-contained false 


# 런타임 스테이지
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Battle.dll"]

