********************************************************************
* cocosdc.d - CoCo SDC definitions
*
* Edt/Rev  YYYY/MM/DD  Modified by
* Comment
* ------------------------------------------------------------------
*          2014/05/02  Boisy G. Pitre
* Created
*          2014/12/22  Darren Atkinson
* Additional hardware symbols

                    IFNE      COCOSDC.D-1
COCOSDC.D           SET       1


* CoCoSDC hardware addresses depend on the selected bus scheme. The
* Dragon scheme moves the command/parameter registers to $FF40-$FF43 and
* the control latch to $FF48. The LBA command protocol is otherwise the same.
                    ifne      d64
SDAddr              SET       $FF42
CTRLATCH            equ       $FF48               controller latch (write)
CMDREG              equ       $FF40               command register (write)
STATREG             equ       $FF40               status register (read)
PREG1               equ       $FF41               param register 1
PREG2               equ       $FF42               param register 2
PREG3               equ       $FF43               param register 3
DATREGA             equ       PREG2
DATREGB             equ       PREG3
FLSHDAT             equ       $FF4A               flash data register
FLSHCTL             equ       $FF4B               flash control register
                    else
* Main Port Address (V.PORT)
SDAddr              SET       $FF4A
CTRLATCH            equ       $FF40               controller latch (write)
CMDREG              equ       $FF48               command register (write)
STATREG             equ       $FF48               status register (read)
PREG1               equ       $FF49               param register 1
PREG2               equ       $FF4A               param register 2
PREG3               equ       $FF4B               param register 3
DATREGA             equ       PREG2               first data register
DATREGB             equ       PREG3               second data register
FLSHDAT             equ       $FF42               flash data register
FLSHCTL             equ       $FF43               flash control register
                    endc

* Status Register Masks
BUSY                equ       %00000001           set while a command is executing
READY               equ       %00000010           set when ready for a data transfer
FAILED              equ       %10000000           set on command failure

* Command and Mode Values
CMDMODE             equ       $43                 control latch value to enable command mode
CMDREAD             equ       $80                 read logical sector
CMDWRITE            equ       $A0                 write logical sector
CMDEX               equ       $C0                 extended command
CMDEXD              equ       $E0                 extended command with data block


                    ENDC
