;hello.asm
; turns on LED connected to PB5 (pin 13)

.include "../include/m328Pdef.inc"

  ldi r16,0b00100000
  out DDRB,r16
  out PortB,r16
Start:
  rjmp Start