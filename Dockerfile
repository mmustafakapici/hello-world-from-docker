
# Build stage
FROM golang:1.16-alpine AS build

# Gerekli paketleri yükleyin
RUN apk add --no-cache git

WORKDIR /app

COPY main.go .

RUN go mod init hello-world && go mod tidy && go build -o hello-world

# Run stage
FROM alpine:latest

WORKDIR /root/

COPY --from=build /app/hello-world .

EXPOSE 8080

CMD ["./hello-world"]
