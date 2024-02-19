import json
from datetime import datetime

def parse_network(file_path, file_name = "network.txt"):
    with open(file_path, 'r') as file:
        last_line = None
        for line in file:
            last_line = line
        last_line = last_line.strip()

    last_line = last_line.split(',')
    timestamp_str, sent_bytes_str, received_bytes_str = last_line

    result = int(sent_bytes_str) + int(received_bytes_str)
    result_kb = result / 1024

    print(result_kb)
    return result_kb