# Routine to configure VM

### Pre Req
1. inventory file
2. host_vars/node9
   1. Only required value is `hostname`
3. secrets/passwords-plaintext.yaml
   
### Checks
```sh
# check variables
ansible-inventory --host node9 

# check connection
ansible-playbook -l node9 -e @secrets/passwords-plaintext.yaml playbooks/ping.yaml
```

### Setup
```sh
ansible-playbook -l node9 -e @secrets/passwords-plaintext.yaml playbooks/vm_rhel_initial.yaml  
```

### Change files on mac
1. softlinks

### All good now
You can run any playbook on the VM now because
1. ansible_user is root
2. We have copied ssh public key so no need to give password from a file now
```sh
aplaybook -l node9 playbooks/colorpromptprompt.yaml
```