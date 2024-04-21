for i in {1..10}; do
    sed -i '' '/remote_user: rc/d' "host_vars/node${i}.yaml" && echo "Line removed from node${i}.yaml"
done