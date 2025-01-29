# Stage 1: Build with JDK and Gradle
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /workspace

# Copy all files
COPY . .

# Fix Mac/Linux line endings and permissions
RUN sed -i 's/\r$//' gradlew && \
    chmod +x gradlew && \
    ./gradlew --version || true

# Debug: Show critical files
RUN ls -l gradlew && \
    ls -l gradle/wrapper/gradle-wrapper.jar && \
    java -version

# Build with stacktrace
RUN ./gradlew bootJar --no-daemon --stacktrace

# Stage 2: Runtime with JRE
FROM eclipse-temurin:17-jre-jammy

RUN groupadd --system spring && \
    useradd --system --gid spring --shell /bin/false spring

RUN mkdir -p /app/data && \
    chown -R spring:spring /app

WORKDIR /app

COPY --from=builder --chown=spring:spring /workspace/build/libs/*.jar app.jar
COPY --from=builder --chown=spring:spring /workspace/src/main/resources/data.sql /app/data/

VOLUME /app/data
USER spring

ENV PORT=8081
ENV JAVA_OPTS="-Xmx512m -Xms256m -Dserver.port=${PORT} -Dspring.datasource.url=jdbc:sqlite:/app/data/moviedb.sqlite"

EXPOSE ${PORT}
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
