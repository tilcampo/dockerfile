FROM alpine:3.21.3

RUN apk update && \
    apk upgrade --no-cache && \
    rm -rf /var/cache/apk/*

RUN apk update && \
    apk add --no-cache curl=8.12.1-r1 && \
    apk add --no-cache openjdk17-jre-headless=17.0.15_p6-r0 && \
    apk add --no-cache musl=1.2.5-r9

RUN ln -snf /usr/share/zoneinfo/America/Mexico_City /etc/localtime && \
    echo "America/Mexico_City" > /etc/timezone

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=America/Mexico_City \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk \
    PATH=$JAVA_HOME/bin:$PATH
    
WORKDIR /app

COPY target/prueba-1.0.0.jar /app/prueba-1.0.0.jar

RUN adduser -D -s /bin/bash jmlm && \
    chown -R jmlm:jmlm /app && \
    chmod 755 /app/prueba-1.0.0.jar
USER jmlm

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl --fail http://localhost:8081 || exit 1
CMD ["java", "-Duser.timezone=America/Mexico_City", "-jar", "/app/prueba-1.0.0.jar"]
