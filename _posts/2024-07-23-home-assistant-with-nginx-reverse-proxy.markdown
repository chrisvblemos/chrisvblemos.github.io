---
layout: post
title: Configure Home Assistant with Nginx reverse proxy
date: 2024-07-23
categories: homelab, tech, nginx, homeassistant, automation
---

To set up Home Assistant with a Nginx reverse proxy, you must edit the `configuration.yaml` file of Home Assistant and add the following settings:

 ```
htpp:
	use_x_forwarded_for: true
	trusted_proxies:
		- 192.168.x.x # change this to the ip of your nginx proxy server
 ```

After this, you should be able to access home assistant via your domain. If you still get an error saying "Unable to connect to Home Assistant." when attempting to login, make sure your domain supports websocket and that websocket support is enabled for that host on nginx.

Sources:
- https://community.home-assistant.io/t/unable-to-connect-to-home-assistant-via-nginx-reverse-proxy/382937/8
- https://www.home-assistant.io/integrations/http/
