/* Define memory regions. */
MEMORY

{
  rom (rx) : ORIGIN = 0x0800C000, LENGTH = 64K
  spare (rx) : ORIGIN = 0x0802c000, LENGTH = 80K      
  extra (rx) : ORIGIN = 0x08047000, LENGTH = 65K
  ram (rwx) : ORIGIN = 0x20003000, LENGTH = 64K
}

INCLUDE main.lds
