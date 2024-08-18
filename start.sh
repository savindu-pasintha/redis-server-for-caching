#!/bin/bash

# Begore the run start.sh :  chmod +x install_redis_pm2.sh

# Update package lists and install necessary packages
sudo apt-get update
sudo apt-get install -y curl gnupg software-properties-common

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 globally
# sudo npm install -g pm2

# Add Redis repository and install Redis
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get install -y redis-stack-server

# Create PM2 ecosystem configuration file
cat <<EOF | sudo tee /home/$(whoami)/redis.config.js
module.exports = {
  apps: [
    {
      name: 'redis-server',
      script: '/usr/bin/redis-server',
      args: '/etc/redis/redis.conf',
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',  // Optional: adjust memory limit as needed
      log_file: '/var/log/redis/redis-server.log',
      out_file: '/var/log/redis/redis-server.out.log',
      error_file: '/var/log/redis/redis-server.err.log'
    }
  ]
};
EOF

# Start Redis with PM2
pm2 start /home/$(whoami)/redis.config.js

# Save the PM2 process list
pm2 save

# Set PM2 to start on boot
pm2 startup

echo "Redis installation and configuration complete. Redis is managed by PM2."
