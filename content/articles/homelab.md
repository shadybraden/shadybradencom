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

---

# Network UPS Tools (NUT)

Battery backup for all the network and homelab things. (Bonus for my desktop too!)

I will be consolidating [Jeff Geerling's blog post on this](https://www.jeffgeerling.com/blog/2025/nut-on-my-pi-so-my-servers-dont-die) into my configs, and my exact steps.

## Layout and my devices:

- Shutdown order: (defined by ansible groups)
	- [nut_observer_fast_off]
	- [nut_observer]
	- [nut_critical]
- My UPS model: `CP1500AVRLCD3-R` (purchased 02/28/2025)
	- `-R` likely means refurbish 
	- `3` is a later version made. [it is this one](https://www.cyberpowersystems.com/product/ups/intelligent-lcd/cp1500avrlcd3/) 
	- Using 2x of this battery: `RB1290X2E` 

## Step-by-step

### NUT server setup

1. Install nut, and run `nut-scanner` to fetch the UPS info. Example:

```shell
[nutdev1]
        driver = "usbhid-ups"
        port = "auto"
        vendorid = "0764"
        productid = "0601"
        product = "CP1500AVRLCD3"
        serial = "BHPPT7G00027"
        vendor = "CPS"
        bus = "003"
```

2. Fill in the details found there into the `nut_setup` role's template files

3. Use the role `nut_setup` and point it at a server also in the [nut_critical] group. [My Inventory](https://github.com/shadybraden/IaC/blob/main/inventory) has holmie in the [controller] group, and [nut_critical] group, so it is the ideal choice.

Done! Now that server should stay on till the very end, and only shutdown when the UPS sends a critical message.

### NUT clients

Similar to the server, see the roles:

- `nut_critical`
- `nut_observer`
- `nut_observer_fast_off`

These do what you would expect:
- `nut_critical` wait for the critical message (`actions = fsd`) from the nut server
- `nut_observer` shuts down with 75% battery left.
- `nut_observer_fast_off` shuts down at 90% battery left.
