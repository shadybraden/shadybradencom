---
draft: false
tags:
  - homelab
title: The GitOps non-Kubernetes Homelab
ShowToc: true
TocOpen: false
weight: 998
---
# The Idea

Version control. Infrastructure as code. Auto updates. All one one host, with easy expansion and freedom of choice for everything.

This is my homelab.

Say there is an update for a service I run on my server - I click a button, and it it applied. A file path changed? `git push`. Want branch protection or a proper test environment? Setup another server that takes the exact same config, just on a different branch. When the PR is tested and merged, it'll auto apply to production.

All of this sounds like your normal Kubernetes setup, with tools like Kustomize + ArgoCD, but this doesn't.

It uses [Komodo](https://komo.do/) + [RenovateBot](https://www.mend.io/renovate/) + [Forgejo](https://forgejo.org/) + [Traefik](https://traefik.io/traefik/) + [Pi-hole](https://pi-hole.net/).

All locally. With proper SSL certs.

If you want one yourself, keep reading.

# The Tutorial

This will be broken down into sections. I will also be using a domain from Cloudflare. [Traefik Docs](https://doc.traefik.io/traefik/https/acme/#providers) will help if you have a different provider. 

You may be thinking about hardware or OS's at this point, but that doesn't really matter. This is heavily reliant on Docker, making the OS fairly irrelevant. I have used Debian for this, and for this write-up: Fedora Server. 

This guide assumes you know [how to install an operating system](https://search.brave.com/search?q=how+to+install+an+operating+system) and [how to setup ssh keys](https://search.brave.com/search?q=how+to+setup+ssh+keys) and [install docker](https://docs.docker.com/engine/install/)

If you want to follow along, just fill in your domain and IP addresses with mine: 

`holmlab.org` and `192.168.50.61` (hint: if you download [this file](https://github.com/shadybraden/shadybradencom/blob/main/content/articles/gitopsHomelab.md), you can find+replace)

We will be using my [compose](https://github.com/shadybraden/compose) Git repo a lot. I recommenced NOT forking it yet. We will setup Forgejo as your own internal git source (I have mine [mirrored](https://forgejo.org/docs/latest/user/repo-mirror/) to GitHub).

So, for now, just download the code: (on the server)

`git clone https://github.com/shadybraden/compose.git` Then `mv compose/ compose_2/ && cd compose_2/` Then, make it not a git repo: `rm -r .git/` 

Setup config folders:

`mkdir -p /data/config_storage && sudo chown -R user:user /data/config_storage/ && chmod 755 /data/config_storage/`

## Pi-hole

`cd pihole/ && cp .env.sample .env` then add a password to `.env` 

`nano compose.yaml` and un-comment line 19 with the web ui port.

`docker compose up -d` 

Now DNS should be up. We need to do a couple things now:

- Set this as our DNS server
	- Start here: https://search.brave.com/search?q=change+dns+server+on+router and add your brand of router. 
	- I have a pfsense, so I go to: https://192.168.50.1/system.php then set the first DNS server as `192.168.50.65`
	- Set another, as a fallback, to something like `1.1.1.1` or `9.9.9.9`
- Wait for devices to catch this router DNS change. This may take a while, so perhaps run `resolvectl | grep DNS` to see "Current DNS Server"
- Now you have to tell DNS that `192.168.50.65` = `*.holmlab.org`
	- Do this by going here: http://192.168.50.65:5353/admin/settings/system and turn on expert mode
	- Then go to http://192.168.50.65:5353/admin/settings/all and click `Miscellaneous` and then under `misc.dnsmasq_lines` add this: `address=/holmlab.org/192.168.50.65`. This is a wildcard DNS entry, so `anything.holmlab.org` works.

`nano compose.yaml` and re-comment line 19 with the web ui port.

`sudo docker compose restart`

## Traefik

`cd traefik/`

```shell
mkdir -p /data/config_storage/traefik
cp .traefik.yaml.sample /data/config_storage/traefik/traefik.yaml
touch /data/config_storage/traefik/acme.json
chmod 600 /data/config_storage/traefik/acme.json
sudo docker network create intranet
```
 then `cp .env.sample .env` then `nano .env` and add your own passwords in. 
 
for `config.yaml`, you may want to remove the contents after `permanent: true` or simply replace with your domain.

The last thing, is find the domain, `holmlab.org` and replace it with your domain (there are 4!)

`docker compose up -d`

Note that traefik logs to go: `/data/config_storage/traefik/logs` 

Try it: go to https://traefik.holmlab.org/ (Just kidding - nothing will happen yet. We need DNS first!)

But, we can verify that it worked: `tail -F /data/config_storage/traefik/logs/traefik.log` and look for no errors.

## Forgejo

Alright the hard parts are done. With just the above, you can have a great homelab.

But we want better.

So we will run our own Git server: Forgejo

`cd forgejo/` 

`docker compose up -d`

See? Easy.

Now go to https://git.holmlab.org/ and login, make accounts and make a new repo.

If you want to mirror your repo, you can via the settings tab. See the "Mirror settings" and docs to set that up.

We will use the repo `shady/compose`

To run `git clone` on this, we will need to use port 222: `git clone ssh://git@git.holmlab.org:222/shady/compose.git` 

Now `compose_2` is my repo, and yours is compose, so `cp -r compose_2/ compose/` to put my code into your repo. Now commit and push.

From here on, we will use this folder on our computer for deploying. It might be a good idea to bring down every current container (`docker compose down`) and then re-run `docker compose up` from this new folder. This won't mess up the work done so far, as file paths are absolute. 

## Komodo

`cd komodo/ && cp .env.sample .env` then add a password to `.env` (Only need `KOMODO_DB_PASSWORD` and `KOMODO_WEBHOOK_SECRET`)

This is the "Ops" of GitOps.

`docker compose up -d` Then go to https://komodo.holmlab.org/

We will use [Syncs](https://komodo.holmlab.org/resource-syncs) to setup this. There are 3 parts that cannot be automated:

1. Setting up Syncs
2. Configuring Webhooks
3. Starting containers

The first is quite simple. Make a new Sync named `main` and add your git source (git.holmlab.org) with the Forgejo account (you gotta make this in Forgejo). 
Repo=shady/compose
Branch=main
Resource Paths=komodo.toml (This is my config. Look through it and delete lotsa stuff you don't want. Start from the bottom)

My sync looks like this: (see button in the top right)

```toml
[[resource_sync]]
name = "main"
[resource_sync.config]
git_provider = "git.holmlab.org"
repo = "shady/compose"
git_account = "komodo"
resource_path = ["komodo.toml"]
include_user_groups = true
```

Once yours is like this, you just gotta add the webhook. Go to https://git.holmlab.org/shady/compose/settings/hooks and click "Add webhook" (then Forgejo) and paste in the link "Webhook Url" on Komodo. Do both:

https://komodo.holmlab.org/listener/github/sync/main/refresh
https://komodo.holmlab.org/listener/github/sync/main/sync

These links are the "Target URL" and the Secret is from `KOMODO_WEBHOOK_SECRET`

Now whenever you push to main, the sync will update your config automatically.

Each `[[stack]]` in the toml file defines a specific stack. This brings us to our third un-automatable thing - starting a container. You can add something to this `[[stack]]`, but it will just sit in https://komodo.holmlab.org/stacks until you start it.

Don't forget to setup your `[[server]]` section

For each stack, check the `.env.sample` and README for notes on how to run it. Don't forget to setup each webhook!

If you are confused, then keep reading! We will use Komodo to setup Renovate.

## Renovate Bot

This checks the docker image tags and looks for an update online.

I.e. `image: traefik:v3.4` but if Traefik puts out v3.5, I don't want to have to keep my ear to Traefik news just to know of an update. So Renovate.

Now we get to deploy fast! (and use Komodo)

Add this to your komodo.toml

```toml
[[stack]]
name = "renovate"
[stack.config]
server = "holmie"
project_name = "renovate"
git_provider = "git.holmlab.org"
git_account = "komodo"
repo = "shady/compose"
run_directory = "renovate"
ignore_services = ["renovate"]
```

Now you can see it here: https://komodo.holmlab.org/stacks

Now Click into it, go to webhooks, and follow the steps above to add the webhook to Forgejo.

This is an example of a weird config. `.env` is hard here. We use a private key in as `RENOVATE_GIT_PRIVATE_KEY` (oh yea make a Forgejo user renovate, and give it an ssh key) as a multi-line var. This works with normal docker, but not with Komodo. So we will manually add that secret.

First paste in the vars from `.env.sample` into the "Environment" section in Komodo:

```
RENOVATE_TOKEN=token
RENOVATE_GIT_AUTHOR_EMAIL="email@domain.tld"
RENOVATE_GITHUB_COM_TOKEN=github_pat
```

Then run it!! (gotta do this first before adding the ssh key)

Run `nano /data/config_storage/komodo/etc_komodo/stacks/renovate/renovate/.env` to edit the right `.env` file and add this:

```
RENOVATE_GIT_PRIVATE_KEY="-----BEGIN OPENSSH PRIVATE KEY-----
key content here
key content here
key content here
key content here
-----END OPENSSH PRIVATE KEY-----"
```

Now we gotta automate Renovate, so it runs on a schedule. Guess what......Komodo! (but this time a "Procedure")

```toml
[[procedure]]
name = "schedule_renovate"
config.webhook_enabled = false
config.schedule_format = "Cron"
config.schedule = "0 6 6 * * *"
config.schedule_timezone = "America/New_York"
config.schedule_alert = false

[[procedure.config.stage]]
name = "Stage 1"
enabled = true
executions = [
  { execution.type = "DeployStack", execution.params.stack = "renovate", execution.params.services = [], enabled = true }
]
```

Note the `config.schedule`. It is using Cron second notation. So the first 0 is important. Leave it. But Renovate recommends a much more frequent scanning schedule than I use. Use whatever you want.

---

And that is it!