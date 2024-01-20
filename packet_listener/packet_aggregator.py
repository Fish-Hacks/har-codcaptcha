from pathlib import Path
from time import time
import re

packet_log = Path('./packet_log.log')
aggregate_file = Path('./packet_aggregate.log')

non_numeric = re.compile(r"\D+")

if not packet_log.exists():
    raise Exception(f"Packet log doesn't exist at {packet_log}")

if not aggregate_file.exists():
    aggregate_file.touch()
    aggregate_file.write_text('0')

current_size_kB = int(aggregate_file.read_text())
threshold_kB = 1_000


def parse_packet_size(packet: str) -> int:
    if len(packet) <= 0 or 'length' not in packet:
        return 0
    *_, size = packet.split()
    size_int = non_numeric.sub('', size)
    return int(size_int) if len(size_int) > 0 else 0


packets = packet_log.read_text().strip().split('\n')
packet_count = len(packets)
print(f"Parsing {packet_count} packets...")
start = time()
packet_sizes = map(parse_packet_size, packets)
packet_size_agg = sum(packet_sizes)
packet_size_kB = int(packet_size_agg / 1_000)
end = time()

if packet_size_kB > 100_000:
    print('Packet size is too large, skipping...')

new_size_kB = packet_size_kB + current_size_kB
print(f"Took {(end - start) * 1_000_000:.3f}μs to parse {packet_count} packets. Agg: {new_size_kB}kB")
exceeds_threshold = new_size_kB >= threshold_kB
aggregate_file.write_text(f"{new_size_kB - threshold_kB if exceeds_threshold else new_size_kB}")
