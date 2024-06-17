---
layout: post
title: WWW with HTTPS using nginx and certbot
date: 2023-04-23
categories: web-development
usehighlightjs: true
---

While following the [LandChad nginx guide](https://landchad.net/basic/nginx/) I've come up with a very small problem that made me uncomfortable.
After finishing the tutorial I had a working website that I could access by typing "my-website.wtv[^1]", but if I tried to access it by typing "www.my-website.wtv" I'd get a 404 nginx page.

But Mom, I want to have a World Wide Web in my Website URL!
Fine! It took me some time but I got it fixed on my end.

## My Problem

The problem had to do with SSL certificates and HTTPS redirects. If you follow the guide you'll get to the part where you learn how to make your website have a SSL certificate[^2]. To do this Chad suggests that you use [Certbot](https://certbot.eff.org/) nginx command. With this command, I think Certbot looks at your website nginx configuration file and generate certificates for the websites defined in the **server_name** variable while also modifying the config file so that when a user types "my-website.wtv" into his browser he gets redirected to "https://my-website.wtv".

If you look at the redirect code that was added to the configuration file you'll realize that it is an if-statement that checks if the URL entered by the user is equal to "my-website.ttv". Thus when the user types in "www.my-website.wtv" the if-expression will be false and the server will return a 404.

## One Solution

To fix this we need to update the if-statement so that it includes the "www" case and also make a certificate for it. So the first thing to do is to also generate a certificate for the "www.my-website.wtv" by running the following command:

    certbot certonly --nginx -d my-website.wtv -d www.my-website.wtv

Note that I added **certonly** to the command. This is so that Certbot does not change our nginx configuration file. Now we edit our if-statement so that the line

    if ($host = my-website.wtv)

becomes

    if ($host ~ "(my-website.wtv)|(www.my-website.wtv)")

In the end, your configuration file should look something like this
```perl
server {
        server_name my-website.wtv ;
        root /var/www/mywebsite ;
        index index.html index.htm ;
        location / {
                try_files $uri $uri/ =404 ;
        }

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/my-website.wtv/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/my-website.wtv/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    if ($host ~ "(my-website.wtv)|(www.my-website.wtv)")  {
        return 301 https://$host$request_uri;
    } # managed by Certbot


        listen 80 ;
        listen [::]:80 ;
        server_name my-website.wtv ;
    return 404; # managed by Certbot


}
```
[^1]: wtv stands for Whatever, an imaginary country that shares a border with [Tuvalu](https://en.wikipedia.org/wiki/Tuvalu).
[^2]: also known as the cute padlock next to the URL in the browser