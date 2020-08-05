#!/bin/sh
set -e
#TODO test commands and improve messages
#TODO clean script
if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters"
fi
echo "Deploy the file $1 to the environment $2 on port $3"

### INIT VARIABLES
APP_BRANCH=$2
APP_ROOT=/opt/$APP_BRANCH
APP_DIR=$APP_ROOT/app
APP_VENV=$APP_ROOT/venv
APP_PORT=$3

### PREPARATION OF PYTHON ENVIRONMENT
echo "install system packages: python3-virtualenv python3-pip"
apt update && apt install -y python3-pip python3-venv
echo "create the user python-user if not exists"
useradd -s /bin/bash python-user || echo "User already exists."
echo "create the folder $APP_DIR and fix all permissions"
mkdir -p $APP_ROOT
mkdir -p $APP_DIR
chown -R python-user:python-user $APP_ROOT
echo "create python virtualenv if not exists"
[ ! -d $APP_VENV ] && /bin/su -s /bin/bash -c "python3 -m venv $APP_VENV" python-user

### PREPARATION OF PYTHON SERVICE
if [ -f /etc/systemd/system/client-connectors-$APP_BRANCH.service ]; then
    echo "the service client-connectors-$APP_BRANCH.service already exists"
else
    echo "creating the service client-connectors-$APP_BRANCH.service"
    cat > /etc/systemd/system/client-connectors-$APP_BRANCH.service <<EOF 
[Unit]
Description=Client connectors Env $APP_BRANCH
 
[Service]
Type=simple
User=python-user
Group=python-user
WorkingDirectory=/opt/$APP_BRANCH/app
ExecStart=/opt/$APP_BRANCH/venv/bin/gunicorn -b 0.0.0.0:$3 manage:app -w 4
Restart=on-failure
TimeoutStopSec=300
 
[Install]
WantedBy=multi-user.target
EOF

    systemctl enable client-connectors-$APP_BRANCH.service
    systemctl start client-connectors-$APP_BRANCH.service

fi

### APPLICATION DEPLOYEMENT
echo "removing the directory $APP_DIR"
rm -rf $APP_DIR
echo "creating the new directory $APP_DIR"
mkdir -p $APP_DIR
echo "decompress the application to the directory $APP_DIR"
tar -xvf $1 -C $APP_DIR
echo "change owner of $APP_DIR to python-user"
chown -R python-user:python-user $APP_DIR
echo "update requirements as python-user"
[ -f $APP_DIR/requirements.txt ] && /bin/su -s /bin/bash -c "/opt/$APP_BRANCH/venv/bin/pip install -r $APP_DIR/requirements.txt" python-user
echo "restart the application (service client-connectors-$APP_BRANCH)"
systemctl stop client-connectors-$APP_BRANCH.service || true
systemctl start client-connectors-$APP_BRANCH.service || true

systemctl status client-connectors-$APP_BRANCH.service
echo "deployement complete without errors"
