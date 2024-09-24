#!/bin/sh

# Path to the PID file
PIDFILE="$HOME/.sshd.pid"

# Define log file
LOGFILE="$HOME/sshd_persistent.log"

# Function to start sshd
start_sshd() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting sshd in debug mode..." >> "$LOGFILE"
    sshd -Dd >> "$LOGFILE" 2>&1 &
    echo $! > "$PIDFILE"
}

# Function to stop sshd
stop_sshd() {
    if [ -f "$PIDFILE" ]; then
        PID=$(cat "$PIDFILE")
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Stopping sshd with PID $PID..." >> "$LOGFILE"
        kill "$PID"
        rm -f "$PIDFILE"
    fi
}

# Ensure only one instance is running
if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - sshd is already running with PID $PID." >> "$LOGFILE"
        exit 0
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Found stale PID file. Removing..." >> "$LOGFILE"
        rm -f "$PIDFILE"
    fi
fi

# Trap exit signals to clean up
trap stop_sshd EXIT INT TERM

# Start sshd
start_sshd

# Monitor sshd and restart if it exits
while true; do
    sleep 1
    if ! ps -p "$(cat "$PIDFILE")" > /dev/null 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - sshd has stopped. Restarting..." >> "$LOGFILE"
        start_sshd
    fi
done
