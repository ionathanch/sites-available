# Templates

These NGINX configurations set up HTTP servers at port 80. HTTPS on port 443 should be set up using [certbot](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/).

## Static web page
The URL [example.ert.space](http://example.ert.space) will point to files in `/srv/www/example.ert.space`.
```nginx
server {
    listen 80;
    listen [::]:80;
    root /srv/www/example.ert.space;
    server_name example.ert.space;
    error_page 404 /404.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

## PHP site with HTTP authentication
The URL [example.ert.space](http://example.ert.space) will point to the PHP application at `/srv/www/example.ert.space/index.php`. HTTP authentication done as indicated [here](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/).
```nginx
server {
    listen 80;
    listen [::]:80;
    server_name example.ert.space;

    root /srv/www/example.ert.space;
    index index.html index.php;

    # set up HTTP basic authentication
    auth_basic           "Authentication Required";
    auth_basic_user_file /etc/apache2/.htpasswd;

    location / {
        try_files $uri $uri/ =404;
    }

    # process PHP requests
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

## Reverse proxy
The URL [example.ert.space](http://example.ert.space) will point to the local [port 8080](http://localhost:8080).
```nginx
server {
    listen 80;
    listen [::]:80;
    client_max_body_size 512M;
    server_name example.ert.space;
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```
