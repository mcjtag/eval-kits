# Readme

## Программное обеспечение для отладочной платы ОАС x2.

## Список ресурсов

* /docs
* /dsp
* /fpga
* /firmware

## /docs
Документация на отладочную плату

* /docs/ek-m-oas2_ug.pdf - руководство

## /dsp

Проекты для DSP

* /dsp/demo_1 - демонстрационный проект DSP

## /fpga

Проекты для FPGA

* /fpga/project_demo - демонстрационный проект FPGA

## /firmware

* /firmware/demo_1/fpga_demo_1.bit
* /firmware/demo_1/fpga_demo_1.mcs
* /firmware/demo_1/dsp_demo_1.ldr

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
* Выбрать микросхему памяти: `mt25ql256-spi-x1_x2_x4`;
* В поле 'Configuration file' задать путь для файла конфигурации;
* Нажать 'OK' и дождаться окончания программирования;

#### DSP
Для программирования памяти микросборок необходимо использовать: VisualDSP++ 5.0.
Файл загрузки: `/firmware/demo_x/dsp_demo_x.ldr` (где `x` - номер демо-программы).
* Запустить VisualDSP++ 5.0;
* Создать сессию (если нет подходящей):
    * Выбрать 'Session' -> 'New Session...';
    * Указать в 'Processor family': `TigerSHARC`;
    * В 'Choose a target processor' выбрать: `ADSP-TS201`;
    * Нажать 'Next';
    * Выбрать `Emulator` и нажать 'Next';
    * Задать имя сессии в 'Session name';
    * Нажать 'Configurator...' и создать при необходимости конфигурацию:
        * Нажать 'New...' и задать имя в поле 'Name';
        * Выбрать тип отладчика в поле 'Type';
        * Задать 'Device ID' = `0` и 'JTAG I/O Voltage' = `3.3/5`;
        * Очистить поле 'Devices' и добавить два устройства нажатием кнопки 'New...':
            * Задать имя по необходимости в поле 'Name';
            * Выбрать в 'Type': `ADSP-TS201`;
            * Выбрать пункт `'Do not disturb'` в поле 'Initial connection options' и нажать 'OK';
        * Нажать 'OK';
        * Нажать 'OK';
    * Выбрать конфигурацию и нажать 'Next';
    * Нажать 'Finish';
* Выбрать подходящую сессию: 'Session' -> 'Select Session'.
* После подключения к устройству выполнить останов (`Halt`) процессоров;
* Запустить 'Tools' -> 'Flash Programmer...';
* В поле 'Driver file' выбрать драйвер `flash_driver/prebuilt/fd_oas_rr4.dxe` в проекте 'eval-kits';
* Во вкладке 'Driver' загрузить драйвер нажатием кнопки 'Load Driver';
* Перейти во вкладку 'Programming';
* Выбрать `'Erase all'` в поле 'Pre-program erase options';
* В поле 'File format' выбрать `Binary`;
* В поле 'Data file' выбрать файл загрузки;
* Включить пункт `'Verify while programming'`;
* Нажать на кнопку 'Program' и дождать окончания загрузки;
* Повторить процедуру загрузки для второго процессора;

#### Примечание
Программирование памяти лучше всего производить в последовательности: DSP -> FPGA.
Так как при сконфигурированной FPGA возможны проблемы при программировании памяти DSP.
Если FPGA запрограммирована и есть проблемы при программировании памяти DSP, то необходимо выполнять программирование
памяти DSP при 'выключенной' FPGA (отсутствует конфигурация или нажата кнопка '`FPGA RESET`')
