#!/bin/bash

interface="en0"
output_file="packet_log.log"
tmp_file="/tmp/packets.pcap"

touch $output_file
chmod 776 $output_file

while true; do
  tcpdump -i $interface -c1000 -w $tmp_file
	# shellcheck disable=SC2162
  tcpdump -r $tmp_file -tttt | while read line; do
    if [[ $line =~ "length" ]]; then
  		timestamp=$(echo "$line" | cut -d ' ' -f1-2)
	    size=$(echo "$line" | awk 'NF{print $NF}')
	    s_address=$(echo "$line" | awk '{print $4}')
	    r_address=$(echo "$line" | awk '{print $6}' | rev | cut -c2- | rev)
	    echo -n -e "$timestamp\t$size\t$s_address\t$r_address\n" >> $output_file
      echo "$line" >> $output_file
    fi
	done

	truncate -s 0 $tmp_file
	python3 packet_aggregator.py
#	sleep 1
done
