``` sh
# New file
ansible-vault create passwords.yaml

# Lock existing file
ansible-vault encrypt passwords.yaml

# edit
ansible-vault edit passwords.yaml

# if password file is encrypted & you are happy to be prompted
ansible-playbook -l node9 playbooks/ping.yaml -e @secrets/passwords-encrypted.yaml --ask-vault-pass

# if password file is encrypted & DO NOT want to be prompted
ansible-playbook -l node9 playbooks/ping.yaml -e @secrets/passwords-encrypted.yaml --vault-password-file secrets/password-vault

# if password file is NOT encrypted
ansible-playbook -l node9 playbooks/ping.yaml -e @secrets/passwords-plaintext.yaml

# create              Create new vault encrypted file
# decrypt             Decrypt vault encrypted file
# edit                Edit vault encrypted file
# view                View vault encrypted file
# encrypt             Encrypt YAML file
# encrypt_string      Encrypt a string
# rekey               Re-key a vault encrypted file
```