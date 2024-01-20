#!/bin/bash

interface="en0"
output_file="~/har-codcaptcha/packet_log.log"
tmp_file="/tmp/packets.pcap"
listener_log="~/har-codcaptcha/listener_log.log"

touch $output_file
chmod 776 $output_file
touch $listener_log
chmod 776 $listener_log
truncate -s 0 $listener_log

tcpdump -i $interface -w $tmp_file -C 100 & tcpdump_pid=$!

while true; do
  sleep 10

	# shellcheck disable=SC2162
  tcpdump -r $tmp_file -tttt >> $output_file

	python3 packet_listener/packet_aggregator.py >> $listener_log
	truncate -s 0 $output_file
done

trap "kill $tcpdump_pid" SIGINT SIGTERM
wait $tcpdump_pid