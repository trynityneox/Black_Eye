# Kali Linux Setup Guide

This guide will help you set up the Phishing Automation Tool on **Kali Linux**.

---

## Step 1: Transfer Files to Kali Linux

### Option A: Using Git (Recommended)
```bash
cd ~
git clone <your-repo-url>
cd blackeye-im-master
```

### Option B: Using SCP (from Windows to Kali)
```bash
# On Kali Linux, find your IP
ip a

# On Windows PowerShell
scp -r "d:\Vishnu\Tools\blackeye-im-master" kali@<KALI_IP>:~/
```

### Option C: Using USB/Shared Folder
Copy the entire `blackeye-im-master` folder to your Kali Linux home directory.

---

## Step 2: Install Dependencies

```bash
# Update package list
sudo apt-get update

# Install PHP (usually pre-installed on Kali)
sudo apt-get install -y php

# Install curl (usually pre-installed on Kali)
sudo apt-get install -y curl

# Install jq (JSON processor)
sudo apt-get install -y jq
```

---

## Step 3: Install ngrok

```bash
# Download ngrok
cd /tmp
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

# Extract
tar -xvzf ngrok-v3-stable-linux-amd64.tgz

# Move to system path
sudo mv ngrok /usr/local/bin/

# Verify installation
ngrok version
```

---

## Step 4: Setup ngrok Authentication

1. **Get your auth token**:
   - Open browser: https://dashboard.ngrok.com/get-started/your-authtoken
   - Sign up/Login to ngrok
   - Copy your auth token

2. **Authenticate ngrok**:
```bash
ngrok authtoken YOUR_AUTH_TOKEN_HERE
```

Example:
```bash
ngrok authtoken 2a8Bx9Y3z1C4D5E6F7G8H9I0J1K2L3M4N5O6P7Q8R9S0T1
```

---

## Step 5: Make Script Executable

```bash
cd ~/blackeye-im-master
chmod +x phishing-tool.sh
```

---

## Step 6: Run the Tool

```bash
./phishing-tool.sh
```

---

## Verification Checklist

Before running the tool, verify all dependencies:

```bash
# Check PHP
php -v
# Expected: PHP 7.x or 8.x

# Check curl
curl --version
# Expected: curl 7.x or 8.x

# Check jq
jq --version
# Expected: jq-1.x

# Check ngrok
ngrok version
# Expected: ngrok version 3.x

# Check ngrok authentication
ngrok config check
# Expected: Valid configuration
```

---

## Firewall Configuration (If Needed)

If you're running Kali with UFW firewall enabled:

```bash
# Allow port 8080 (PHP server)
sudo ufw allow 8080/tcp

# Check firewall status
sudo ufw status
```

---

## Common Kali Linux Issues & Solutions

### Issue 1: Permission Denied

**Problem**: `./phishing-tool.sh: Permission denied`

**Solution**:
```bash
chmod +x phishing-tool.sh
```

### Issue 2: PHP Not Found

**Problem**: `PHP is not installed`

**Solution**:
```bash
sudo apt-get update
sudo apt-get install -y php
```

### Issue 3: ngrok Connection Failed

**Problem**: `Failed to get ngrok URL`

**Solution**:
1. Check internet connection
2. Verify ngrok authentication: `ngrok config check`
3. Re-authenticate: `ngrok authtoken YOUR_TOKEN`

### Issue 4: Port 8080 Already in Use

**Problem**: `Address already in use`

**Solution**:
```bash
# Find what's using port 8080
sudo netstat -tulpn | grep 8080

# Kill the process (replace PID with actual process ID)
sudo kill -9 PID

# Or change the port in phishing-tool.sh
nano phishing-tool.sh
# Change: PHP_PORT=8080 to PHP_PORT=8081
```

---

## Running as Root (Optional)

If you need to run on privileged ports (80, 443):

```bash
sudo ./phishing-tool.sh
```

---

## Kali Linux Specific Features

### 1. Multiple Terminal Sessions

Open multiple terminals to monitor:

**Terminal 1**: Run the phishing tool
```bash
./phishing-tool.sh
```

**Terminal 2**: Monitor network traffic
```bash
sudo tcpdump -i any port 8080
```

**Terminal 3**: Watch logs
```bash
watch -n 1 cat sites/facebook/usernames.txt
```

### 2. Using with Metasploit (Advanced)

You can integrate with Metasploit for advanced testing:

```bash
# In another terminal
msfconsole
use auxiliary/server/capture/http_basic
set SRVPORT 8090
run
```

---

## Quick Test Run

Test if everything works:

```bash
# 1. Navigate to directory
cd ~/blackeye-im-master

# 2. Run the tool
./phishing-tool.sh

# 3. Select any site (e.g., type: 1 for Adobe)

# 4. Wait for ngrok URL to appear

# 5. Test the URL yourself in browser
#    (Open the ngrok URL in Firefox on Kali)

# 6. Enter dummy credentials to test capture

# 7. Watch credentials appear in terminal

# 8. Press Ctrl+C to stop
```

---

## Network Configuration Tips

### Using on Local Network Only (No Internet Required)

If you want to test without ngrok (local network only):

```bash
# Find your local IP
ip a | grep "inet "

# Start PHP server manually
cd sites/facebook
php -S 0.0.0.0:8080

# Share URL: http://<YOUR_KALI_IP>:8080
# Example: http://192.168.1.100:8080
```

### Using with WiFi Pineapple

If you have a WiFi Pineapple:

1. Start the tool on Kali
2. Use ngrok URL
3. Configure Pineapple to redirect to ngrok URL

---

## Security Considerations on Kali

### Keep Your System Updated

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### Use a Dedicated Testing Network

- Never run on production networks
- Use isolated VLANs or separate WiFi
- Document all activities

### Clean Up After Testing

```bash
# Remove captured credentials
find sites/ -name "usernames.txt" -type f -delete

# Clear bash history (if needed)
history -c
```

---

## Performance Optimization

### For Multiple Users (Load Testing)

If testing with many employees simultaneously:

```bash
# Increase PHP-FPM limits (if using PHP-FPM)
sudo nano /etc/php/8.2/fpm/pool.d/www.conf
# Adjust: pm.max_children, pm.start_servers, pm.min_spare_servers

# Restart PHP-FPM
sudo systemctl restart php8.2-fpm
```

---

## Automation Scripts

### Auto-start on Boot (Optional)

Create a systemd service:

```bash
sudo nano /etc/systemd/system/phishing-tool.service
```

Content:
```ini
[Unit]
Description=Phishing Training Tool
After=network.target

[Service]
Type=simple
User=kali
WorkingDirectory=/home/kali/blackeye-im-master
ExecStart=/home/kali/blackeye-im-master/phishing-tool.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Enable:
```bash
sudo systemctl enable phishing-tool.service
sudo systemctl start phishing-tool.service
```

---

## Support & Troubleshooting Commands

```bash
# Check all services
systemctl status php*
systemctl status nginx  # if using nginx

# Check logs
journalctl -xe

# Network diagnostics
netstat -tulpn
ss -tuln

# Process check
ps aux | grep php
ps aux | grep ngrok
```

---

## Ready to Use!

Your Kali Linux system is now ready. Run:

```bash
cd ~/blackeye-im-master
./phishing-tool.sh
```

---

**Happy (Ethical) Hacking! 🎯**

Remember: Always get authorization, document everything, and use responsibly!
