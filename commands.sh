in# Select all the assets and the groups they are in and stores the result in the /tmp/result file. 
# The format is the following : 
#
# Asset1  Group1
# Asset1  Group2
# Asset1  Group3
# Asset2  Group1
# Asset3  Group2
# Asset3  Group4

echo "select host.hostname, host_group.name from host, host_group, host_group_reference where host.id=host_group_reference.host_id AND host_group.id=host_group_reference.host_group_id ORDER BY host.hostname ASC;" |ossim-db > /tmp/result 
