# Homelab


Personal homelab used to heberge tools and small projecy based on open-source solutions give you full control, better privacy, and no licensing fees. Here's how you can optimize your homelab using only free and open-source tools.

🌍 Updated Homelab Stack (100% Open-Source)

| Category                      | Recommended Open-Source Solution | Description |
|-------------------------------|----------------------------------|-------------|
| OS                            | Ubuntu Server                           |             |
| Containerization              | Docker                           |             |
| Container Management          | Portainer                        | Self-hosted UI for managing containers |
| Reverse Proxy & SSL           | Traefik                          | Handle HTTPS automatically |
| Networking & Firewall         | UFW                              | Uncomplicated Firewall |
| VPN                           | Wireguard                        |             |
| Monitoring & Logging          | Prometheus + Grafana (metrics & dashboards), Loki (logs) |             |
| Identity & Access Management  | Authelia                         | Self-hosted authentication, MFA |
| Secrets Management            | HashiCorp Vault, SOPS (age encryption) |             |
| CI/CD Pipeline                | Woodpecker CI (GitHub/GitLab alternative), Gitea Actions |             |
| Infrastructure as Code (IaC)  | Ansible (for automation), Terraform (optional) |             |
| File Storage & Backup         | Restic (incremental backups), BorgBackup |             |
| Database                      | PostgreSQL, MariaDB, Redis       |             |
| Search Engine                 | Meilisearch or OpenSearch (alternative to Elasticsearch) |             |
| Web Hosting                   | Caddy (lightweight), Nginx       |             |
| Security & Intrusion Detection| Fail2Ban, CrowdSec () |AI-driven security             |


**Host:**
Ubuntu Server

**Container :**
Docker 

**Network :**

| Netwok name   | Desctiption   |
| ------------- | ------------- |
| bridge		| Local admin   |
| backend       | Application admin  |
| frontend      | Exposed application |


**Project file organisation:**



    ├── docker
    │   ├── .git
    │   ├── .gitignore
    │   ├── preferences				  		  #Environment preferences   
    │   │
    │   ├── secrets                           # Secure storage for secrets
    │   │   ├── vault-config.yaml             # HashiCorp Vault config
    │   │   ├── sops.yaml                     # SOPS encryption config
    │   │
    │   ├── docker-networks                   # Network configurations
    │   │   ├── docker-compose.yml            # Defines all networks
    │   │   ├── .env                          # Stores network settings
    │   │
    │   ├── docker-admin                      # Infrastructure services
    │   │   ├── docker-compose.yml
    │   │   ├── .env
    │   │   ├── prometheus                     # Monitoring (Prometheus + Grafana)
    │   │   ├── traefik                        # Reverse proxy + SSL
    │   │   ├── loki                           # Logging system (Grafana Loki)
    │   │   ├── authelia                       # Authentication & MFA
    │   │
    │   ├── docker-tools                       # Self-hosted applications
    │   │   ├── first-app                      # Example: Penpot
    │   │   │   ├── .env
    │   │   │   ├── docker-compose.yml
    │   │   ├── second-app
    │   │
    │   ├── docker-web                         # Web applications
    │   │   ├── first-website
    │   │   │   ├── .env
    │   │   │   ├── docker-compose.yml
    │   │
    │   ├── docker-databases                   # Databases (PostgreSQL, MariaDB, Redis)
    │   │   ├── postgres
    │   │   │   ├── docker-compose.yml
    │   │   │   ├── data/                      # Persistent volume for DB
    │   │   ├── redis
    │   │
    │   ├── docker-volumes                     # Centralized storage
    │   │   ├── db_data
    │   │   ├── app_data
    │   │
    │   ├── cloudflare                         # Cloudflare configurations
    │   │   ├── cloudflare-tunnel.yml          # Cloudflare Tunnels (Zero Trust)
    │   │   ├── firewall-rules.txt             # Firewall rules
    │   │
    │   ├── ci-cd                              # CI/CD pipelines and automation
    │   │   ├── woodpecker-ci.yml              # Woodpecker CI for self-hosted pipelines
    │   │   ├── gitea-actions.yml              # Alternative: Gitea Actions
    │   │
    │   ├── logs                               # Centralized logging
    │   │   ├── traefik.log
    │   │   ├── app-logs/
    │   │
    │   ├── backups                            # Automated backups (Restic, Borg)
    │   │   ├── db-backups/
    │   │   ├── config-backups/
    │   │
    │   ├── scripts                            # Automation scripts
    │   │   ├── update.sh                      # Auto-update all containers
    │   │   ├── backup.sh                      # Backup important data
    │   │
    │   ├── security                           # Security tools and configs
    │   │   ├── fail2ban/                      # Fail2Ban config
    │   │   ├── crowdsec/                      # CrowdSec intrusion detection
    │   │   ├── firewall-rules.txt             # UFW/IPTables firewall rules
    │   │
    │   ├── docs                               # Documentation
    │   │   ├── README.md
    │   │   ├── setup-guide.md
    │   │   ├── network-diagram.png
        └── ...


# 📌 Homelab Project Backlog (Ubuntu + Cloudflare)

🔹 Milestone 1: Base System Setup (Priority: High)
 [✅] Install Ubuntu Server (Minimal installation for better security & performance)

 [✅] Set up SSH access & security (Disable root login, use SSH keys, configure UFW)

#remove '#' from PublickeyAuthentication yes & PermirRootLogin prohib-password from /etc/ssh/sshd_config : 
nano /etc/ssh/ssd_config
systemctl restart sshd

```bash
    #Create new user  : 
    apt install sudo
    useradd netwuser
    adduser newuser sudo

```
 [✅]  Configure static IP & hostname

```bash
    #Create new user  : 
    nano /etc/netwok 

    # modify
    iface <iface> inet static
        address <ip>
        netmask <mask>
        gateway <gateway>
        dns-nameservers <ipDNS1 ipDNS2>

    #reload network
    systemctl network restart
	
	#install docker packages & utilities : 
	sudo apt install ca-certificates curl gnupg lsb-release ntp htop zip unzip gnupg apt-transport-https net-tools ncdu apache2-utils
	
```

Log as newuser add your private key to .ssh/authorized_keys

 [✅] Install essential packages (ufw, curl, htop, vim, git, docker)

```bash
#Install essential packages
sudo apt install ufw curl htop vim git 

#docker installtion script : 
mkdir -p ~/docker/scripts/install/
curl -fsSL https://get.docker.com -o ~/docker/scripts/install/get-docker.sh
sudo sh ~/docker/scripts/install/get-docker.sh

```


 [✅] Harden Ubuntu security (ufw configuration, Fail2Ban, CrowdSec, automatic updates)

```bash
#Set basic firewall rules : 
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from <ip range /cidr>

#Then let's activate UFW using the command:
sudo ufw enable
```

Fail2Ban: 
```bash
# Update package list and install Fail2Ban
sudo apt-get update
sudo apt-get install fail2ban
```

Install Fail2Ban: Open a terminal and run the following command to install Fail2Ban:

```bash
# Install Fail2Ban
sudo apt-get install fail2ban
```

Configure Fail2Ban: The main configuration file for Fail2Ban is located at `/etc/fail2ban/jail.conf`. However, it is recommended to create a local configuration file to avoid overwriting your settings during updates. Copy the default configuration file to a new file called `jail.local`:

```bash
# Copy the default configuration to jail.local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

Edit the Configuration: Open the `jail.local` file in a text editor:

```bash
# Open jail.local in a text editor
sudo nano /etc/fail2ban/jail.local
```

Modify the settings as needed. For example, you can set the default ban time, find time, and max retry attempts:

```bash
# Example settings in jail.local
[DEFAULT]
bantime  = 10m
findtime = 10m
maxretry = 5
```

Enable Jails: In the `jail.local` file, you can enable specific jails for services you want to protect. For example, to enable the SSH jail, find the `[sshd]` section and set `enabled` to `true`:

```bash
# Enable SSH jail in jail.local
[sshd]
enabled = true
```

Restart Fail2Ban: After making your changes, restart the Fail2Ban service to apply the new configuration:

```bash
# Restart Fail2Ban service
sudo systemctl restart fail2ban
```

Check Status: You can check the status of Fail2Ban and see which jails are active by running:

```bash
# Check Fail2Ban status
sudo fail2ban-client status
```

Monitor Logs: Fail2Ban logs can be found in `/var/log/fail2ban.log`. You can monitor these logs to see which IPs have been banned:

```bash
# Monitor Fail2Ban logs
sudo tail -f /var/log/fail2ban.log
```

By following these steps, you should have Fail2Ban installed and configured to protect your services from brute-force attacks.

```bash
# Add the CrowdSec repository
sudo apt-get install -y curl
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash

# Install CrowdSec
sudo apt-get install crowdsec

# Configure CrowdSec
sudo nano /etc/crowdsec/config.yaml

# Install SSHD collection
sudo cscli collections install crowdsecurity/sshd

# Install and configure firewall bouncer
sudo apt-get install crowdsec-firewall-bouncer-iptables
sudo nano /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml

# Start and enable CrowdSec
sudo systemctl start crowdsec
sudo systemctl enable crowdsec

# Check CrowdSec status
sudo systemctl status crowdsec

# Monitor CrowdSec logs
sudo tail -f /var/log/crowdsec.log
```
By following these steps, you should have CrowdSec installed and configured to protect your system from various types of attacks.

```bash
# Create the update script
nano /home/$USERT/docker/scripts/update_script.sh

# Make the script executable
chmod +x /home/$USERT/docker/scripts/update_script.sh

# Add the following line to the cron job file
```bash
# Add the update script to run daily at 2 AM using the cron command
echo "0 2 * * * /home/$USERT/docker/scripts/update_script.sh >> /home/$USERT/docker/logs/system/update.log 2>&1" | sudo tee -a /var/spool/cron/crontabs/root

# Verify the crontab entry
sudo crontab -l
```



----------------------------


🔹 Milestone 2: Docker & Containerization (Priority: High)
✅ [ ] Install Docker & Docker Compose

check if installed: 
```bash
docker --v 
docker-compose --v
````


✅ [ ] Configure user permissions for Docker

#Add current user to Docker group 
sudo usermod -aG docker $USER

✅ [ ] Set up Portainer for container management

Docker compose file : docker/docker-admin

✅ [ ] Configure network bridge for Docker containers




🔹 Milestone 3: Cloudflare Integration (Priority: Critical)
✅ [ ] Register domain on Cloudflare

✅ [ ] Configure Cloudflare DNS (A/CNAME records)

✅ [ ] Set up Cloudflare Zero Trust (Tunnels, Access Policies)

✅ [ ] Enable Cloudflare firewall rules (Geo-blocking, rate limits, WAF)

✅ [ ] Restrict server access to Cloudflare IPs only

🔹 Milestone 4: Reverse Proxy & SSL (Priority: Critical)
✅ [ ] Install Traefik as a reverse proxy (or Nginx Proxy Manager)

✅ [ ] Configure Cloudflare SSL (Full or Full Strict mode)

✅ [ ] Set up automatic SSL certificates using Cloudflare API

✅ [ ] Enable global authentication (Authelia or Cloudflare Access)

🔹 Milestone 5: Self-Hosted Services (Priority: Medium-High)
✅ [ ] Deploy Gitea (GitHub alternative)

✅ [ ] Set up Woodpecker CI for automation

✅ [ ] Deploy monitoring stack (Prometheus, Grafana, Loki)

✅ [ ] Install and configure PostgreSQL/MariaDB/Redis

✅ [ ] Set up a self-hosted file storage (Nextcloud or Minio)

🔹 Milestone 6: Security & Backup (Priority: High)
✅ [ ] Configure automated backups with Restic/BorgBackup

✅ [ ] Implement database backups (pg_dump, mariadb-dump)

✅ [ ] Deploy automatic log collection (Grafana Loki, Logrotate)

✅ [ ] Enable intrusion detection (CrowdSec, Fail2Ban, Suricata)

✅ [ ] Test server recovery (restore from backup, disaster recovery plan)

🔹 Milestone 7: CI/CD & Automation (Priority: Medium)
✅ [ ] Automate deployments with GitOps (Gitea + Woodpecker CI)

✅ [ ] Set up webhook-based deployments

✅ [ ] Implement Infrastructure as Code (Ansible, Terraform)

✅ [ ] Automate server updates & patches

🔹 Milestone 8: Optimization & Scaling (Priority: Low)
✅ [ ] Implement caching (Redis, Cloudflare Cache Rules)

✅ [ ] Set up additional monitoring (Uptime Kuma, Netdata)

✅ [ ] Optimize Docker performance (resource limits, logging, network tuning)

✅ [ ] Scale services with Docker Swarm or Kubernetes (if needed)

