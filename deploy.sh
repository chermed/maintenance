#!/bin/sh
set -e

#TODO test commands and improve messages
#TODO clean script

echo "Deploy the file $1 to the environment $2 on port $3"

### PREPARATION OF PYTHON ENVIRONMENT
echo "install system packages: python3-virtualenv python3-pip"
apt update && apt install -y python3-pip python3-venv
echo "create the user python-user if not exists"
useradd -s /bin/bash python-user || echo "User already exists."
echo "create the folder /opt/$2 and fix all permissions"
mkdir /opt/$2
chown -R python-user:python-user /opt/$2
echo "create python virtualenv if not exists"
[ ! -d /opt/venv ] && /bin/su -s /bin/bash -c "python3 -m venv /opt/$2/venv" python-user

### PREPARATION OF PYTHON SERVICE
if [ -f /etc/systemd/system/client-connectors-$2.service ]; then
    echo "the service client-connectors-$2.service already exists"
else
    echo "creating the service client-connectors-$2.service"
    cat > /etc/systemd/system/client-connectors-$2.service <<EOF 
[Unit]
Description=Client connectors Env $2
 
[Service]
Type=simple
User=python-user
Group=python-user
WorkingDirectory=/opt/$2/app
ExecStart=/opt/$2/venv/bin/python manage.py run -h 0.0.0.0 -p $3
Restart=on-failure
TimeoutStopSec=300
 
[Install]
WantedBy=multi-user.target
EOF

    systemctl enable client-connectors-$2.service
    systemctl start client-connectors-$2.service

fi

### APPLICATION DEPLOYEMENT
echo "removing the directory /opt/app"
rm -rf /opt/$2/app
echo "creating the new directory /opt/app"
mkdir -p /opt/$2/app
echo "decompress the application to the directory /opt/app"
tar -xvf $1 -C /opt/$2/app
echo "change owner of /opt/app to python-user"
chown -R python-user:python-user /opt/$2/app
echo "update requirements as python-user"
[ -f /opt/$2/app/requirements.txt ] && /bin/su -s /bin/bash -c "/opt/$2/venv/bin/pip install -r /opt/$2/app/requirements.txt" python-user
echo "restart the application (service client-connectors-$2)"
systemctl stop client-connectors-$2.service || true
systemctl start client-connectors-$2.service
echo "deployement complete without errors"
