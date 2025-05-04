FROM alpine:3.21.3

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
