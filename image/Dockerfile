FROM nginx:1.23.2-alpine

ENV DEBUG=false

RUN apk add --no-cache py3-pip openssl && pip install j2cli[yaml] 
    # && mkdir -p /etc/nginx/proxies # && \
    #openssl dhparam -out /etc/nginx/dhparam.pem 4096

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/proxy.j2 /app/proxy.j2
COPY entrypoint.sh /app/entrypoint.sh

VOLUME ["/app/config"]
# volume where you mount the json config files
#VOLUME ["/app/config.yaml"]
# volume where you can mount tls certs
#VOLUME ["/etc/nginx/certs"]
WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]
