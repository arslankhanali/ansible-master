# Important links
1. [ansible.cfg option](https://docs.ansible.com/ansible/2.9/reference_appendices/config.html#common-options)
2. [inventory option](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters)
3. [playbook keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)
4. [all modules](https://docs.ansible.com/ansible/latest/collections/index_module.html)
5. [fedora systemroles](https://galaxy.ansible.com/ui/repo/published/fedora/linux_system_roles/content/)


# Notes
1. **Gather facts:** is implicit by default i.e. true
2. **Quotes**: Put `single quotes` insite `double quotes`. `"''"`
   1. Escape single quotes that are used as plain texts not to segment
   2. `"command='su root -c \'touch /etc/sudoers.d/rc\'' responses=Password=billu"`
   3. Essitially put escape character `\` with evertthing except first `"` before command and `'` before sudo. No excape when these close as well.
3. **Command vs Shell**: Careful about characters with `command` module. Some cannot be processed through the shell, so variables like `$HOME` and operations like `"<", ">", "|", and "&" `will not work.
   1. In such cases use `shell` module
   2. command is safer and preferred over shell
