# Stage 1
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS builder
WORKDIR /source

# caches restore result by copying csproj file separately
#COPY /NuGet.config /source/
COPY /DeveVipAccessTokenGenerator/*.csproj /source/DeveVipAccessTokenGenerator/
COPY /DeveVipAccessTokenGenerator.ConsoleApp/*.csproj /source/DeveVipAccessTokenGenerator.ConsoleApp/
COPY /DeveVipAccessTokenGenerator.Tests/*.csproj /source/DeveVipAccessTokenGenerator.Tests/
COPY /DeveVipAccessTokenGenerator.sln /source/
RUN ls
RUN dotnet restore

# copies the rest of your code
COPY . .
RUN dotnet build --configuration Release
RUN dotnet test --configuration Release ./DeveVipAccessTokenGenerator.Tests/DeveVipAccessTokenGenerator.Tests.csproj
RUN dotnet publish ./DeveVipAccessTokenGenerator.ConsoleApp/DeveVipAccessTokenGenerator.ConsoleApp.csproj --output /app/ --configuration Release

# Stage 2
FROM mcr.microsoft.com/dotnet/core/runtime:2.2-alpine3.9
WORKDIR /app
COPY --from=builder /app .
ENTRYPOINT ["dotnet", "DeveVipAccessTokenGenerator.ConsoleApp.dll"]