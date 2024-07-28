---
layout: post
title: Set Docker Compose to wait for drive mount
date: 2024-07-28
categories: homelab
---

If your containers are failing to start at boot (using docker compose `restart=unless-stopped` for example) due to any volume mapping pointing to a mount failing, the cause might be that those mounts are not ready the moment docker services attempt to start those containers.

To fix this problem, we must set the docker service to depend on the mount, so that it will only start the containers after the mount is ready. To do this, we rely on the fact that, if you system uses `systemd`, then for each filesystem listed in /`/etc/fstab`, `systemd` will generate a unit named <filesystem>.mount or <filesystem>.automount depending on your mount options.

To get the name of this unit, just run the following command:

```
systemctl list-units | grep mount
```

Your unit name will follow the template `<mount-path>.mount`. Copy this name.

Now, you need to edit the docker service to depend on the unit above. Simply run the command below:

```
systemctl edit docker
```

and make the following addition:

```
[Unit]
Requires= <mount-unit-name>.mount
```

Example:
```
[Unit]
Requires=foo-bar.mount
```

Save the file and reboot for a test.

Sources: 
- https://www.reddit.com/r/selfhosted/comments/pmt7af/how_to_ensure_docker_and_home_assistant_wait_for/
- https://stackoverflow.com/questions/66910389/docker-compose-wait-to-launch-until-a-host-filesystem-is-mounted