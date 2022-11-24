server {
    server_name next.ionathan.ch;
    client_max_body_size 512M;
    add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    location = /.well-known/carddav {
        return 301 $scheme://$host/remote.php/dav;
    }
    location = /.well-known/caldav {
        return 301 $scheme://$host/remote.php/dav;
    }

    listen 443 ssl; # managed by Certbot
    listen [::]:443 ssl;
    ssl_certificate /etc/letsencrypt/live/next.ionathan.ch/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/next.ionathan.ch/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    if ($host = next.ionathan.ch) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    server_name next.ionathan.ch;
    listen 80;
    listen [::]:80;
    return 404; # managed by Certbot
}
