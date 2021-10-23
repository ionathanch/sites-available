server {
    server_name sea.ionathan.ch;
    listen 80;
    listen [::]:80;
    client_max_body_size 512M;
    add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;

    location / {
        proxy_pass http://localhost:8008;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

