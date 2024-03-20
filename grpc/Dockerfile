# Dockerfile
FROM golang:latest

WORKDIR /usr/src/app

COPY ./src .
EXPOSE 8080

RUN go mod init example.com/myapp
RUN go mod download
RUN go mod verify
RUN go build -v -o /usr/local/bin/app ./...
CMD ["app"]
