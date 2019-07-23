#! /bin/bash

SSH_USER="alessander"
shift
SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5X3M1ngJgLxb94B8nU4cv/ODdq0DoR/joraTUCst9FL6bQP6WN11jBhZMmI/TrAjXeBj1whN2w3Ydy+aRHYEnpXNTj5tCOydivcRvIXRhPb6e9GFhaOjOwcvm6uTJLQEZCzOo0upXQMfO7DLnBbo5XzqeJoCouH/zpuRe46jauUsu/OtCCnj1jDowo8IBXp8SwZZEpAtJVh4yeGjFOcDah7Myc4IJharl6jT58he8PxNkP9STkComKrMAo02gp0BUzeyfcCNCULpp8qQVP9sso4u6sRrNOrsfLi1y4uLo1iFQvtrf9sGhFcGBNLDE/Js00rnkbB7pwpVVTX3X5+Wh"

# Create a user
adduser ${SSH_USER}

# And put a random password
# PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
# echo ${USER}:${PASSWORD} | chpasswd

# Add the user to the respective group so they can sudo
DISTRO=$( cat /proc/version | awk '{ print $8 }' )
# DISTRO=$( hostnamectl | grep 'Operating System' | awk '{ print $3 }' )
if [ "${DISTRO}" == "(Ubuntu" ]; then
  usermod -a -G sudo ${SSH_USER}
  CI_FILE="/etc/sudoers.d/90-cloud-init-users"
else
  usermod -a -G wheel ${SSH_USER}
  CI_FILE="/etc/sudoers.d/cloud-init"
fi

echo "${SSH_USER} ALL=(ALL) NOPASSWD:ALL" >> ${CI_FILE}

# add the ssh public key
su - ${SSH_USER} -c "umask 022 ; mkdir .ssh ; echo ${SSH_PUBLIC_KEY} >> .ssh/authorized_keys"
