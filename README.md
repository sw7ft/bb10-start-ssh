to use this run the script in the .profile of term49 with berrymuchOS


include this code inside (update the path to where you place the script i placed my in Apps/start-sshd.sh

# Start sshd persistently
if [ -x "$HOME/Apps/start_sshd.sh" ]; then
    PIDFILE="$HOME/Apps/.sshd.pid"
    # Check if the PID file exists and if the process is running
    if [ ! -f "$PIDFILE" ] || ! ps -p "$(cat "$PIDFILE")" > /dev/null 2>&1; then
        # Start the script in the background, redirecting output to log file
        "$HOME/Apps/start_sshd.sh" >> "$HOME/Apps/sshd_persistent.log" 2>&1 &
    fi
fi
