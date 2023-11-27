# FROM microsoft/dotnet:2.1-sdk AS build
FROM registry.access.redhat.com/ubi8/dotnet-70 AS build
WORKDIR /app
USER root

# copy csproj and restore as distinct layers
COPY *.csproj .
RUN dotnet restore

# copy and build everything else
COPY . .
RUN dotnet publish -c Release -o out

# test webhook

# FROM microsoft/dotnet:2.1-runtime AS runtime
FROM registry.access.redhat.com/ubi8/dotnet-70-runtime
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "hello-world-dotnet.dll"]
