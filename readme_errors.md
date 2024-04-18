# Errors
##############################################################################
### No inventory was parsed, only implicit localhost is available 
``` sh
[WARNING]:  * Failed to parse /Users/arslankhan/Codes/0-scripts/Ansible/inventory with yaml plugin: We were unable to read either
as JSON nor YAML, these are the errors we got from each: JSON: Expecting value: line 1 column 2 (char 1)  Syntax Error while
loading YAML.   did not find expected <document start>  The error appears to be in
'/Users/arslankhan/Codes/0-scripts/Ansible/inventory': line 2, column 1, but may be elsewhere in the file depending on the exact
syntax problem.  The offending line appears to be:  [all] node2 ansible_host=172.16.79.146 ^ here
[WARNING]:  * Failed to parse /Users/arslankhan/Codes/0-scripts/Ansible/inventory with ini plugin:
/Users/arslankhan/Codes/0-scripts/Ansible/inventory:5: Expected key=value host variable assignment, got: 127.0.0.1
[WARNING]: Unable to parse /Users/arslankhan/Codes/0-scripts/Ansible/inventory as an inventory source
[WARNING]: No inventory was parsed, only implicit localhost is available
```

> Found both group and host with same name: localhost
- old
[localhost]
localhost ansible_host=127.0.0.1
- new
[local]
localhost ansible_host=127.0.0.1

##############################################################################
# Cannot find variable
> `variable.yaml` and `variable.yml` is not the same

##############################################################################
# Ansible files keeps on showing errors
> CLose all editors in VS code

##############################################################################
# fatal: [ssh.ocpvdev01.dal10.infra.demo.redhat.com]: FAILED! => {"msg": "to use the 'ssh' connection type with passwords or pkcs11_provider, you must install the sshpass program"}
> brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb

##############################################################################
#

##############################################################################
#

##############################################################################
#

##############################################################################
#

##############################################################################
#

##############################################################################
#

##############################################################################
#

##############################################################################
#
