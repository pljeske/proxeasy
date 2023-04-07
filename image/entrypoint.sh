#!/usr/bin/env sh

if [ ! -f "/app/config/config.yaml" ]; then
  echo "Please provide yaml config file in /app/config/config.yaml"
  exit 1;
fi

if [ "$HTTP_ONLY" == "false" ]; then
  if [ ! -f "/app/config/dhparam.pem" ]; then
    echo "Generating dhparams bc they don't exist in the /app/config directory..."
    openssl dhparam -out /app/config/dhparam.pem 4096
  fi
  cp /app/config/dhparam.pem /etc/nginx/dhparam.pem
fi

echo "Templating proxy nginx config..."
#find /app/config -type f -name "*.json"  -exec sh -c 'filename="$1"; j2 /app/tmpl/proxy.j2 "/app/config/$filename" > /etc/nginx/sites-enabled/"${filename%.json}.conf"' shell {} \;
#cat /app/config/config.yaml | j2 --format=yaml /app/proxy.j2 > /etc/nginx/proxies.conf
if [ "$HTTP_ONLY" == "false" ]; then
  j2 /app/proxy.j2 /app/config/config.yaml > /etc/nginx/proxies.conf
else
  j2 /app/http-only-proxy.j2 /app/config/config.yaml > /etc/nginx/proxies.conf
fi

echo "Starting nginx...";
nginx -g "daemon off;"

if $DEBUG ; then
  echo "nginx failed to start but keeping the container running for debugging purposes"
  tail -f /dev/null
fi
