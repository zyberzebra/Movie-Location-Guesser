FROM eclipse-temurin:17-jdk-alpine

# Create a non-root user
RUN addgroup -S spring && adduser -S spring -G spring

# Create directories with proper permissions
RUN mkdir -p /app/data && \
    chown -R spring:spring /app

# Set working directory
WORKDIR /app

# Copy the jar file
COPY build/libs/*.jar app.jar

# Set ownership of the jar file
RUN chown spring:spring app.jar

# Switch to non-root user
USER spring

# Set environment variables
ENV PORT=8081
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Expose the application port
EXPOSE 8081

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"] 