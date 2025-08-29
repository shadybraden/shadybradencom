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

Kubernetes is overkill.

Sure it has its uses, but for a homelab? Na we can get the same benefits without its complexity. Who needs high availability anyways?

... Okay fair lots of people, but again, this is a [homelab](https://en.wikipedia.org/wiki/Home_server), so I don't need it...yet.

Version control. Infrastructure as code. Auto updates. Easy expansion and freedom of choice for everything. All without Kubernetes.

This is my homelab.

Say there is an update for a service I run on my server - I click a button, and it is applied. A file path changed? `git push`. Want branch protection or a proper test environment? Setup another server that takes the exact same config, just on a different branch. When the PR is tested and merged, it'll auto apply to production.

All of this sounds like your normal Kubernetes setup, with tools like Kustomize + ArgoCD, but this doesn't.

It uses [Komodo](https://komo.do/) + [RenovateBot](https://www.mend.io/renovate/) + [Forgejo](https://forgejo.org/) + [Traefik](https://traefik.io/traefik/) + [Pi-hole](https://pi-hole.net/).

All locally. With proper SSL certs.

If you want one yourself, keep reading.

# The Tutorial

This will be broken down into sections. I will also be using a domain from Cloudflare. [Traefik's Docs](https://doc.traefik.io/traefik/https/acme/#providers) will help if you have a different provider. 

You may be thinking about hardware or OS's at this point, but that doesn't really matter. This is heavily reliant on Docker, making the OS fairly irrelevant. I am currently using Debian, Fedora Server and Desktop Fedora.

This guide assumes you know [how to install an operating system](https://search.brave.com/search?q=how+to+install+an+operating+system) and [how to setup ssh keys](https://search.brave.com/search?q=how+to+setup+ssh+keys) and [install docker](https://docs.docker.com/engine/install/) and how to use Git.

We will be using my [compose](https://github.com/shadybraden/compose) Git repo a lot. I recommenced **NOT** forking it *yet*. We will setup Forgejo as your own internal git source (I have mine [mirrored](https://forgejo.org/docs/latest/user/repo-mirror/) to GitHub).

So, for now, just download the code: (on the server)

`git clone https://github.com/shadybraden/compose.git` Then `mv compose/ compose_2/ && cd compose_2/` Then, make it not a git repo: `rm -r .git/` 

We will use this to setup Komodo, then use Komodo for the rest.

***Note*** we will replace the folder we just made (compose) later. It is important for updating Komodo. 

## Komodo

`cd komodo/ && cp .env.sample .env` then add passwords to `.env`, and edit the domain. Feel free to read through the options here, but only the first 4 lines are required

`sudo docker network create intranet` (this is for all our containers to work with traefik...more later)

`docker compose up -d` Then go to http://192.168.50.65:9120/

Nice! Now we gotta setup the rest!

For the rest of our containers, we want to use Syncs (more on these later) but we want GitOps. So far we just have the "Ops". We need Git to make anything happen.

Now there’s a problem. We want to use git over https (not http) so [Yak Shaving](https://en.wiktionary.org/wiki/yak_shaving) time!!

## Pi-hole

This assumes you have a [Static ip](https://search.brave.com/search?q=add+static+ip+to+router) on our server.

`cd pihole/ && cp .env.sample .env` then add a password to `.env` 

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

`sudo docker compose restart`

## Traefik

`cd traefik/`

```shell
mkdir -p /data/config_storage/traefik
cp .traefik.yaml.sample /data/config_storage/traefik/traefik.yaml
touch /data/config_storage/traefik/acme.json
chmod 600 /data/config_storage/traefik/acme.json
```
 
Then `cp .env.sample .env` then `nano .env` and add your own passwords in. 
 
For `config.yaml`, you may want to remove the contents after `permanent: true` or simply replace with your domain.

The last thing, is find the domain, `holmlab.org` and replace it with your domain (there are 4!)

`docker compose up -d`

Note that traefik logs to go: `/data/config_storage/traefik/logs` 

Try it: go to https://traefik.holmlab.org/ 

But, we can verify that it worked: `tail -F /data/config_storage/traefik/logs/traefik.log` and look for no errors.

## Forgejo


`cd forgejo/` 

`docker compose up -d`

Now go to https://git.holmlab.org/ and login, make accounts and make a new repo named compose (you could change the name if you'd like)

If you want to mirror your repo, you can via the settings tab. See the "Mirror settings" and docs to set that up.

We will use the repo `shady/compose`

Now `compose_2` (from the begining) is my repo, and yours is compose.

For a layer of security, I don't allow my server (device with secrets) to push to git. So, copy the `compose_2` folder we made to your desktop/laptop. Our secrets should only be in `.env` files, so make sure that is in `.gitignore` too.

`git clone https://git.holmlab.org/shady/compose.git` 

From here on, we will use this folder on our computer for deploying only Komodo. So, when there is a Komodo update, you will have to go here, run `git pull && docker compose up -d` 

## Komodo (pt.2)

Now we have a great base for a homelab. From here, Komodo will help tons, and everything will go fast!

We will use [Syncs](https://komodo.holmlab.org/resource-syncs) to setup everything else. Well almost; there are 3 parts that cannot be automated:

1. Initalizing Syncs
2. Configuring Webhooks
3. Starting containers

The first is quite simple. Make a new Sync named `syncs` and add your git source (git.holmlab.org) with the Forgejo account (you gotta make this in Forgejo). 
Repo=`shady/compose` 
Branch=`main` 
Resource Paths=`syncs/syncs.toml` (This is my config. Look through it and delete lotsa stuff you don't want.)

My sync looks like this: (see `Toml` button in the top right)

```toml
[[resource_sync]]
name = "syncs"
[resource_sync.config]
git_provider = "git.holmlab.org"
repo = "shady/compose"
git_account = "komodo"
resource_path = ["syncs/syncs.toml"]
```

This can be edited, but mine is setup to be the setup for many other syncs.

If you Execute this Sync, it will populate other syncs. Look through them. I have several with specific server names, such as `tipi`, `holmie` etc. You will likely not need those so feel free to remove them. However, syncs.toml will re-add them if they still exist in code.

There are two Webhooks that are important:

The Procedures named `webhook_stacks_main` and `webhook_syncs`. Navigate to them, then find the webhook URLs. Mine are:

```
https://komodo.holmlab.org/listener/github/procedure/webhook_stacks_main/main
https://komodo.holmlab.org/listener/github/procedure/webhook_syncs/main
```

Go to https://git.holmlab.org/shady/compose/settings/hooks and click "Add webhook" (then Forgejo) and paste in the link "Webhook Url" on Komodo.

These links are the "Target URL" and the Secret is from `KOMODO_WEBHOOK_SECRET`

Now whenever you push to main, the sync will update your config automatically.

### For each stack, check the `.env.sample` and `README.md` for notes on how to run it.

From here we will spend the rest of our time in the [Stacks](https://komodo.holmlab.org/stacks) section of Komodo...A couple should already be running (forgejo, pi-hole and traefik)

We have to tell every container to use your domain now:

`nano /data/config_storage/komodo/etc_komodo/domain.env` and add your domain there.

It is quite important at this point to edit these three stacks. Komodo will save .env files in:

`/data/config_storage/komodo/etc_komodo/stacks/NAME/NAME/.env` 

While we had been saving them into `compose/NAME/.env`

So, we will have to re-add them. This is easy though!

Find the Forgejo Stack, scroll to Environment, and paste in the key value pair straight out of the `.env` file. Then hit Redeploy.

Do this for Pi-hole and Traefik too. These last two will cause brief disruption during their redeploy.

Now you are ready to deploy anything!!

## Renovate Bot

This checks the docker image tags and looks for an update online.

I.e. `image: traefik:v3.4` but if Traefik puts out v3.5, I don't want to have to keep my ear to Traefik news just to know of an update. So Renovate.

Now we get to deploy fast! (and use Komodo)

Add this to your komodo.toml

```toml
[[stack]]
name = "renovate"
tags = ["holmie", "criticality: 4", "ephemoral"]
[stack.config]
server = "holmie"
project_name = "renovate"
linked_repo = "compose_main"
run_directory = "renovate"
ignore_services = ["renovate"] # this is so it shows nicer in the dashboard
additional_env_files = ["/etc/komodo/domain.env"]
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

And that is it! Deploy to your hearts content