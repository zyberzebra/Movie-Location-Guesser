# Stage 1: Build with JDK and Gradle
FROM eclipse-temurin:17-jdk-jammy as builder

WORKDIR /workspace

# Copy Gradle wrapper files first
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

# Make Gradle wrapper executable
RUN chmod +x gradlew

# Download dependencies first (this layer will be cached)
RUN ./gradlew dependencies --no-daemon

# Copy the rest of the source code
COPY src src

# Build the application
RUN ./gradlew bootJar --no-daemon

# Stage 2: Runtime with JRE
FROM eclipse-temurin:17-jre-jammy

# Create non-root user (Debian/Ubuntu syntax)
RUN groupadd --system spring && \
    useradd --system --gid spring --shell /bin/false spring

# Create necessary directories with proper permissions
RUN mkdir -p /app/data && \
    chown -R spring:spring /app

WORKDIR /app

# Copy built JAR and resources from builder stage
COPY --from=builder --chown=spring:spring /workspace/build/libs/*.jar app.jar
COPY --from=builder --chown=spring:spring /workspace/src/main/resources/data.sql /app/data/

# Create a volume for persistent data
VOLUME /app/data

# Switch to non-root user
USER spring

# Environment variables
ENV PORT=8081
ENV JAVA_OPTS="-Xmx512m -Xms256m -Dserver.port=${PORT} -Dspring.datasource.url=jdbc:sqlite:/app/data/moviedb.sqlite"

EXPOSE ${PORT}

# Use exec form for better signal handling
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]