# Stage 1: Build
FROM golang:1.21 AS builder

WORKDIR /app
COPY main.go .
RUN go mod init example.com/multistage && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server .

# Stage 2: Run
FROM gcr.io/distroless/static:nonroot

WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 8080
USER nonroot
CMD ["./server"]