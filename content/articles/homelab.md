---
date: "2024-03-01T20:02:41-05:00"
draft: false
tags:
  - homelab
title: Homelab
ShowToc: true
TocOpen: true
weight: 999
---

My homelab is constantly evolving. The latest will be on my [homelab git repo](https://github.com/shadybraden/homelab)

Currently I am using a [docker-based homelab](https://github.com/shadybraden/homelab/tree/main/docker#docker-compose-based-homelab). The plan is to switch to a GitOps based homelab. (see [here](/articles/gitopshomelab/))

This site will serve as a place for specific projects and things that need a few more words than the ones in a config file.

Here is a picture of my whole homelab:

![homelab](/homelab.jpg)

---

# Network UPS Tools (NUT)

Battery backup for all the network and homelab things. (Bonus for my desktop too!)

I will be consolidating [Jeff Geerling's blog post on this](https://www.jeffgeerling.com/blog/2025/nut-on-my-pi-so-my-servers-dont-die) into my configs, and my exact steps.

## Layout and my devices:

- Shutdown order:
	- [x] Desktops
	- [x] Holmie server
	- [ ] iMessage mac
	- [ ] pfsense
	- [x] Raspberry Pi3
	- On dead battery: (no config)
		- Asus WAP
		- Network Switch
- My UPS model: `CP1500AVRLCD3-R` (purchased 02/28/2025)
	- `-R` likely means refurbish 
	- `3` is a later version made. [it is this one](https://www.cyberpowersystems.com/product/ups/intelligent-lcd/cp1500avrlcd3/) 
	- Using 2x of this battery: `RB1290X2E` 

## Step-by-step

#### NUT server setup `pi3` 
- Install: `sudo apt install -y nut` and plug UPS into `pi3` then `sudo nut-scanner`

```shell
Scanning USB bus.
No start IP, skipping SNMP
Scanning XML/HTTP bus.
No start IP, skipping NUT bus (old connect method)
Scanning NUT bus (avahi method).
[nutdev1]
        driver = "usbhid-ups"
        port = "auto"
        vendorid = "0764"
        productid = "0601"
        product = "CP1500AVRLCD3"
        serial = "BHPPT7G00027"
        vendor = "CPS"
        bus = "001"
```

- Append the above into `sudo nano /etc/nut/ups.conf` 

```shell
[pi3]
        driver = "usbhid-ups"
        port = "auto"
        vendorid = "0764"
        productid = "0601"
        product = "CP1500AVRLCD3"
        serial = "BHPPT7G00027"
        vendor = "CPS"
        bus = "001"
```

- `sudo nano /etc/nut/upsd.conf` and append `LISTEN 0.0.0.0 3493` 
- `sudo nano /etc/nut/upsd.users` and make an admin and observer users: (I saved this in my password manager as "NUT UPS server")

```shell
[admin]
    password = password
    actions = set
    actions = fsd
    instcmds = all

[observer]
    password = password
    upsmon secondary
```

- `sudo nano /etc/nut/upsmon.conf` comment out the existing `FINALDELAY` line, and add:

```shell
# Make sure you use your actual admin password...
MONITOR pi3@localhost 1 admin password primary

# You might also want to configure FINALDELAY and set it to a period long enough
# for your servers to all shut down, prior to the primary node shutting down and
# triggering the UPS to switch off its load, e.g. for 3 minutes:
FINALDELAY 180
```

- `sudo nano /etc/nut/nut.conf` edit mode from `none` to `netserver` 
- Restart NUT: `sudo systemctl restart nut-server && sudo systemctl enable nut-server && sudo systemctl restart nut-monitor && sudo systemctl enable nut-monitor` 
- Done! Testing time:
	- `upsc pi3` should output a bunch of info
	- If you have home assistant you should be able to add it via the NUT integration.

#### Any client setup

- I will be using `holmie` as the server I am setting this up on. The process should be identical for additional clients.
- `sudo apt install nut-client -y` then `upsc pi3@192.168.50.61` to verify connection
- `sudo nano /etc/nut/upsmon.conf` add `MONITOR pi3@192.168.50.61 1 observer password slave`
- `sudo nano /etc/nut/nut.conf` and edit `MODE` from `none` to `netclient` > `MODE=netclient` 
- Now this server will monitor wait for a `fsd` command from the NUT-server.
- This setup will shutdown everything right before the battery dies. If this is not desired, **keep reading.**

---

- Only installing `nut-client` is required for this to work.
- Make a script that will monitor and shutdown based on the selected factors:

```bash */5 * * * * /etc/nut/ups_shutdown.sh
#!/bin/bash

# check ups status and battery %
BATTERY_LEVEL=$(upsc pi3@192.168.50.61 battery.charge)
UPS_STATUS=$(upsc pi3@192.168.50.61 ups.status)
SHUTDOWN_PERCENT=50
DEVICE_TAG=house

if [ "$UPS_STATUS" != OL ]; then # if not online
	# Check if UPS is on battery and if battery charge is less than 90 and isnt charging
	if [ "$UPS_STATUS" != "OL CHRG" ]; then # if not charging
		if [ "$BATTERY_LEVEL" -lt "$SHUTDOWN_PERCENT" ]; then
			# if less than the number, ntfy then shutdown in 1 minute
			curl -H "Tags: $DEVICE_TAG,bangbang" -H "Priority: high" -H "X-Title:HOLMIE SHUTTING DOWN" -d "" https://ntfy.holmlab.org/UPSuWd9jG23WS ; /sbin/shutdown -h +1
		fi
	fi
	if [ "$UPS_STATUS" = "OL CHRG" ]; then
		curl -H "Tags: battery,arrow_up" -H "Priority: min" -H "X-Title: UPS charging (at "$BATTERY_LEVEL"%)" -d "" https://ntfy.holmlab.org/UPSuWd9jG23WS
	fi
fi

if [ "$UPS_STATUS" = RB ]; then # replace battery?
	# NTFY if replacement battery
	curl -H "Tags: battery" -H "Priority: min" -H "X-Title: Replace UPS battery" -d "" https://ntfy.holmlab.org/UPSuWd9jG23WS
fi
```

- Then `sudo chmod 700 /etc/nut/ups_shutdown.sh` then `sudo su` > `crontab -e` then append: `*/5 * * * * /etc/nut/ups_shutdown.sh`
- You do not need to use this many notifications. If there is an outage, I will be receiving many notification with this setup.
- Below is a trimmed down version with fewer notifications:


```bash */5 * * * * ups_shutdown.sh
#!/bin/bash

# check ups status and battery %
BATTERY_LEVEL=$(upsc pi3@192.168.50.61 battery.charge)
UPS_STATUS=$(upsc pi3@192.168.50.61 ups.status)
SHUTDOWN_PERCENT=90
DEVICE_TAG=desktop_computer

if [ "$UPS_STATUS" != OL ]; then # if not online
	# Check if UPS is on battery and if battery charge is less than 90 and isnt charging
	if [ "$UPS_STATUS" != "OL CHRG" ]; then # if not charging
		if [ "$BATTERY_LEVEL" -lt "$SHUTDOWN_PERCENT" ]; then
			# if less than the number, ntfy then shutdown in 1 minute
			curl -H "Tags: $DEVICE_TAG,bangbang" -H "Priority: high" -H "X-Title: SHADYPC SHUTTING DOWN" -d "" https://ntfy.holmlab.org/UPSuWd9jG23WS ; /sbin/shutdown -h +1
		fi
	fi
fi
```

---