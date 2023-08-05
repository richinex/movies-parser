# Use the official Golang image from the Docker Hub as a base image.
# This image includes Go version 1.16.5 and all its dependencies.
FROM golang:1.16.5 AS builder

# Set the current working directory inside the Docker image for the Go compiler.
# This is the directory which we'll be running our commands in.
WORKDIR /go/src/github.com/richinex/movies-parser

# Copy the main.go and go.mod files from your local host (your machine or build server) to the Docker image.
# It's considered a good practice to copy just the files you need to build your application.
COPY main.go go.mod ./

# Get the dependencies of the Go application.
# The -v flag enables verbose output.
RUN go get -v

# Build the Go app in the Docker image.
# CGO_ENABLED=0 disables CGO in Go which provides the ability to call C code from Go, we don't need this in our Go app.
# GOOS=linux sets the target operating system to Linux.
# -a forces the rebuilding of packages that are already up-to-date.
# -installsuffix cgo adds a suffix to the package installation directory, again related to disabling CGO.
# -o app names the built binary 'app'.
# main.go is the file to build.
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app main.go

# Use a lightweight version of the official Alpine Linux image as a base image for the final stage.
# Alpine Linux is much smaller than most distribution base images (~5MB), which leads to much slimmer images in general.
FROM alpine:latest

# LABEL allows to add metadata to an image. It's used here to add the maintainer of the image.
LABEL Maintainer richinex

# Install ca-certificates so the application can connect to websites over SSL.
# --no-cache option tells apk to not cache the index locally, which reduces the image size.
RUN apk --no-cache add ca-certificates

# Set the current working directory inside the Docker image for our application.
WORKDIR /root/

# Copy the binary file 'app' from the builder stage to the current stage.
# This reduces the final image size as it's not carrying the whole Go SDK, just the built binary.
COPY --from=builder /go/src/github.com/richinex/movies-parser/app .

# Set the command for the Docker image to execute when it starts up.
CMD ["./app"]
