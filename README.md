# Assembly with Arduino

Programming on the Arduino using the [library functions](https://www.arduino.cc/en/Reference/HomePage) is quick and fun. However, they abstract away a lot of the interesting details of the underlying hardware. If you want to get a better understanding of how your microcontroller works then assembly is the way to go!

# Uploading code

If you are writing in assembly then you cannot upload code via the Arduino IDE. However, we can use the same tools as the IDE uses under the hood.

In the 'code' directory is an example assembly file, `blink.asm`. As the name suggests, it makes the built-in LED blink. The following steps will explain how to upload it to an Arduino (using my Elegoo Uno R3 clone as an example.)

## Tools

The standard file extension for assembly is `.asm`. The microcontroller cannot understand the text file so we need an 'assembler' to generate a series of hexadecimal codes that the processor can understand. Once we have this `.hex` file, we need to upload it to the Arduino.

The assembler we will use is [Avra](http://avra.sourceforge.net/). To upload the hex files we'll use [avrdude](http://www.nongnu.org/avrdude/).

If you have Homebrew installed you can just do:

`brew install avra avrdude`

## Assembling

You will need to have the correct include file for your microcontroller. My Arduino uses the ATmega328, so I have a `.inc` file for it in the 'include' directory (thanks to [this tutorial](http://www.instructables.com/id/Command-Line-Assembly-Language-Programming-for-Ard/) for the file). If you have a different microcontroller in your Arduino you'll need to find the correct include file (there are many in the Avra source directory).

Once you have the correct include file in the correct path, assembling the program is simple:

`avra blink.asm`

This will generate `.cof`, `.eep.hex` and `.hex` files. We are interested in the `.hex`.

## Uploading

To upload the hex file we'll use avrdude, which is also what the Arduino IDE uses.

The trick is to find the correct parameters for the command. They will depend on the particular details of your board and how it's connected. The easiest way to find the correct command is to enable 'Show verbose output during upload' in the Arduino IDE preferences. If you upload a simple sketch (in standard Arduino C/C++) you will see the output in the black box at the bottom of the sketch window.

For example, on my machine and with my Elegoo Uno R3 the output is as follows:

```
avrdude -C/Applications/Arduino.app/Contents/Java/hardware/tools/avr/etc/avrdude.conf -v -patmega328p -carduino -P/dev/cu.usbmodem1421 -b115200 -D -Uflash:w:hello.hex:i
```

Don't copy and paste this command as it will probably be different for your setup.

Once you have an example of the correct command all you need to do is change the name of the hex file at the end. If you've previously assembled `blink.asm` then you should be able to change the pathname of the final flag option (so in my case `-Uflash:w:hello.hex:i` becomes `-Uflash:w:blink.hex:i`). Hit enter.

Ecce lux! [Gone, back, gone, back](https://www.youtube.com/watch?v=k3c2UcB1zQo).

## Scripting

Obviously this command is painful to write out each time. You can find it in your shell history by pressing the up arrow or `Ctrl+R`, but this is fragile. Scripting is the answer.

The file `arduino` in this repo provides a very small script to execute the upload command. Replace the variables (and parameters if necessary) so that they match what the Arduino IDE generated for you (e.g. the PORT and BAUD variables might need changed).

Then make the file executable (`chmod a+x arduino`) and put it somewhere in your [path](https://en.wikipedia.org/wiki/PATH_(variable)) (`sudo cp arduino /usr/local/bin`). Now you can upload a file from anywhere in your computer just by writing:

`arduino path/to/file.hex`

Feel free to rename it if you don't like 'arduino'. The script uses your current working directory so the path should be relative to the directory you are executing the command from.

For example, if the hex file is in the same directory you can just execute:

`arduino blink.hex`

If it's in a sub-directory you can do the following:

`arduino code/blink.hex`

And so on.

# Resources

The below is a collection of useful resources that I have come across. As they're for things I'm doing they'll be focused on the components inside the Elegoo Uno R3.

[AVR Assembler tutorials](http://www.instructables.com/id/Command-Line-AVR-Tutorials/)

[Introduction to AVR assembler (PDF)](http://www.avr-asm-download.de/beginner_en.pdf)

[Datasheet and information on the Atmel ATmega328p](http://www.atmel.com/devices/ATMEGA328P.aspx)
