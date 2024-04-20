/*
Copyright 2018 ETH Zurich and University of Bologna.
Copyright and related rights are licensed under the Solderpad Hardware
License, Version 0.51 (the "License"); you may not use this file except in
compliance with the License.  You may obtain a copy of the License at
http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
or agreed to in writing, software, hardware and materials distributed under
this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

Author: Hossein Askari <m.h.askari.hemmat@gmail.com>, Polytechnique Montreal
Date: 06.03.2023
Description: Basic linker script for bare metal programs running on Polara
(copy and modified from Ariane linker script for openpiton).
*/

OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x80000000;

  /* text: test code section */
  .text.init : {
    *(.text.init)
  }

  .text : {
    *(.text)
  }

  /* data segment */
  .data : ALIGN(16) {
    *(.data)
  }

  .rodata  : ALIGN(16) { 
    *(.rodata .rodata.* .gnu.linkonce.r.*) 
    } 
  
  .sdata : ALIGN(16) {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  }

  /* bss segment */
  .sbss : ALIGN(16) {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)_
  }

  .bss : ALIGN(16) {
    *(.bss)
  }

  /* thread-local data segment */
  .tdata : ALIGN(16) {
    _tls_data = .;
    *(.tdata.begin)
    *(.tdata)
    *(.tdata.end)
  }

  .tbss : ALIGN(16) {
    *(.tbss)
    *(.tbss.end)
  }

  /* timer definition section */
  .timer : ALIGN(16) {
    timer = .;
    . = . + 0x8;
  }

  /* End of uninitalized data segement */
  _end : {
    _end = .;
  }
}

