### TRNG on FPGA Tang Nano 9K (VSCode IDE).

True random number generator (32 bits). It is based on high-frequency oscillations using inverters and other methods to improve randomness. Every time the power is turned on, we get a random first number. In this mode of operation, the simulation does not work. Therefore, for debugging, the output of numbers to the USB UART 115200 Baud with a frequency of 1 kHz and 3 signals to the pins (36, 37, 38) for the logic analyzer were added to the project.

![Start 1](https://github.com/foxjony/TangNano9K/blob/main/TANG_NANO_9K/p7_trng/IMG/trng_1.png)

![Start 2](https://github.com/foxjony/TangNano9K/blob/main/TANG_NANO_9K/p7_trng/IMG/trng_2.png)
