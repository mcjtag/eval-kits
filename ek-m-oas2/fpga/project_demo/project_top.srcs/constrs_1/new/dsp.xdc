##
## DSP Constraints
## 

## Reset
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports dsp_reset_all]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports dsp_reset[0]]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports dsp_reset[1]]

## DMAR
set_property -dict {PACKAGE_PIN V22  IOSTANDARD LVCMOS33} [get_ports dsp_dmar0[0]]
set_property -dict {PACKAGE_PIN P21  IOSTANDARD LVCMOS33} [get_ports dsp_dmar0[1]]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports dsp_dmar1[0]]
set_property -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS33} [get_ports dsp_dmar1[1]]

## IRQ
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33} [get_ports dsp_irq0[0]]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports dsp_irq0[1]]
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports dsp_irq1[0]]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports dsp_irq1[1]]

## BOOT/HOST
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33 PULLDOWN TRUE} [get_ports dsp0_boot[0]]
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports dsp0_boot[1]]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 PULLDOWN TRUE} [get_ports dsp0_boot[2]]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33 PULLDOWN TRUE} [get_ports dsp1_boot[0]]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports dsp1_boot[1]]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33 PULLDOWN TRUE} [get_ports dsp1_boot[2]]

## SPI
#set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports dsp0_spi_mosi]
#set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports dsp0_spi_miso]
#set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports dsp0_spi_cs]
#set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports dsp0_spi_sck]

#set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports dsp1_spi_mosi]
#set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports dsp1_spi_miso]
#set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports dsp1_spi_cs]
#set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33} [get_ports dsp1_spi_sck]

## COH Control
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports dsp_coh_a[0]]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports dsp_coh_a[1]]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports dsp_coh_b[0]]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports dsp_coh_b[1]]

## UART
#set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports dsp0_uart_tx]
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports dsp0_uart_rx]

#set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports dsp1_uart_tx]
#set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports dsp1_uart_rx]

## SSI
#set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports dsp0_ssi_clk]
#set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports dsp1_ssi_clk]

## TMR
#set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports dsp0_tmr_tclk]
#set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports dsp1_tmr_tclk]
