# Most used 
``` sh
# syntax-check 
ansible-playbook playbooks/* --syntax-check 

# target hosts
ansible-playbook -l node9 playbooks/helloworld.yaml --list-hosts

# list host/group
ansible --list-hosts nodes

# list variables for host/group
ansible-inventory --host node9  

# copy ssh key
ssh-copy-id -o StrictHostKeyChecking=no username@192.168.1.1

# ansible
ansible node9 -m command -a hostname

# ansible-playbook
ansible-playbook -i inventory  -u rc -c ssh  -l node9 -e @host_vars/variables.yaml -e color=32 playbooks/helloworld.yaml 

# if password file is encrypted
ansible-playbook -l node9 playbooks/ping.yaml -e @passwords/passwords-encrypted.yaml --ask-vault-pass
ansible-playbook -l node9 playbooks/ping.yaml -e @passwords/passwords-encrypted.yaml --vault-password-file passwords/password-vault
# if password file is NOT encrypted
ansible-playbook -l node9 playbooks/ping.yaml -e @passwords/passwords-plaintext.yaml
```