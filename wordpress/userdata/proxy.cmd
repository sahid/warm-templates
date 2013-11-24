#!/bin/bash

IP_WEB=10.123.1.1

cat << EOF >> /etc/nginx/sites-available/wordpress
server {
  listen         80;
  server_name    wordpress;
  access_log     /var/log/nginx/access.log;

  location / {
    proxy_pass    http://$IP_WEB:8080/;
    include       /etc/nginx/proxy_params;
  }
}
EOF

rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

/etc/init.d/nginx restart
