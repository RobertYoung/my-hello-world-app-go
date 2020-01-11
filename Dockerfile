# Use version 1.13 golang base image
FROM golang:1.13

# Use /app as the working directory
WORKDIR /app

# Copy files to the working directory
ADD . /app

# Build the application
RUN go build -o main .

# Expose the port that the application is running on
EXPOSE 8080

# Start the application
CMD ["./main"]