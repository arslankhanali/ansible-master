#!/bin/bash
# Run below cmds to make user rc root
# Run 1 by 1
su root
touch /etc/sudoers.d/rc
echo "%rc ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/rc

# Useful commands
nmcli con up Bridge\ connection\ 1 
