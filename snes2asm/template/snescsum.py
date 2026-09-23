#!/usr/bin/env python3
"""Recompute the SNES internal header checksum of a ROM image.

Usage: snescsum.py game.smc 07FDC

The offset argument is the file position of the 2-byte checksum complement;
the checksum itself follows it. The checksum is the 16-bit sum of every byte
of the image. Since the complement and checksum fields always contribute
$01FE to that sum, it is computed from the bytes outside the fields plus $01FE.
"""

import sys

def main(argv):
	if len(argv) != 3:
		print("Usage: snescsum.py file checksum-offset-hex")
		return 1

	path = argv[1]
	comp_offset = int(argv[2], 16)

	with open(path, 'rb') as f:
		data = bytearray(f.read())

	total = (sum(data) - sum(data[comp_offset:comp_offset+4]) + 0x1FE) & 0xFFFF
	complement = (~total) & 0xFFFF

	data[comp_offset:comp_offset+2] = complement.to_bytes(2, 'little')
	data[comp_offset+2:comp_offset+4] = total.to_bytes(2, 'little')

	with open(path, 'wb') as f:
		f.write(data)
	return 0

if __name__ == '__main__':
	sys.exit(main(sys.argv))
