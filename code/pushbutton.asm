; source: http://www.instructables.com/id/Command-Line-Assembly-Language-Programming-for-Ard-1/

; Turns on an LED connected to PB0 (digital 8) when you
; push a button connected to PD0 (digital 0)

; PB0 (normally 0V) --> LED --> 220 Ohm --> 5V
; PD0 (normally 5V) --> button --> GND

.nolist
.include "../include/m328Pdef.inc"
.list

; Declarations

.def temp =r16  ; designate working register r16 as temp

; Start of program

RJMP Init

Init:
  SER temp ; set all bits in temp to 1
  OUT DDRB, temp ; set all PortB pins to output
  LDI temp, 0b11111110
  OUT DDRD, temp ; set PD0 to input, others output
  
  CLR temp
  OUT PortB, temp ; set all bits in PortB to 0v
  LDI temp, 0b00000001
  OUT PortD, temp ; set PD0 to 5V (pull-up), rest to 0V

; Main program body
Main:
  IN temp, PinD ; holds state of PortD. 0 pushed, 1 not (pull-up)
  OUT PortB, temp ; send to the LED at PortB
  RJMP Main ; and back to main
