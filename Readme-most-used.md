# Quick VM setup for ansible
Use `-i 172.16.79.145,` if you dont want to first configure inventory file. Catch is that playbook should have `hosts: all` in it
``` sh
# Any new host
ansible-playbook ~/Codes/ansible-master/playbooks/vm_initial.yaml --ask-pass -u rc -e ansible_become_pass=fox -i 172.16.79.145,
# node1 
ansible-playbook ~/Codes/ansible-master/playbooks/vm_initial_rhel.yaml --ask-pass -u rc -e ansible_become_pass=fox  -e hostname=node1 -i 172.16.79.145,          
# fedora1
ansible-playbook ~/Codes/ansible-master/playbooks/vm_initial_fedora.yaml --ask-pass -u rc -e ansible_become_pass=fox -e "packages_to_install=['cockpit','vim']" -i 172.16.79.157,    
# Red Hat lab
ansible-playbook ~/Codes/ansible-master/playbooks/squid_proxy.yaml -i 172.25.252.1, \
  --private-key=~/.ssh/rht_classroom.rsa \
  -u student \
  --ssh-common-args="-o ProxyJump=cloud-user@148.62.92.65:22022 -p 53009" \
  --extra-vars "squid_localnet=172.25.252.1/24"  
```

# Most used 
``` sh
# syntax-check 
ansible-playbook playbooks/* --syntax-check 

# target hosts for this playbook
ansible-playbook -l node9 playbooks/helloworld.yaml --list-hosts

# list all host/group
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