server {
    server_name rss.ionathan.ch;
    location / {
        proxy_pass http://localhost:8181;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/rss.ionathan.ch/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/rss.ionathan.ch/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = rss.ionathan.ch) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;
    server_name rss.ionathan.ch;
    return 404; # managed by Certbot


}