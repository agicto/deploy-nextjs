#!/bin/sh

# Setup SSH
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keyscan -p $SSH_PORT -H $SSH_HOST >> ~/.ssh/known_hosts

# Upload files to CDN
echo "Uploading files to CDN..."
python3 upload-to-volc.py

# Execute remote commands
echo "Executing remote commands..."
ssh -p $SSH_PORT $SSH_USER@$SSH_HOST << 'EOF'
    cd /path/to/your/project
    # Add your commands here, for example:
    git pull
    pnpm install
    pm2 restart your-app
EOF

# Clean up SSH key
rm -rf ~/.ssh 