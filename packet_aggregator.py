from pathlib import Path
from time import time
import re

debug = True

packet_log = Path('./packet_log.log')
aggregate_file = Path('./packet_aggregate.log')

non_numeric = re.compile(r"\D+")

if not packet_log.exists():
    raise Exception(f"Packet log doesn't exist at {packet_log}")

aggregate_file.touch()


def parse_packet_size(packet: str) -> int:
    _, size, *_ = packet.split('\t')
    size_int = non_numeric.sub('', size)
    return int(size_int) if len(size_int) > 0 else 0


packets = packet_log.read_text().strip().split('\n')
packet_count = len(packets)
if debug:
    packets = (packet for i, packet in enumerate(packets) if i % 2 == 0)
    packet_count = int(packet_count / 2)
print(f"Parsing {packet_count} packets...")
start = time()
packet_sizes = map(parse_packet_size, packets)
packet_size_agg = sum(packet_sizes)
packet_size_kB = int(packet_size_agg / 1_000)
end = time()
if debug:
    print(f"Took {(end - start) * 1_000_000:f}μs to parse {packet_count} packets. Agg: {packet_size_kB}kB")
aggregate_file.write_text(f"{packet_size_kB}")
