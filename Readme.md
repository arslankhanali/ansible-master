# Install 
``` sh
# On RHEL
dnf install -y ansible-core

# On mac 
brew install ansible
```

# SSH setup for remote host
```sh
# If you dont already have a ssh key pair
ssh-keygen -t rsa -b 4096

# Copy your public key to host
ssh-copy-id -o StrictHostKeyChecking=no <user>@<ip_address>
```

# Important links
1. [ansible.cfg option](https://docs.ansible.com/ansible/2.9/reference_appendices/config.html#common-options)
2. [inventory option](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters)
3. [playbook keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)
4. [all modules](https://docs.ansible.com/ansible/latest/collections/index_module.html)
5. [fedora systemroles](https://galaxy.ansible.com/ui/repo/published/fedora/linux_system_roles/content/)

# Run ansible
ansible is for adhoc commands
``` sh
# List all hosts configured in inventory 
ansible --list-hosts all

# ping
ansible all -m ping # Run on all
ansible g1 -m ping # Run on group of nodes
ansible node1 -m ping # Run on single node named `node1` in inventory file

# command
ansible node1 -m command -a "hostname"

# Gather Facts
ansible node1 -m ansible.builtin.setup  >> node1_facts.json
```
# Run ansible-playbook
``` sh
# Check Syntax of all playbook in this repo
aplaybook playbooks/* --syntax-check      
ansible-playbook playbooks/index.html.j2 --syntax-check # Should give error

# See what hosts will be targetted. --list-hosts
ansible-playbook -l g123 playbooks/helloworld.yaml --list-hosts

# Run helloworld playbook.
# -u rc -c ssh|local -e variables.yaml -i inventory1 -l subset 
ansible-playbook -i inventory -l all playbooks/helloworld.yaml
ansible-playbook -l all   playbooks/helloworld.yaml # Run on all

# --step , step through each task 1 by 1
ansible-playbook -l node1 playbooks/helloworld.yaml --step

# Playbook to gather facts
ansible-playbook -l node1 playbooks/gatherFacts.yaml 
```

# Imp files
1. inventory
2. on mac
   1. /etc/hosts
   2. /Users/arslankhan/.ssh/config
3. ansible.cfg
4. variable file
   1. good to put it in `host_vars` folder

# Notes
1. **Gather facts:** is implicit by default i.e. true
2. **Quotes**: Put `single quotes` inside `double quotes`. `"''"`
   1. Escape single quotes that are used as plain texts not to segment
   2. `"command='su root -c \'touch /etc/sudoers.d/rc\'' responses=Password=billu"`
   3. Essitially put escape character `\` with evertthing except first `"` before command and first `'` before sudo. No escape ch when these `" and '` close as well.
3. **Command vs Shell**: Careful about characters with `command` module. Some cannot be processed through the shell, so variables like `$HOME` and operations like `"<", ">", "|", and "&" `will not work.
   1. In such cases use `shell` module
   2. command is safer and preferred over shell

# Variables
When adding a new host to inventory. Its a good idea to put all its variables in `host_vars/<hostname>.yaml` file  

In Ansible, when dealing with variable precedence, the order of precedence from highest to lowest is as follows:
1. **Variables defined in the playbook**: These variables are defined within the playbook itself using `vars` or `vars_files` directives.
2. **Variables defined in inventory**: Variables defined within the inventory file or in inventory `group_vars` or `host_vars` directories.
3. **Variables defined in roles**: Variables defined within roles, either in `defaults/main.yml`, `vars/main.yml`, or using `vars_files`.
4. **Variables defined in the playbook directory**: Variables defined in `host_vars` takes precedance over `group_vars` within the playbook directory.
5. **Variables defined in the `ansible.cfg` file**: These are global variables set in the `ansible.cfg` configuration file.
6. **Environment variables**: Variables set in the environment where Ansible is executed. These take precedence over variables set in configuration files.
``` sh
# CHECK Which variables a host is picking up or prioritising
ansible-inventory --host node1

ansible-playbook -l node1 playbooks/motd_set.yaml  -e @variables.yaml # Give variables from a file
ansible-playbook -l node1 playbooks/motd_set.yaml -e "motd='FROM CLI : Savvy!'" # Give variable value in CLI
ansible-playbook -l node1 playbooks/motd_set.yaml -e @variables.yaml -e "welcome_message='FROM CLI - Defined'" # Later will be used
```

# Mac
``` sh
# --connection=local so it does not try to ssh into the mac
ansible-playbook -l localhost playbooks/helloworld.yaml -c local
ansible-playbook -l localhost playbooks/mac.yaml --connection=local

# To run as root
ansible-playbook -l localhost playbooks/mac.yaml --connection=local --ask-become-pass 
```

# Inventory
``` sh
# list 
ansible-inventory --inventory inventory --list # All details in yaml format
ansible-inventory --list
ansible-inventory --graph                      # All hosts and groups
ansible-inventory --graph --vars               # What variables is each host picking up

# Get info on host
ansible-inventory --host node1
```

# Remote Host
```sh
# You can run anisble playbooks on any host as long as you can SSH into that machine
# Install sshpass on mac
brew install sshpass
```

# ansible.cfg
``` sh
# View current config
ansible-config view

#ansible.cfg preference order
1. ANSIBLE_CONFIG (environment variable if set)  
2. ansible.cfg (in the current directory)  -> `our method`
3. ~/.ansible.cfg (in the home directory)  
4. /etc/ansible/ansible.cfg  

cat <<EOF > /etc/ansible/ansible.cfg
[defaults]
inventory = ./inventory
remote_user = rc
private_key_file = ./keys/id_rsa
ansible_ssh_common_args = -o ControlMaster=auto -o ControlPersist=60s -o 
EOF
```

# Roles
```sh
# Install Fedora system roles
ansible-galaxy collection install fedora.linux_system_roles
```

# Using Vaults
``` sh
# New file
ansible-vault create passwords.yaml

# if password file is encrypted & you are happy to be prompted
ansible-playbook -l node9 playbooks/ping.yaml -e @secrets/passwords-encrypted.yaml --ask-vault-pass

# if password file is encrypted & DO NOT want to be prompted
ansible-playbook -l node9 playbooks/ping.yaml -e @secrets/passwords-encrypted.yaml --vault-password-file secrets/password-vault

# if password file is NOT encrypted
ansible-playbook -l node9 playbooks/ping.yaml -e @secrets/passwords-plaintext.yaml
```