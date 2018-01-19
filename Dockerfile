# build stage
FROM golang:alpine AS build-env
RUN apk update && apk add curl git
ENV GOPATH /go
ADD . /go/src/github.com/spinnaker/roer/
WORKDIR /go/src/github.com/spinnaker/roer/
RUN curl -s https://glide.sh/get | sh
RUN glide i
RUN GOOS=linux GOARCH=amd64 go build -o build/roer ./cmd/roer/main.go

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /go/src/github.com/spinnaker/roer/build/roer /app/
ENTRYPOINT ./roer
