#!/bin/bash
set -e

function install() {

    sed -i "s|ExecStart=.*|ExecStart=/usr/bin/${START_SCRIPT}|" ${START_SERVICE}

    sudo install -m0755 -groot -oroot ${START_SCRIPT} /usr/bin/
    sudo install -m0644 -groot -oroot ${START_SERVICE} /lib/systemd/system/

    # run START_SCRIPT 
    sudo systemctl start ${START_SERVICE}
    sudo systemctl enable ${START_SERVICE}
}

function remove() {
    if [[ -f /lib/systemd/system/${START_SERVICE} ]];then
        sudo systemctl stop ${START_SERVICE} || true
        sudo systemctl disable ${START_SERVICE} || true
    fi
    if [[ -f /usr/bin/${START_SCRIPT} ]];then
        sudo rm -vf /usr/bin/${START_SCRIPT}
    fi
}

ACTION=$1
START_SCRIPT="autostart.sh"
START_SERVICE="autostart.service"

if [[ $# -ge 2 ]];then
    START_SCRIPT=$2
fi
if [[ $# -eq 3 ]];then
    START_SERVICE=$3
fi


if [[ x${ACTION} == x"install" ]];then
    if [[ -f /lib/systemd/system/${START_SERVICE} ]];then
        remove
    fi
    install
fi

if [[ x${ACTION} == x"remove" ]];then
    remove
fi

if [[ x${ACTION} == x"" ]];then
    echo 'only support install or remove in $1'
    exit 1
fi