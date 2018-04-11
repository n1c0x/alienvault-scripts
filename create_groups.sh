#!/bin/bash
# 
# this script can create multiple groups directly in the database

GRPS_NAME="/tmp/grps_name"
GRPS_NAME_TMP="/tmp/grps_name_tmp"

id=''
ctx='048CBAC03F8D11E6B140005056A88E78'
same_host='0'
name=''
threshold_c='0'
threshold_a='0'
rrd_profile=NULL
descr=''
permissions=''
owner=''

# Check if the name isn't already in the database
request="select name from host_group;"
echo "select name from host_group;" | ossim-db > $GRPS_NAME
tail -n +2 $GRPS_NAME > $GRPS_NAME_TMP 

cat $GRPS_NAME_TMP > $GRPS_NAME
#cat $GRPS_NAME

OLDIFS=$IFS
IFS=,
[ ! -f $GRPS_NAME ] && { echo "$GRPS_NAME file not found"; exit 99; }
while read group_name
do
	tbl_groups+=("$group_name")
done < $GRPS_NAME
IFS=$OLDIFS

#echo ${tbl_groups[@]}

INPUT="$1"
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read name descr
do
	for i in "${tbl_groups[@]}"
	do
		if [ $i = $name ]; then 
			exclude=$i
		fi
	done
	
	if [ $name = $exclude ]; then
		echo "The group $exclude already exists, please choose another groupe name.";
	else
		# Generate the id
		id=`php -r 'print(strtoupper(md5(uniqid(mt_rand()))));'`
	
		echo "INSERT INTO host_group (id, ctx, same_host, name, threshold_c, threshold_a, rrd_profile, descr, permissions, owner) VALUES (unhex('$id'),unhex('$ctx'), '$same_host', '$name', '$threshold_c', '$threshold_a', $rrd_profile, '$descr','$permissions','$owner'); " | ossim-db
		echo "Group $name created. "
	fi
done < $INPUT
IFS=$OLDIFS
