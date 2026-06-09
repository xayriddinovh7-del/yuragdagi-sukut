# ─── Dart Shelf Backend Dockerfile ─────────────────────────────────────────────
# Multi-stage build: build bosqichi + minimal runtime
FROM dart:stable AS build

WORKDIR /app

# Dependency caching uchun avval pubspec nusxalash
COPY pubspec.yaml .
RUN dart pub get

# Source code nusxalash
COPY bin/ bin/
COPY lib/ lib/

# AOT compile (tezroq startup)
RUN dart compile exe bin/server.dart -o bin/server

# ─── Runtime image ─────────────────────────────────────────────────────────────
FROM debian:bullseye-slim

WORKDIR /app

# Faqat compiled binary nusxalash
COPY --from=build /app/bin/server /app/bin/server
COPY --from=build /runtime/ /

# Dart runtime libraries
COPY --from=build /usr/lib/dart/lib/ /usr/lib/dart/lib/

RUN chmod +x /app/bin/server

# App port
EXPOSE 8080

# Server ishga tushirish
ENV PORT=8080
CMD ["/app/bin/server"]
