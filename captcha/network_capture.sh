# Function to get the current network usage in MB
get_network_usage() {
    netstat -ibn | awk 'NR>1 { sent+=$7; received+=$10 } END { print sent, received }'
}

# Function to calculate the difference in network usage
calculate_difference() {
    initial_data=($1)
    final_data=($2)

    sent_diff=$(echo "${final_data[0]} - ${initial_data[0]}" | bc)
    received_diff=$(echo "${final_data[1]} - ${initial_data[1]}" | bc)

    echo "$sent_diff,$received_diff"
}

# Main loop
while true; do
    # Get initial network usage
    initial_network_data=($(get_network_usage))

    # Sleep for 10 seconds
    sleep 10

    # Get final network usage
    final_network_data=($(get_network_usage))

    # Calculate the difference in network usage
    network_diff=$(calculate_difference "${initial_network_data[*]}" "${final_network_data[*]}")

    # Get the current date and time
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # Save the data to network.txt
    echo "$timestamp,$network_diff" >> tmp/network.txt
done
