/* Define memory regions. */
MEMORY

{
  rom (rx) : ORIGIN = 0x0800C000, LENGTH = 64K
  spare (rx) : ORIGIN = 0x0802c000, LENGTH = 80K      
  extra (rx) : ORIGIN = 0x08047000, LENGTH = 65K
  /* total RAM 64kb, starts from 0x20000000;
     minus SYS memory 8kb in the beginning
     (actually less but original APP reserves 8kb);
     minus possible AlterBIOS memory 5kb in the end
     (original app reserves everything from 0x2000abe0);
     total = 51kb */
  ram (rwx) : ORIGIN = 0x20002000, LENGTH = 51K
}

INCLUDE main.lds
