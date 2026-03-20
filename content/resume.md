---
title: Braden Holm
ShowToc: true
---

📧 bradenholm@shady.icu | 🗺️ Greater Boston | 🌐 shadybraden.com | [GitHub](https://github.com/shadybraden) | [LinkedIn](https://www.linkedin.com/in/bradenholm)

[PDF Resume](/Holm_Braden_Resume.pdf)

---

## Relevant Experience

### SAIC
 
#### Cloud One AWS O&S Engineer

- Architect, plan and execute a major migration of Artifactory and Xray, reducing attack surface of a critical platform component.
- Acted as deputy for CI/CD platform domain of larger AWS O&S team.
- Owned and operated over 600 instances of Jenkins across customer and enterprise environments, orchestrated by EC2 auto scaling groups (ASGs) using a mixture of CloudFormation, Ansible and jinja2 templates.
- Leverage Terraform/Terragrunt for infrastructure deployment, Packer to provide a secure golden image and remote-host Ansible for configuration, with a focus on maximizing code reuse across multiple cloud service providers (CSPs) and impact levels (ILs).
- Ensure that all golden images meet organizational thresholds of 90%+ STIG compliance with no CAT I STIG findings.
- Executed regular software patching of Jenkins instances in response to upstream project release cadence as well as security advisories.
- Managed and maintained team-level devcontainer, ensuring that CI builds across a 30-engineer platform team leveraged modern tooling

## Projects

### Holmlab 

[Project GitHub](https://github.com/shadybraden/compose) 

- Deploy 100+ containerized microservices split across 6 physical nodes using Docker compose and Komodo.
- Provide automated patching for all services via Renovate annotations.
- Manage code locally using self-hosted instance of Forgejo that automatically mirrors to GitHub.
- Supports a package registry and builds and manages containerized applications to enhance application functionality and efficiency, while streamlining software delivery.
- Patch all services via GitOps: once a PR is merged, multi site deployments are autonomously orchestrated by Komodo.
- Ensure uptime via Uptime-Kuma and alerting via NTFY, achieving an average of 99% uptime across all nodes, with the least reliable node still maintaining 98.77% uptime.
- Enable disaster recovery via custom Python based script (initial), Restic and Rclone (final) services that backup configuration of all critical services to AWS S3.
- Store and backup personal/private information such as family photos, password manager, calendar, contacts and tax documents.
- Provide several frontend services such as Home Assistant, Nextcloud, Jellyfin, n8n, multi-index search engine, budgeting software and meal planning.

### Plane Tracking

[Project GitHub](https://github.com/shadybraden/compose/tree/main/skywatch) 

- SDR and server using Ultrafeeder to show a web interface for viewing live aircraft transmitting on ADS-B.
- A custom python script run often to pull the data from UltraFeeder API then parsing it to find interesting aircraft (deﬁned by custom watchlist, type etc.) and phone notiﬁcations using central NTFY server. All so I can take the [photos seen here](https://shadybraden.com/aircraft/#thunder-over-new-hampshire-2025).

## Education

### UMass Lowell

Mechanical Engineering Bachelor's degree | 2019-2023

## Certifications

| Certification        | Date Achieved  |
| -------------------- | -------------- |
| CompTIA Security+    | March 22, 2024 |
| DoD Secret Clearance | July 1, 2024   |