# المرحلة الأولى: نبني المشروع باستخدام Maven
FROM maven:3.9-eclipse-temurin-17 AS build

# نحدد مجلد العمل داخل الحاوية
WORKDIR /app

# ننسخ ملف pom.xml
COPY pom.xml .

# ننسخ مجلد src كامل
COPY src ./src

# نبني المشروع (نطلع ملف الـ JAR)
RUN mvn -q -DskipTests package

# المرحلة الثانية: نشغّل المشروع فقط (بدون أدوات البناء)
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# ننسخ ملف الـ JAR من المرحلة الأولى
COPY --from=build /app/target/*.jar app.jar

# نفتح المنفذ 8080
EXPOSE 8080

# نشغّل التطبيق
ENTRYPOINT ["java", "-jar", "app.jar"]
