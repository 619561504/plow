FROM golang:1.20-rc-bullseye as builder
WORKDIR /build
RUN apt-get install -y libnetfilter-queue-dev
COPY go.mod .
COPY go.sum .
COPY vendor .
COPY . .

RUN GOOS=linux GOARCH=amd64 go build -ldflags '-w -s'

FROM gcr.io/distroless/base-debian11

COPY --from=builder /build/app /app

ENTRYPOINT ["/app"]