FROM mcr.microsoft.com/dotnet/sdk:10.0-preview-noble AS builder
ARG TARGETARCH

WORKDIR /app

COPY src/cartservice.csproj .

RUN dotnet restore cartservice.csproj

COPY src/ .

RUN dotnet publish cartservice.csproj \
    -p:PublishSingleFile=true \
    --self-contained \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -c release \
    -o /cartservice
    
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0.0-noble-chiseled@sha256:b857c8cb8d929183cfe4c6dd9994abba92a2639dd2dbaf06005379f815991604

WORKDIR /app

COPY --from=builder /cartservice .

EXPOSE 7070

ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_HTTP_PORTS=7070

USER 1000

ENTRYPOINT ["/app/cartservice"]
