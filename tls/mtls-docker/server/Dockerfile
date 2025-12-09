FROM golang:1.22-alpine

WORKDIR /app
COPY server.go .

RUN go build -o server server.go

CMD ["./server"]

