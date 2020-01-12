# Use version 1.13 golang base image
FROM golang:1.13

# Use /app as the working directory
WORKDIR /app/hello-world

# Copy files to the working directory
ADD . .

# Build the application
RUN make compile

# Expose the port that the application is running on
EXPOSE 8080

# Start the application
CMD ["./bin/hello-world"]