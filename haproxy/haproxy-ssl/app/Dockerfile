FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY main.go .

RUN go build -o server main.go

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 3000
CMD ["./server"]

