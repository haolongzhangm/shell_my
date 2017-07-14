# Copyright (c) 2016 The Linux Foundation. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 and
# only version 2 as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

from parser_util import register_parser, RamParser
import linux_list as llist

VM_ALLOC = 0x00000002


@register_parser('--print-memstat', 'Print memory stats ')
class MemStats(RamParser):

    def list_func(self, vmlist):
        vm = self.ramdump.read_word(vmlist + self.vm_offset)
        if vm is None:
            return
        size = self.ramdump.read_structure_field(
                vm, 'struct vm_struct', 'size')
        flags = self.ramdump.read_structure_field(
                    vm, 'struct vm_struct', 'flags')
        if flags == VM_ALLOC:
            self.vmalloc_size = self.vmalloc_size + size

    def pages_to_mb(self, pages):
        val = 0
        if pages != 0:
            val = ((pages * 4) / 1024)
        return val

    def bytes_to_mb(self, bytes):
        val = 0
        if bytes != 0:
            val = (bytes / 1024) / 1024
        return val

    def calculate_vmalloc(self):
        next_offset = self.ramdump.field_offset('struct vmap_area', 'list')
        vmlist = self.ramdump.read_word('vmap_area_list')
        vm_offset = self.ramdump.field_offset('struct vmap_area', 'vm')
        self.vm_offset = vm_offset
        list_walker = llist.ListWalker(self.ramdump, vmlist, next_offset)
        list_walker.walk(vmlist, self.list_func)
        self.vmalloc_size = self.bytes_to_mb(self.vmalloc_size)

    def calculate_others(self):
        # Other memory :  NR_ANON_PAGES + NR_FILE_PAGES + NR_PAGETABLE \
        # + NR_KERNEL_STACK - NR_SWAPCACHE
        vmstat_anon_pages = self.ramdump.read_word(
                            'vm_stat[NR_ANON_PAGES]')
        vmstat_file_pages = self.ramdump.read_word(
                            'vm_stat[NR_FILE_PAGES]')
        vmstat_pagetbl = self.ramdump.read_word(
                                'vm_stat[NR_PAGETABLE]')
        vmstat_kernelstack = self.ramdump.read_word(
                                'vm_stat[NR_KERNEL_STACK]')
        vmstat_swapcache = self.ramdump.read_word(
                            'vm_stat[NR_SWAPCACHE]')
        other_mem = (vmstat_anon_pages + vmstat_file_pages + vmstat_pagetbl +
                     vmstat_kernelstack - vmstat_swapcache)
        other_mem = self.pages_to_mb(other_mem)
        return other_mem

    def calculate_ionmem(self):
        number_of_ion_heaps = self.ramdump.read_int('num_heaps')
        heap_addr = self.ramdump.read_word('heaps')
        offset_total_allocated = \
            self.ramdump.field_offset(
                'struct ion_heap', 'total_allocated')
        if self.ramdump.arm64:
            addressspace = 8
        else:
            addressspace = 4
        heap_addr_array = []
        grandtotal = 0
        for i in range(0, number_of_ion_heaps):
            heap_addr_array.append(heap_addr + i * addressspace)
            temp = self.ramdump.read_word(heap_addr_array[i])
            total_allocated = self.ramdump.read_int(
                                temp +
                                offset_total_allocated)
            if total_allocated is None:
                total_allocated = 0
                break
            grandtotal = grandtotal + total_allocated
        grandtotal = self.bytes_to_mb(grandtotal)
        return grandtotal

    def print_mem_stats(self, out_mem_stat):
        # Total memory
        total_mem = self.ramdump.read_word('totalram_pages')
        total_mem = self.pages_to_mb(total_mem)

        # Free Memory
        total_free = self.ramdump.read_word('vm_stat[NR_FREE_PAGES]')
        total_free = self.pages_to_mb(total_free)

        # slab Memory
        slab_rec = \
            self.ramdump.read_word('vm_stat[NR_SLAB_RECLAIMABLE]')
        slab_unrec = \
            self.ramdump.read_word('vm_stat[NR_SLAB_UNRECLAIMABLE]')
        total_slab = self.pages_to_mb(slab_rec + slab_unrec)

        # ion memory
        ion_mem = self.calculate_ionmem()

        # kgsl memory
        kgsl_memory = self.ramdump.read_word(
                        'kgsl_driver.stats.page_alloc')
        if kgsl_memory is not None:
            kgsl_memory = self.bytes_to_mb(kgsl_memory)
        else:
            kgsl_memory = 0

        # zcompressed ram
        zram_devices_word = self.ramdump.read_word('zram_devices')
        if zram_devices_word is not None:
            zram_devices_stat_offset = self.ramdump.field_offset(
                                        'struct zram', 'stats')
            stat_addr = zram_devices_word + zram_devices_stat_offset
            stat_val = self.ramdump.read_u64(stat_addr)
            stat_val = self.bytes_to_mb(stat_val)
        else:
            stat_val = 0

        self.out_mem_stat = out_mem_stat
        self.vmalloc_size = 0
        # vmalloc area
        self.calculate_vmalloc()

        # Others
        other_mem = self.calculate_others()

        # Output prints
        out_mem_stat.write('{0:30}: {1:8} MB'.format(
                                "Total RAM", total_mem))
        out_mem_stat.write('\n{0:30}: {1:8} MB\n'.format(
                            "Free memory:", total_free))
        out_mem_stat.write('\n{0:30}: {1:8} MB'.format(
                            "Total Slab memory:", total_slab))
        out_mem_stat.write('\n{0:30}: {1:8} MB'.format(
                            "Total ion memory:", ion_mem))
        out_mem_stat.write('\n{0:30}: {1:8} MB'.format(
                            "KGSL ", kgsl_memory))
        out_mem_stat.write('\n{0:30}: {1:8} MB'.format(
                            "ZRAM compressed  ", stat_val))
        out_mem_stat.write('\n{0:30}: {1:8} MB'.format(
                            "vmalloc  ", self.vmalloc_size))
        out_mem_stat.write('\n{0:30}: {1:8} MB'.format(
                            "Others  ", other_mem))

    def parse(self):
        with self.ramdump.open_file('mem_stat.txt') as out_mem_stat:
            if (self.ramdump.kernel_version < (3, 18, 0)):
                out_mem_stat.write('Kernel version 3.18 \
                and above are supported, current version {0}.\
                {1}'.format(self.ramdump.kernel_version[0],
                            self.ramdump.kernel_version[1]))
                return
            self.print_mem_stats(out_mem_stat)
