FROM python:3.12.4-alpine3.20

RUN apk update && \
    apk add --no-cache \
    tzdata \
    bash \
    busybox-suid  # Inclui crond
ENV TZ=America/Sao_Paulo
RUN echo >> /var/log/cron_output.log
COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh
COPY script.py /app/
WORKDIR /app
RUN echo "* * * * * /usr/local/bin/script.sh | tee -a /var/log/cron_output.log 2>&1" >> /etc/crontabs/root
ENTRYPOINT ["crond", "-f", "-d", "8"]