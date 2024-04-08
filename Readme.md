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
ssh-copy-id -o StrictHostKeyChecking=no -i /Users/arslankhan/.ssh/id_rsa rc@<ip_address>
# or
ansible-playbook -l node1 playbooks/ssh_copy_publickey.yaml -e ssh_key_path="/Users/arslankhan/.ssh/id_rsa.pub" -e remote_user="rc"
```
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
# Check Syntax of playbook. --syntax-check
ansible-playbook playbooks/index.html.j2 --syntax-check # Should give error

# See what hosts will be targetted. --list-hosts
ansible-playbook -l g123 playbooks/helloworld.yaml --list-hosts

# Run helloworld playbook.
# Select inventory file with -i 
# Select subset of hosts with -l. 
ansible-playbook -i inventory -l all playbooks/helloworld.yaml
ansible-playbook -l all   playbooks/helloworld.yaml # Run on all
ansible-playbook -l g1    playbooks/helloworld.yaml # Run on a group of node
ansible-playbook -l node1 playbooks/helloworld.yaml # Run on a single node

# Specify ansible user. -u
ansible-playbook -l node1 playbooks/gatherFacts.yaml -u rc

# --step , step through each task 1 by 1
ansible-playbook -l node1 playbooks/helloworld.yaml --step

# Playbook to gather facts
ansible-playbook -l node1 playbooks/gatherFacts.yaml 
```

# Variables
Provide variables for playbooks
``` sh
# We are setting 'welcome_message' variable in motd playbooks
# -e 
ansible-playbook -l node1 playbooks/motd_1set.yaml # Needs no variable - Savy
ansible-playbook -l node1 playbooks/motd_2add.yaml # Variable file defined inside playbook. File is `variables.yaml` in this repo
ansible-playbook -l node1 playbooks/motd_3replace.yaml  -e @variables.yaml # Give variables from a file
ansible-playbook -l node1 playbooks/motd_3replace.yaml  -e welcome_message="Aho" # Give variable value in CLI
ansible-playbook -l node1 playbooks/motd_3replace.yaml  -e @variables.yaml -e welcome_message="defined_later"  # If same variable is defined at two places and given to the playbook. The one defined later is given preference. `-e welcome_message="defined_later" in this case.
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
ansible-inventory --inventory inventory --list
ansible-inventory --graph

# Get info on host
ansible-inventory --host node1
```

# Remote Host
```sh
# You can run anisble playbooks on any host as long as you can SSH into that machine
# Install sshpass on mac
brew install sshpass

# Create a password file 
cat <<EOF > password_any_name.yaml
ansible_password: <your_ssh_password>
EOF

# Add to inventory file 

cat <<EOF >> inventory
[remote]
ceph ansible_host=ssh.ocpvdev01.dal10.infra.demo.redhat.com ansible_port=30087 ansible_user=lab-user ansible_password=@password_ceph.yml
EOF

# Run playbooks on remote server. Use group name or the hostname we set
ansible-playbook -l remote playbooks/motd_1set.yaml 
# or
ansible-playbook -l ceph playbooks/motd_1set.yaml 

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
ansible_ssh_common_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no
become_password = YourBecomePassword
EOF
```
# Help 
``` sh
# (.venv) arslankhan ansible-master % ansible -h
usage: ansible [-h] [--version] [-v] [-b] [--become-method BECOME_METHOD] [--become-user BECOME_USER]
               [-K | --become-password-file BECOME_PASSWORD_FILE] [-i INVENTORY] [--list-hosts] [-l SUBSET] [-P POLL_INTERVAL] [-B SECONDS]
               [-o] [-t TREE] [--private-key PRIVATE_KEY_FILE] [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT]
               [--ssh-common-args SSH_COMMON_ARGS] [--sftp-extra-args SFTP_EXTRA_ARGS] [--scp-extra-args SCP_EXTRA_ARGS]
               [--ssh-extra-args SSH_EXTRA_ARGS] [-k | --connection-password-file CONNECTION_PASSWORD_FILE] [-C] [-D] [-e EXTRA_VARS]
               [--vault-id VAULT_IDS] [-J | --vault-password-file VAULT_PASSWORD_FILES] [-f FORKS] [-M MODULE_PATH]
               [--playbook-dir BASEDIR] [--task-timeout TASK_TIMEOUT] [-a MODULE_ARGS] [-m MODULE_NAME]
               pattern

Define and run a single task 'playbook' against a set of hosts

positional arguments:
  pattern               host pattern

# (.venv) arslankhan ansible-master % ansible-playbook -h
usage: ansible-playbook [-h] [--version] [-v] [--private-key PRIVATE_KEY_FILE] [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT]
                        [--ssh-common-args SSH_COMMON_ARGS] [--sftp-extra-args SFTP_EXTRA_ARGS] [--scp-extra-args SCP_EXTRA_ARGS]
                        [--ssh-extra-args SSH_EXTRA_ARGS] [-k | --connection-password-file CONNECTION_PASSWORD_FILE] [--force-handlers]
                        [--flush-cache] [-b] [--become-method BECOME_METHOD] [--become-user BECOME_USER]
                        [-K | --become-password-file BECOME_PASSWORD_FILE] [-t TAGS] [--skip-tags SKIP_TAGS] [-C] [-D] [-i INVENTORY]
                        [--list-hosts] [-l SUBSET] [-e EXTRA_VARS] [--vault-id VAULT_IDS] [-J | --vault-password-file VAULT_PASSWORD_FILES]
                        [-f FORKS] [-M MODULE_PATH] [--syntax-check] [--list-tasks] [--list-tags] [--step] [--start-at-task START_AT_TASK]
                        playbook [playbook ...]

Runs Ansible playbooks, executing the defined tasks on the targeted hosts.

positional arguments:
  playbook              Playbook(s)
```