# Aquitectura de Computadoras-Projects

[![Build Status](https://travis-ci.org/nickhammond/ansible-logrotate.svg?branch=master)](https://travis-ci.org/nickhammond/ansible-logrotate)

* Version 1.1

## 2018-2019

###  Aplicacion  ###

 * ALU
 * UART
 * BIPS
 * MIPS

## Getting Started

Estas instrucciones seran para que usted copie el proyecto y lo corra en su maquina local
para propositos de desarrollo y testing . 

## MIPS final
Este trabajo fue presentado al Profesor Pereyra, reemplazate de Rodriguez en 
Arquitectura de computadoras
### Prerequisitos
 * `Vivado-2018.3+` 
 * `Python3`
   - `pyserial`
   - `tkinter`
   - `pysimplegui` 
### Funcionamiento
#### En vivado Cargar:
 1 En `mips_final/src` Cargar contenido carpeta `mips` , `spi`  
 2 En `mips_final/src` Cargar `Debugger_interface.v` de `./debugger_unit/`
 3 En `mips_final/src` Cargar MicroBlaze, archivo ´ /microblaze/design_1/design_1.bd´ 
 4 Generar Binario, Exportar Harware File->Export->Export Hardware. marcar include bitstream
 5 Lanzar SDK
#### En SDK
 1 Crear App nueva usando microblaze
 2 Copiar archivos de `mips_final/src/debugger_unit/firmware/`
 3 Compilar y Run as debug
#### Interfaz Grafica
 1 Ejecutar `./mips_final/client/gui/client-gui`
 2 Binpath  `/mips_final/client/bin`
 3 Serial 115200 Bd
#### Compilar Programa
 1 `/mips_final/compiler.py file`
 2 Write program en interfaz grafica `/mips_final/out.bin`  
#### Reset
 1 MIPS reset `sw[1]` en `mips_final/src/Top_rtl.v` 
 2 MicroBlaze reset `sw[0]` en `mips_final/src/Top_rtl.v`

## Built With
 * `Vivado-2018.3+` 
 * `SDK-2018.3+` 
## Authors
* **Martin Barrera** - *Initial work* - [iotincho](https://github.com/iotincho)
* **Sergio Sulca** - *Initial work* - [ser0090](https://github.com/ser0090)
## License
**GNU General Public License v3.0**
## Notes
exportar Block Desing [here](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2017_3/ug994-vivado-ip-subsystems.pdf)
