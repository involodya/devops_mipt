FROM maven:3.9.9-eclipse-temurin-17-alpine AS build-env
WORKDIR /src
COPY pom.xml .
RUN mvn -q dependency:go-offline

COPY src ./src
RUN mvn -q clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
ARG APP_USER=springusr
RUN addgroup -S $APP_USER && adduser -S $APP_USER -G $APP_USER
WORKDIR /app
COPY --from=build-env /src/target/*.jar app.jar
USER $APP_USER
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
