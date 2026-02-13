# Phishing Automation Tool

⚠️ **EDUCATIONAL PURPOSE ONLY** ⚠️

This tool is designed **exclusively** for authorized security awareness training and penetration testing in controlled environments. Unauthorized use is illegal and unethical.

---

## Features

✅ **Interactive Site Selection** - Choose from 42 pre-built phishing templates  
✅ **Automatic PHP Server** - Built-in PHP development server  
✅ **Dynamic ngrok Tunneling** - Auto-generates HTTPS URLs  
✅ **Real-time Monitoring** - See captured credentials instantly  
✅ **Clean Shutdown** - Graceful cleanup on exit  

---

## Prerequisites

### Required Software

1. **PHP** (version 7.0+)
2. **ngrok** (with valid auth token)
3. **curl**
4. **jq**

### Installation on Kali Linux

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install php curl jq -y

# Install ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xvzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/

# Authenticate ngrok (get your token from https://dashboard.ngrok.com/get-started/your-authtoken)
ngrok authtoken YOUR_AUTH_TOKEN_HERE
```

---

## Usage

### Step 1: Make the Script Executable

```bash
chmod +x phishing-tool.sh
```

### Step 2: Run the Tool

```bash
./phishing-tool.sh
```

### Step 3: Follow the Interactive Prompts

1. **Select a phishing site** from the numbered list
2. The tool will:
   - Start a PHP server on port 8080
   - Create an ngrok tunnel
   - Display the phishing URL
3. **Share the ngrok URL** with training participants
4. **Monitor captured credentials** in real-time

### Step 4: Stop the Tool

Press `Ctrl+C` to stop the tool. It will automatically:
- Stop the PHP server
- Close the ngrok tunnel
- Show a summary of captured credentials

---

## Available Phishing Templates

The tool includes templates for:

- Facebook, Instagram, Twitter
- Google, Microsoft, Apple
- Amazon, Netflix, Spotify
- LinkedIn, GitHub, GitLab
- PayPal, Bitcoin
- And 30+ more popular services

---

## How It Works

```
┌─────────────┐
│  Start Tool │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Select Site    │ ◄─── Interactive Menu
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│  PHP Server     │ ◄─── Port 8080
│  Started        │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│  ngrok Tunnel   │ ◄─── HTTPS URL Generated
│  Created        │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│  Monitor        │ ◄─── Real-time Display
│  Credentials    │
└─────────────────┘
```

---

## Output Files

Captured credentials are saved in:
```
sites/[SELECTED_SITE]/usernames.txt
```

Example format:
```
Facebook Username: victim@example.com Pass: password123
Account: victim123 Pass: mypassword
```

---

## Troubleshooting

### ngrok URL Not Generated

- **Check ngrok authentication**: Run `ngrok authtoken YOUR_TOKEN`
- **Port conflict**: Change `PHP_PORT` in the script (default: 8080)
- **Firewall**: Ensure port 8080 is not blocked

### PHP Server Failed to Start

- **PHP not installed**: Run `sudo apt-get install php`
- **Port in use**: Another service is using port 8080

### Dependencies Missing

Run the script - it will tell you which dependency is missing and how to install it.

---

## Security Best Practices

1. ✅ **Only use in authorized environments**
2. ✅ **Obtain written permission** before testing
3. ✅ **Inform participants** this is a training exercise
4. ✅ **Delete captured data** after training
5. ✅ **Document all activities**

---

## Legal Disclaimer

⚠️ **WARNING**: Unauthorized access to computer systems is illegal. This tool should only be used:

- With explicit written authorization
- For employee security awareness training
- For authorized penetration testing
- In isolated lab environments

**The authors are not responsible for misuse of this tool.**

---

## Training Workflow Example

1. **Prepare**: Get written authorization from management
2. **Notify**: Inform IT/Security team of testing schedule
3. **Execute**: Run the tool and send URLs to training participants
4. **Monitor**: Observe which employees fall for the phishing attempt
5. **Educate**: Conduct follow-up training for affected employees
6. **Report**: Document results and provide recommendations
7. **Cleanup**: Delete all captured credentials

---

## Features in Detail

### Real-time Monitoring

The tool displays captured credentials immediately:

```
════════════════════════════════════════════════════════════
[!] NEW CREDENTIALS CAPTURED!
────────────────────────────────────────────────────────────
Facebook Username: test@example.com Pass: password123
────────────────────────────────────────────────────────────
Total captures: 1
════════════════════════════════════════════════════════════
```

### Clean Shutdown

Press Ctrl+C for graceful exit:

```
[*] Cleaning up...
[✓] PHP server stopped
[✓] ngrok tunnel closed

══════════════════ CAPTURE SUMMARY ═══════════════════
Total credentials captured: 5
Saved in: sites/facebook/usernames.txt
═══════════════════════════════════════════════════════
```

---

## Customization

### Change PHP Port

Edit `PHP_PORT` variable in the script:
```bash
PHP_PORT=8080  # Change to your preferred port
```

### Add Custom Sites

1. Create a new directory in `sites/`
2. Add your HTML/PHP files
3. Ensure `login.php` saves to `usernames.txt`

---

## Support

For issues or questions:
- Check the troubleshooting section
- Ensure all dependencies are installed
- Verify ngrok authentication

---

## Version

**Version**: 1.0  
**Compatible with**: Kali Linux, Ubuntu, Debian  
**Last Updated**: 2024

---

**Remember**: Use responsibly and ethically! 🛡️
