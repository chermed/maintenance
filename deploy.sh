#!/bin/sh
set -e

#TODO test commands and improve messages


### PREPARATION OF PYTHON ENVIRONMENT
echo "install system packages: python3-virtualenv python3-pip"
apt update && apt install -y python3-pip python3-venv
echo "create the user python-user if not exists"
id -u python-user &>/dev/null || useradd -s /bin/bash python-user
echo "fix permissions on /opt"
chown -R python-user:python-user /opt/
echo "create python virtualenv if not exists"
[ ! -d /opt/venv ] && /bin/su -s /bin/bash -c 'python3 -m venv /opt/venv' python-user

### PREPARATION OF PYTHON SERVICE
if [ -f /etc/systemd/system/client-connectors.service ]; then
    echo "the service client-connectors.service already exists"
else
    echo "creating the service client-connectors.service"
    cat > /etc/systemd/system/client-connectors.service <<EOF 
[Unit]
Description=Client connectors
 
[Service]
Type=simple
User=python-user
Group=python-user
WorkingDirectory=/opt/app
ExecStart=/opt/venv/bin/python manage.py run -h 0.0.0.0 
Restart=on-failure
TimeoutStopSec=300
 
[Install]
WantedBy=multi-user.target
EOF

    systemctl enable client-connectors.service
    systemctl start client-connectors.service

fi

### APPLICATION DEPLOYEMENT
echo "removing the directory /opt/app"
rm -rf /opt/app
echo "creating the new directory /opt/app"
mkdir -p /opt/app
echo "decompress the application to the directory /opt/app"
tar -xvf $1 -C /opt/app
echo "change owner of /opt/app to python-user"
chown -R python-user:python-user /opt/app
echo "update requirements as python-user"
[ -f /opt/app/requirements.txt ] && /bin/su -s /bin/bash -c '/opt/venv/bin/pip install -r /opt/app/requirements.txt' python-user
echo "restart the application (service client-connectors)"
systemctl restart client-connectors.service
echo "deployement complete without errors"
