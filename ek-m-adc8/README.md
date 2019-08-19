# Readme

## Программное обеспечение для отладочной платы АЦП8.  

## Список ресурсов

* /fpga

## /fpga

Проекты для FPGA

* /fpga/project_demo - демонстрационный проект FPGA   

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