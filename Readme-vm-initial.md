# Routine to configure VM

# Get files in order
```sh
# Create and edit host var file.
cp host_vars/vm_rhel_template.yaml host_vars/node.yaml  
vim host_vars/node.yaml  

# Create entry to inventory file
node ansible_host=192.168.1.1

# put passwords in secrets/passwords-<node> file
cat > secrets/passwords-encrypted.yaml << EOF
ansible_password: SUPERDOOPER
ansible_become_pass: SUPERDOOPER
EOF

# encrypt password file
ansible-vault encrypt secrets/passwords-encrypted.yaml
```
# Change files on mac
I have softlinks for imp files in the `softlinks` folder
```sh
# Softlinked created with
ln -s ~/.ssh/config softlinks/sshconfig 
ln -s /etc/hosts softlinks/hosts 
```
Update these files so
1. You can use hostname instead of IPs to reference VM
2. You do not have to specific user when logging in. 
3. Result: login as `ssh node` instead of `ssh rc@192.168.1.1`

# Run ansible playbooks
```sh
# Check variables for host
ansible-inventory --host node  

# Check if connection is successful
ansible-playbook -l node playbooks/ping.yaml -e @secrets/passwords-encrypted.yaml --ask-vault-pass

# Run
ansible-playbook -l node playbooks/vm_initial.yaml -e @secrets/passwords-encrypted.yaml --ask-vault-pass
```
### All good now
You can run any playbook on the VM now because
1. ansible_user is root
2. We have copied ssh public key so no need to give password from a file now
```sh
ansible-playbook -l node9 playbooks/colorpromptprompt.yaml
```