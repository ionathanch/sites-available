upstream freshrss {
  server localhost:8080;
  keepalive 64;
}

server {
	server_name rss.ionathan.ch;

	location / {
		# The final `/` is important.
		proxy_pass http://freshrss/;
		add_header X-Frame-Options SAMEORIGIN;
		add_header X-XSS-Protection "1; mode=block";
		proxy_redirect off;
		proxy_buffering off;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_set_header X-Forwarded-Port $server_port;
		proxy_read_timeout 90;

		# Forward the Authorization header for the Google Reader API.
		proxy_set_header Authorization $http_authorization;
		proxy_pass_header Authorization;
	}

  listen 443 ssl; # managed by Certbot
  listen [::]:443 ssl;
  ssl_certificate /etc/letsencrypt/live/next.ionathan.ch/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/next.ionathan.ch/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
  if ($host = rss.ionathan.ch) {
    return 301 https://$host$request_uri;
  } # managed by Certbot

  server_name rss.ionathan.ch;
  listen 80;
  listen [::]:80;
  return 404; # managed by Certbot
}
