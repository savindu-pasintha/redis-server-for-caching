# redis-server-for-caching
### https://redis.io/learn/howtos/quick-start

# Installing 
`
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get install redis-stack-server
`

# Add VM firewall rule for allow-redis-server Port TLS : 6379 and Source IP ranges" to 0.0.0.0/0

# Verify the installion

`
sudo systemctl start redis-stack-server
sudo systemctl enable redis-stack-server
sudo systemctl status redis-stack-server
`

# For cnnect redis CLI
`
redis-cli
`

# Application Statrt as Node Pm2 Process for auto run

## sudo npm install -g pm2
## nano redis.config.js
## copy the bellow Text
## mkdir -p ./redis-logs
## chmod 755 ./redis-logs

`
module.exports = {
  apps: [
    {
      name: 'redis-server',
      script: '/usr/bin/redis-server',
      args: '/etc/redis/redis.conf',
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',  // Optional: adjust memory limit as needed
      log_file: './redis-logs/redis-server.log',
      out_file: './redis-logs/redis-server.out.log',
      error_file: './redis-logs/redis-server.err.log'
    }
  ]
};
`
## For start
`
pm2 start redis.config.js
pm2 save
pm2 startup
`

# For PM2 process management
`
pm2 ls
pm2 status
pm2 stop redis-server
pm2 restart redis-server
pm2 restart redis-server
pm2 delete redis-server
`







