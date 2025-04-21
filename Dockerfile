# 构建阶段
FROM openjdk:17-slim AS build
ENV HOME=/usr/app
RUN mkdir -p "$HOME"
WORKDIR "$HOME"
# 将当前目录下的所有文件复制到工作目录
COPY . .
# 使用--mount=type=cache缓存maven的本地仓库，提高构建效率
RUN --mount=type=cache,target=/root/.m2 ./mvnw -f "$HOME/pom.xml" clean package

# 运行阶段
FROM openjdk:17-slim
ARG JAR_FILE=/usr/app/target/*.jar
# 从构建阶段复制生成的jar文件
COPY --from=build "$JAR_FILE" /app/runner.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app/runner.jar"]
