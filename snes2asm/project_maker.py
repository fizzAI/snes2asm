# -*- coding: utf-8 -*-

import os
import shutil
from string import Template
from snes2asm import template as template_path
from snes2asm.decoder import ansi_escape

class ProjectMaker:

	def __init__(self, cart, disasm):
		self.cart = cart
		self.disasm = disasm

	def output(self, dir):
		print("Writing project files...")
		if not os.path.isdir(dir):
			os.mkdir(dir)

		self.create_header(dir)
		self.create_link_script(dir)
		self.create_checksum_script(dir)
		self.create_makefile(dir)
		self.bank_code(dir)
		self.copy_files(dir)

		# Write support code
		filename = "%s/constants.asm" % dir
		f = open(filename, 'w')
		f.write(self.disasm.support_code())
		f.close()

		# Write bank assembly code
		for bank in range(0, self.cart.bank_count()):
			code = self.disasm.bank_code(bank)
			filename = "%s/bank%d.asm" % (dir, bank)
			f = open(filename, 'w')
			f.write(code)
			f.close()


		# Write decoder files
		for decoder in self.disasm.decoders.items():
			for file, content in decoder.files.items():
				filename = "%s/%s" % (dir, file)
				mode = 'w' if type(content) == str else 'wb'
				f = open(filename, mode)
				f.write(content)
				f.close()

		# Write support decoder files
		for decoder in self.disasm.support_decoders:
			for file, content in decoder.files.items():
				filename = "%s/%s" % (dir, file)
				f = open(filename, 'wb')
				f.write(content)
				f.close()

	def copy_files(self, dir):
		files = ['snes.asm', 'spc700.asm']
		for f in files:
			shutil.copyfile("%s/%s" % (template_path.__path__[0], f), "%s/%s" % (dir, f) )

	def bank_code(self, dir):
		f = open("%s/main.s" % template_path.__path__[0])
		main_temp = f.read()
		f.close()
		temp = PercentTemplate(main_temp)
		bank_includes = "\n".join([".include \"bank%d.asm\"" % i for i in range(0, self.cart.bank_count())])
		main = temp.substitute(banks=bank_includes)
		f = open("%s/main.s" % dir, 'w')
		f.write(main)
		f.close()

	def create_makefile(self, dir):
		f = open("%s/Makefile" % template_path.__path__[0])
		makefile_temp = f.read()
		f.close()

		compress_targets = self.disasm.get_compress_targets()

		encode_files = " ".join([t[0] for t in compress_targets])
		encode_targets = ''
		for (target_file, source_file, compress_type) in compress_targets:
			encode_targets += "%s: %s\n\t$(PACKER) pack -x %s -o $@ $<\n\n" % (target_file, source_file, compress_type);
		temp = PercentTemplate(makefile_temp)
		makefile = temp.safe_substitute(
			encode_files=encode_files,
			endcode_targets=encode_targets,
			empty_fill="%02X" % self.cart.empty_fill,
			checksum_offset="%06X" % (self.cart.header + 44))
		f = open("%s/Makefile" % dir, 'w')
		f.write(makefile)
		f.close()

	def create_header(self, dir):
		header = self.cart.data[self.cart.header:self.cart.header+80]
		code = []
		code.append("; SNES ROM header, 80 bytes at $%04X in the ROM image\n" % self.cart.header)
		code.append("; The checksum bytes are recomputed at build time by snescsum.py\n\n")
		code.append(".section .hdr,\"a\"\n\n")
		code.append("\t.byte $%02X, $%02X\t\t\t; Maker code\n" % (header[0], header[1]))
		code.append("\t.ascii \"%s\"\t\t; Game code\n" % ansi_escape(self.cart.game_code))
		code.append("\t.byte %s\t; Fixed\n" % self.byte_row(header[6:13]))
		code.append("\t.byte %s\t; Extended header (expand RAM $%02X, special version $%02X, sub type $%02X)\n" % (
			self.byte_row(header[13:16]), self.cart.expand_ram & 0xFF, self.cart.special_version & 0xFF, self.cart.sub_type & 0xFF))
		code.append("\t.ascii \"%s\"\t\t; Program title\n" % ansi_escape(self.cart.title[0:21].ljust(21)))
		code.append("\t.byte $%02X\t\t\t; ROM makeup / map mode\n" % self.cart.map_mode)
		code.append("\t.byte $%02X\t\t\t; Cartridge type\n" % self.cart.cart_type)
		code.append("\t.byte $%02X\t\t\t; ROM size\n" % self.cart.rom_size)
		code.append("\t.byte $%02X\t\t\t; SRAM size\n" % self.cart.sram_size)
		code.append("\t.byte $%02X\t\t\t; Country / TV format\n" % self.cart.country)
		code.append("\t.byte $%02X\t\t\t; License code\n" % self.cart.license_code)
		code.append("\t.byte $%02X\t\t\t; Version\n" % self.cart.version)
		code.append("\t.byte $%02X, $%02X\t\t; Checksum complement (fixed up at build)\n" % (header[44], header[45]))
		code.append("\t.byte $%02X, $%02X\t\t; Checksum (fixed up at build)\n" % (header[46], header[47]))
		code.append("\t.byte %s\t; Unused\n\n" % self.byte_row(header[48:52]))
		code.append("\t; Native mode vectors\n")
		for name, comment in [("nvec_cop", "COP"), ("nvec_brk", "BRK"), ("nvec_abort", "ABORT"),
				("nvec_nmi", "NMI"), ("nvec_reset", "IRQ"), ("nvec_irq", "unused")]:
			code.append("\t%s\t\t; %s\n" % (self.vector_operand(getattr(self.cart, name)), comment))
		code.append("\n\t.byte %s\t; Unused\n\n" % self.byte_row(header[64:68]))
		code.append("\t; Emulation mode vectors\n")
		for name, comment in [("evec_cop", "COP"), ("evec_unused2", "unused"), ("evec_abort", "ABORT"),
				("evec_nmi", "NMI"), ("evec_reset", "RESET"), ("evec_irq", "IRQ/BRK")]:
			code.append("\t%s\t\t; %s\n" % (self.vector_operand(getattr(self.cart, name)), comment))

		f = open("%s/hdr.asm" % dir, 'w')
		f.write("".join(code))
		f.close()

	def byte_row(self, data):
		return ", ".join("$%02X" % x for x in data)

	def vector_operand(self, address):
		if address >= 0x8000 and self.disasm.valid_label(address - 0x8000) and not self.disasm.no_label:
			label = self.disasm.label_name(address - 0x8000)
			return ".byte %s@mos16lo, %s@mos16hi" % (label, label)
		else:
			return ".byte $%02X, $%02X" % (address & 0xFF, (address >> 8) & 0xFF)

	def create_link_script(self, dir):
		bank_size = self.cart.bank_size()
		banks = self.cart.bank_count()
		header_bank = self.cart.header // bank_size
		header_offset = self.cart.header % bank_size
		slot = 0x8000 if bank_size == 0x8000 else 0

		code = []
		code.append("/* llvm-mos linker script generated by snes2asm */\n")
		if self.cart.extended:
			code.append("/* WARNING: unsupported map type */\n")
		code.append("\n/* Zero valued symbol used by generated code to force operand widths */\n")
		code.append("__abs_base = 0;\n\n")
		code.append("SECTIONS\n{\n")
		for bank in range(0, banks):
			vma = (bank << 16) | slot
			lma = bank * bank_size
			if bank == header_bank:
				code.append("\t.bank%d 0x%06X : AT(0x%06X) { *(.bank%d) }\n" % (bank, vma, lma, bank))
				code.append("\t.hdr 0x%06X : AT(0x%06X) { *(.hdr) }\n" % (vma + header_offset, lma + header_offset))
			else:
				code.append("\t.bank%d 0x%06X : AT(0x%06X) { *(.bank%d) }\n" % (bank, vma, lma, bank))
		code.append("\n\t/DISCARD/ : { *(.comment) *(.note*) }\n")
		code.append("}\n")

		f = open("%s/link.ld" % dir, 'w')
		f.write("".join(code))
		f.close()

	def create_checksum_script(self, dir):
		shutil.copyfile("%s/snescsum.py" % template_path.__path__[0], "%s/snescsum.py" % dir)

class PercentTemplate(Template):
	delimiter = '%'
