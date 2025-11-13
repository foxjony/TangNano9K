Arithmetic (from Shift Registers) Using the Tang Nano 9K FPGA Board
https://www.youtube.com/watch?v=qTdrYL4ayPM

https://github.com/grughuhler/grug_misc_projects/tree/main/tang_nano_mac_fpga/c

Цей каталог містить те, що було зібрано та протестовано на Raspberry Pi
(але має працювати на інших Raspberry Pi).

Є дві програми:

Один для 2-провідної версії проекту: mac_command
і один для 1-провідної (двонаправленої) версії: mac_command1.

Ці програми використовують бібліотеку pigpio, тому

   ### sudo apt install libpigpio-dev   (На RPI Zero не працює!)
   або
   ### sudo apt install pigpio
   ### gcc -o mac_command mac_command.c -lpigpio -lrt
   ### ./mac_command

Commands:
  reset     : Sets all registers (a, b, and c) to zero
  write a b : Write decimal values a and b to registers a and b
  sum       : Do the c = c + a*b operation
  read      : read the value of c
  quit      : exit this program
  help      : show this help

mac_command1 використовує один двонаправлений сигнал, 
тоді як mac_command використовує два однонаправлених сигнали. 
Вони використовують дещо різні контакти, тому зверніть увагу на
те і обов’язково використовуйте правильну програму.

Запустіть від імені root, наприклад, sudo ./mac_command

Введіть «help», щоб переглянути список команд.

Тестувався на Raspbian 10 та 12.

Будьте обережні, щоб Raspberry Pi та FPGA не були налаштовані так
виходи одночасно. Це може пошкодити обладнання.

Для mac_command1 я протестував сигнал iop, підключений між
Raspberry Pi та Tang Nano 9K через резистор 1 кОм. Це працює і
може забезпечити захист, коли обидва виходи є результатом помилки. 
Але, все ж, уникайте конфлікту виходів. Використання резистора є параноя.

|        | FPGA | RPI  | Color  |
|--------|------|------|--------|
| cmd[0] |  42  |  16  | Blue   |
| cmd[1] |  41  |  20  | Green  |
| clk    |  35  |  21  | Yelow  |
| din    |  40  |  26  | Orange |
| dout   |  34  |  19  | White  |

