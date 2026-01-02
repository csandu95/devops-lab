#!/bin/bash

# Goal of this project is to write a script to analyse server performance stats.

# Requirements
# You are required to write a script server-stats.sh that can analyse basic server performance stats. You should be able to run the script on any Linux server and it should give you the following stats:
# Total CPU usage
# Total memory usage (Free vs Used including percentage)
# Total disk usage (Free vs Used including percentage)
# Top 5 processes by CPU usage
# Top 5 processes by memory usage
# Stretch goal: Feel free to optionally add more stats such as os version, uptime, load average, logged in users, failed login attempts etc.
# Once you have completed this project, you will have some basic knowledge on how to analyse server performance stats in order to debug and get a better understanding of the server's performance.

get_cpu_usage() {
    echo "CPU Usage:"
    top -b -n1 | grep "Cpu(s)" | \
    sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
    awk '{printf "Used CPU: %.2f%%\n", 100 - $1 }'
    echo
}

get_memory_usage() {
    echo "Memory Usage:"
    free -h | awk 'NR==2{printf "Used Memory: %s / %s (%.2f%%)\n", $3, $2, $3*100/$2 }'
    echo
}

get_disk_usage() {
    echo "Disk Usage:"
    df -h / | awk 'NR==2{printf "Used Disk: %s / %s (%.2f%%)\n", $3, $2, $5 }'
    echo
}

get_top_processes() {
    echo "Top 5 Processes by CPU Usage:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo

    echo "Top 5 Processes by Memory Usage:"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
    echo
}

get_additional_stats() {
    echo "Additional Stats:"
    echo "OS Version: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '\"')"
    echo "Uptime: $(uptime -p)"
    echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
    echo "Logged in Users: $(who | wc -l)"
    echo "Failed Login Attempts: $(grep 'Failed password' /var/log/auth.log | wc -l 2>/dev/null || echo 'N/A')"
    echo
}

# Main function to call all stats functions
main() {
    get_cpu_usage
    get_memory_usage
    get_disk_usage
    get_top_processes
    get_additional_stats
}

# Execute main function
main
