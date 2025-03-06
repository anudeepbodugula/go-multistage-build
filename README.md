# Multistage Docker Build with Distroless in Go

This project demonstrates the benefits of using a **multistage Docker build** to create a small and efficient Docker image for a simple Go web server, utilizing a **distroless base image** for enhanced security and minimal footprint.

## Features
- **Ultra-lightweight final image**: Uses `gcr.io/distroless/static:nonroot` instead of a full Linux distribution.
- **Faster builds**: Compiles the binary in a separate build stage.
- **Improved security**: No shell, package manager, or extra dependencies.

## Prerequisites
- [Go](https://go.dev/doc/install) (if running locally)
- [Docker](https://docs.docker.com/get-docker/)

## Project Structure
```
multistage-docker-go/
│── main.go
│── Dockerfile
│── README.md
```

## Running Locally
```sh
# Install dependencies and run the server
go mod init example.com/multistage
go mod tidy
go run main.go
```

## Building and Running with Docker
```sh
# Build the Docker image
docker build -t multistage-go-distroless .

# Run the container
docker run -p 8080:8080 multistage-go-distroless
```

## Dockerfile Explanation
This project uses a **multistage build** to reduce the final image size while ensuring security.

### **Stage 1: Build**
```dockerfile
FROM golang:1.21 AS builder
WORKDIR /app
COPY main.go .

# Initialize the module (use your actual repo if applicable)
RUN go mod init example.com/multistage && go mod tidy

# Build the Go binary with static linking
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server .
```
- Uses the official Go image to compile the binary.
- Builds a static binary optimized for Linux.

### **Stage 2: Minimal Runtime (Distroless)**
```dockerfile
FROM gcr.io/distroless/static:nonroot

WORKDIR /
COPY --from=builder /app/server .

# Expose port 8080 for the web server
EXPOSE 8080

# Run as a non-root user for better security
USER nonroot

# Start the application
CMD ["./server"]
```
- Uses `gcr.io/distroless/static:nonroot` for the smallest and safest runtime.
- Copies only the compiled binary, reducing the final image size.
- Runs as a **non-root** user, enhancing security.

## Benefits of Multistage Builds with Distroless
 **Minimal Image Size** - No unnecessary files or libraries.  
 **Better Security** - No shell or package manager.  
 **Non-Root Execution** - Reduces security risks.  
 **Faster Deployments** - Smaller images mean faster downloads and startup.

## Testing the Application
Once the container is running, test it using **curl** or a browser:
```sh
curl http://localhost:8080
```
Expected Output:
```
Hello, Multistage Docker Build!
```

