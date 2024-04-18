mkdir host_vars
for i in {1..10}; do
    cp variables.yaml host_vars/node$i.yaml
done