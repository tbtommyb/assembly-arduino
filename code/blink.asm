; http://www.instructables.com/id/Command-Line-Assembly-Language-Programming-for-Ard-2/

; blinks an LED every second

; PD4 --> LED --> R(220 ohm) --> GND

.NOLIST
.INCLUDE "../include/m328Pdef.inc"
.LIST

; Declarations

.DEF temp = r16
.DEF overflows = r17

.ORG 0x0000 ; memory (PC) location of reset handler
RJMP Reset
.ORG 0x0020 ; memory location of Timer0 overflow handler
RJMP overflow_handler ; go here if a Timer0 overflow happens

Reset:
  LDI temp, 0b00000101
  OUT TCCR0B, temp ; set Clock Selector bits CS00, CS01, CS02 to 101
  LDI temp, 0b00000001
  STS TIMSK0, temp ; set Timer Overflow Interrupt Enable
  SEI ; enable global interrupts
  CLR temp
  OUT TCNT0, temp ; initialise timer/counter to 0
  SBI DDRD, 4 ; set PD4 to output

; Main body

blink:
  SBI PORTD, 4 ; turn on LED on PD4
  RCALL delay ; wait a half second
  CBI PORTD, 4 ; turn off LED on PD4
  RCALL delay ; wait a half second
  RJMP blink ; repeat

delay:
  CLR overflows
  sec_count:
    CPI overflows, 30 ; compare number of overflows to 30
  BRNE sec_count ; go back to sec_count if not equal
  RET ; matches 30, return to overflow

overflow_handler:
  INC overflows ; increment
  CPI overflows, 61 ; compare to 61
  BRNE PC+2 ; if not equal skip next line
  CLR overflows ; reset to zero if 61 have occurred
  RETI ; return from interrupt