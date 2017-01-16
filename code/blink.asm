
;Get an LED blinking on the ATmega328 (Arduino)
;On Arduino, pin 13 has an on-board LED which blinks. Pin 13 should map to PB5 (SCK/PCINT5) on the MCU.
 
.include "../include/m328Pdef.inc"

.ORG   0x0000                   ; Tells the next instruction to be written
 RJMP   main                    ; State that the program begins at the main label

main:
 LDI    r16, 0xFF               ; Load the immedate value 0xFF (all bits 1) into register 16
 OUT    DDRB, r16               ; Set Data Direction Register B to output for all pins

loop:
 SBI    PortB, 5                ; Set the 5th bit in PortB. (i.e. turn on the LED)
 RCALL  delay_05
 CBI    PortB, 5                ; Clear the 5th bit in PortB. (i.e. turn off the LED)
 RCALL  delay_05
 RJMP   loop                    ; Loop again

; Everything beneath is part of the delay loop
delay_05:
 LDI    r16, 8

outer_loop:
 LDI    r24, low(3037)
 LDI    r25, high(3037)

delay_loop:
 ADIW   r24, 1
 BRNE   delay_loop
 DEC    r16
 BRNE   outer_loop
 RET