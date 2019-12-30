# Readme

Программное обеспечение для отладочной платы АЦП8 (Rev. 1)  

## Список ресурсов

* /fpga
* /docs (release)
* /firmware (release)

## /fpga

Проекты для FPGA

* /fpga/project_demo - демонстрационный проект FPGA   

## /docs (release)

* /docs/ek-m-adc8_ug.pdf - краткое руководство

## /firmware (release)

* /firmware/demo_1/fpga_demo_1.bit
* /firmware/demo_1/fpga_demo_1.mcs

### Требования
* Vivado версии не ниже 2018.3

### Сборка
Для инициализации проекта необходимо:
* Запустить Vivado IDE
* В начальном окне выбрать Tcl-консоль
* Перейти в текущую папку проекта: `cd [path_to_project]`
* Выполнить tcl-скрипт: `source ./[project_name].tcl`

Для корректной работы 'microblaze' нужно:
* Выполнить все стадии сборки: synthesis, implementation, bitstream generation
* Выполнить экспорт в SDK: File > Export > Export Hardware... > (Отметить Include bitsream) > Ok
* Запустить SDK: File > Launch SDK
* В SDK выполнить: File > New > Board Support Package... > (Project name = bsp_standalone) > Finish
* После завершения сборки BSP импортировать проект приложения 'microblaze': File > Open Project from File System...
* Выбрать необходимый проект и дождаться окончания сборки
* Связать microblaze и приложение: 'Tools'->'Associate ELF Files...'
* Выбрать собранное приложение с расширением '.elf' в 'Design Sources' и нажать Ok
* Повторить процедуру bitstream generation

### Программирование

#### FPGA
Для программирования flash-памяти необходимо использовать: Vivado Lab (>=2018.3).
Файл конфигурации: `/firmware/demo_x/fpga_demo_x.mcs` (где `x` - номер демо-программы).
* Запустить 'Vivado Lab';
* Выбрать 'Open Hardware Manager';
* Выбрать 'Open target' -> 'Auto Connect';
* Выполнить 'Tools' -> 'Add Configuration Memory Device' -> 'xc7a200t_x';
* Выбрать микросхему памяти: `s25fl512s-spi-x1_x2_x4`;
* В поле 'Configuration file' задать путь для файла конфигурации;
* Нажать 'OK' и дождаться окончания программирования;
