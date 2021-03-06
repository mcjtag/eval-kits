#
# DSP Constraints
#

# Bus Frequency Divider
set_property -dict {PACKAGE_PIN U25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports bus_freq_div[0]]
set_property -dict {PACKAGE_PIN T24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports bus_freq_div[1]]

# Reset
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12 PULLUP true} [get_ports dsp_reset_tri_io[0]]
#set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports dsp_reset_out]

## DSP Core Frequency Switch
set_property -dict {PACKAGE_PIN AE23 IOSTANDARD SSTL135} [get_ports dsp_core_freq_tri_i[0]]
set_property -dict {PACKAGE_PIN AD23 IOSTANDARD SSTL135} [get_ports dsp_core_freq_tri_i[1]]

## DSP Bus Freq
set_property -dict {PACKAGE_PIN AH34 IOSTANDARD SSTL135} [get_ports dsp_bus_freq_tri_i[0]]
set_property -dict {PACKAGE_PIN AH33 IOSTANDARD SSTL135} [get_ports dsp_bus_freq_tri_i[1]]

## DSP IRQ
#set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports dsp0_irq[0]]
#set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports dsp0_irq[1]]
#set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports dsp0_irq[2]]
#set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports dsp0_irq[3]]

#set_property -dict {PACKAGE_PIN AF5 IOSTANDARD LVCMOS33} [get_ports dsp1_irq[0]]
#set_property -dict {PACKAGE_PIN AG5 IOSTANDARD LVCMOS33} [get_ports dsp1_irq[1]]
#set_property -dict {PACKAGE_PIN Y6  IOSTANDARD LVCMOS33} [get_ports dsp1_irq[2]]
#set_property -dict {PACKAGE_PIN AE6 IOSTANDARD LVCMOS33} [get_ports dsp1_irq[3]]

#set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS33} [get_ports dsp2_irq[0]]
#set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33} [get_ports dsp2_irq[1]]
#set_property -dict {PACKAGE_PIN AF9  IOSTANDARD LVCMOS33} [get_ports dsp2_irq[2]]
#set_property -dict {PACKAGE_PIN AE8  IOSTANDARD LVCMOS33} [get_ports dsp2_irq[3]]

#set_property -dict {PACKAGE_PIN W10  IOSTANDARD LVCMOS33} [get_ports dsp3_irq[0]]
#set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS33} [get_ports dsp3_irq[1]]
#set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports dsp3_irq[2]]
#set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS33} [get_ports dsp3_irq[3]]

### DSP FLAG
#set_property -dict {PACKAGE_PIN G5 IOSTANDARD LVCMOS33} [get_ports dsp0_flag[0]]
#set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports dsp0_flag[1]]
#set_property -dict {PACKAGE_PIN H9 IOSTANDARD LVCMOS33} [get_ports dsp0_flag[2]]
#set_property -dict {PACKAGE_PIN H8 IOSTANDARD LVCMOS33} [get_ports dsp0_flag[3]]

#set_property -dict {PACKAGE_PIN AH4 IOSTANDARD LVCMOS33} [get_ports dsp1_flag[0]]
#set_property -dict {PACKAGE_PIN AH3 IOSTANDARD LVCMOS33} [get_ports dsp1_flag[1]]
#set_property -dict {PACKAGE_PIN AJ4 IOSTANDARD LVCMOS33} [get_ports dsp1_flag[2]]
#set_property -dict {PACKAGE_PIN AJ3 IOSTANDARD LVCMOS33} [get_ports dsp1_flag[3]]

#set_property -dict {PACKAGE_PIN AH7 IOSTANDARD LVCMOS33} [get_ports dsp2_flag[0]]
#set_property -dict {PACKAGE_PIN AH9 IOSTANDARD LVCMOS33} [get_ports dsp2_flag[1]]
#set_property -dict {PACKAGE_PIN AG6 IOSTANDARD LVCMOS33} [get_ports dsp2_flag[2]]
#set_property -dict {PACKAGE_PIN AH6 IOSTANDARD LVCMOS33} [get_ports dsp2_flag[3]]

#set_property -dict {PACKAGE_PIN AE11 IOSTANDARD LVCMOS33} [get_ports dsp3_flag[0]]
#set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS33} [get_ports dsp3_flag[1]]
#set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVCMOS33} [get_ports dsp3_flag[2]]
#set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS33} [get_ports dsp3_flag[3]]

### DSP DMAR
#set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports dsp0_dmar[0]]
#set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports dsp0_dmar[1]]
#set_property -dict {PACKAGE_PIN G7 IOSTANDARD LVCMOS33} [get_ports dsp0_dmar[2]]
#set_property -dict {PACKAGE_PIN G9 IOSTANDARD LVCMOS33} [get_ports dsp0_dmar[3]]

#set_property -dict {PACKAGE_PIN AD6 IOSTANDARD LVCMOS33} [get_ports dsp1_dmar[0]]
#set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVCMOS33} [get_ports dsp1_dmar[1]]
#set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports dsp1_dmar[2]]
#set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS33} [get_ports dsp1_dmar[3]]

#set_property -dict {PACKAGE_PIN AH8  IOSTANDARD LVCMOS33} [get_ports dsp2_dmar[0]]
#set_property -dict {PACKAGE_PIN AG9  IOSTANDARD LVCMOS33} [get_ports dsp2_dmar[1]]
#set_property -dict {PACKAGE_PIN AC9  IOSTANDARD LVCMOS33} [get_ports dsp2_dmar[2]]
#set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS33} [get_ports dsp2_dmar[3]]

#set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33} [get_ports dsp3_dmar[0]]
#set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS33} [get_ports dsp3_dmar[1]]
#set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS33} [get_ports dsp3_dmar[2]]
#set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS33} [get_ports dsp3_dmar[3]]

## DSP Temp Sensors
set_property -dict {PACKAGE_PIN AA25 IOSTANDARD LVCMOS33} [get_ports dsp_temp_scl_io]
set_property -dict {PACKAGE_PIN AA24 IOSTANDARD LVCMOS33} [get_ports dsp_temp_sda_io]

## DSP Voltage ADCs
set_property -dict {PACKAGE_PIN R27 IOSTANDARD LVCMOS33} [get_ports dsp_vadc_spi_sck_io]
set_property -dict {PACKAGE_PIN U24 IOSTANDARD LVCMOS33} [get_ports dsp_vadc_spi_io0_io] ; # MOSI (Dummy)
set_property -dict {PACKAGE_PIN R26 IOSTANDARD LVCMOS33} [get_ports dsp_vadc_spi_io1_io] ; # MISO
set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports dsp_vadc_spi_ss_io[0]] ; # VDD
set_property -dict {PACKAGE_PIN T27 IOSTANDARD LVCMOS33} [get_ports dsp_vadc_spi_ss_io[1]] ; # VDD3V
set_property -dict {PACKAGE_PIN P28 IOSTANDARD LVCMOS33} [get_ports dsp_vadc_spi_ss_io[2]] ; # VDDIO

## DSP Cluster Bus
#set_property -dict {PACKAGE_PIN AJ1 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[0]]
#set_property -dict {PACKAGE_PIN AH2 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[1]]
#set_property -dict {PACKAGE_PIN AE5 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[2]]
#set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[3]]
#set_property -dict {PACKAGE_PIN AD3 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[4]]
#set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[5]]
#set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[6]]
#set_property -dict {PACKAGE_PIN AG2 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[7]]
#set_property -dict {PACKAGE_PIN Y3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[8]]
#set_property -dict {PACKAGE_PIN AA3 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[9]]
#set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[10]]
#set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[11]]
#set_property -dict {PACKAGE_PIN AC3 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[12]]
#set_property -dict {PACKAGE_PIN AE3 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[13]]
#set_property -dict {PACKAGE_PIN AF2 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[14]]
#set_property -dict {PACKAGE_PIN AF3 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[15]]
#set_property -dict {PACKAGE_PIN Y1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[16]]
#set_property -dict {PACKAGE_PIN W1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[17]]
#set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[18]]
#set_property -dict {PACKAGE_PIN V1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[19]]
#set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[20]]
#set_property -dict {PACKAGE_PIN W4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[21]]
#set_property -dict {PACKAGE_PIN W5  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[22]]
#set_property -dict {PACKAGE_PIN V7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[23]]
#set_property -dict {PACKAGE_PIN U2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[24]]
#set_property -dict {PACKAGE_PIN U7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[25]]
#set_property -dict {PACKAGE_PIN U1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[26]]
#set_property -dict {PACKAGE_PIN Y5  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[27]]
#set_property -dict {PACKAGE_PIN V3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[28]]
#set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[29]]
#set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[30]]
#set_property -dict {PACKAGE_PIN AD5 IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[31]]
#set_property -dict {PACKAGE_PIN P1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[32]]
#set_property -dict {PACKAGE_PIN N1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[33]]
#set_property -dict {PACKAGE_PIN M6  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[34]]
#set_property -dict {PACKAGE_PIN M7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[35]]
#set_property -dict {PACKAGE_PIN K7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[36]]
#set_property -dict {PACKAGE_PIN R5  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[37]]
#set_property -dict {PACKAGE_PIN N2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[38]]
#set_property -dict {PACKAGE_PIN M1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[39]]
#set_property -dict {PACKAGE_PIN N4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[40]]
#set_property -dict {PACKAGE_PIN P5  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[41]]
#set_property -dict {PACKAGE_PIN P4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[42]]
#set_property -dict {PACKAGE_PIN T4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[43]]
#set_property -dict {PACKAGE_PIN U5  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[44]]
#set_property -dict {PACKAGE_PIN U6  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[45]]
#set_property -dict {PACKAGE_PIN R2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[46]]
#set_property -dict {PACKAGE_PIN R1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[47]]
#set_property -dict {PACKAGE_PIN H1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[48]]
#set_property -dict {PACKAGE_PIN H2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[49]]
#set_property -dict {PACKAGE_PIN G1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[50]]
#set_property -dict {PACKAGE_PIN G2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[51]]
#set_property -dict {PACKAGE_PIN T2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[52]]
#set_property -dict {PACKAGE_PIN R3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[53]]
#set_property -dict {PACKAGE_PIN P3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[54]]
#set_property -dict {PACKAGE_PIN N3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[55]]
#set_property -dict {PACKAGE_PIN L3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[56]]
#set_property -dict {PACKAGE_PIN L2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[57]]
#set_property -dict {PACKAGE_PIN M4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[58]]
#set_property -dict {PACKAGE_PIN T3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[59]]
#set_property -dict {PACKAGE_PIN U4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[60]]
#set_property -dict {PACKAGE_PIN V4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[61]]
#set_property -dict {PACKAGE_PIN V6  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[62]]
#set_property -dict {PACKAGE_PIN W3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_data[63]]

#set_property -dict {PACKAGE_PIN AG4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[0]]
#set_property -dict {PACKAGE_PIN AB2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[1]]
#set_property -dict {PACKAGE_PIN AB1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[2]]
#set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[3]]
#set_property -dict {PACKAGE_PIN M5   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[4]]
#set_property -dict {PACKAGE_PIN J6   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[5]]
#set_property -dict {PACKAGE_PIN K5   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[6]]
#set_property -dict {PACKAGE_PIN AF4  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[7]]
#set_property -dict {PACKAGE_PIN J4   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[8]]
#set_property -dict {PACKAGE_PIN L5   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[9]]
#set_property -dict {PACKAGE_PIN AD9  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[10]]
#set_property -dict {PACKAGE_PIN J1   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr_10]
#set_property -dict {PACKAGE_PIN W6   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[11]]
#set_property -dict {PACKAGE_PIN K2   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[12]]
#set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[13]]
#set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[14]]
#set_property -dict {PACKAGE_PIN V8   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[15]]
#set_property -dict {PACKAGE_PIN W8   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[16]]
#set_property -dict {PACKAGE_PIN AB7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[17]]
#set_property -dict {PACKAGE_PIN H6   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[18]]
#set_property -dict {PACKAGE_PIN R8   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[19]]
#set_property -dict {PACKAGE_PIN Y8   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[20]]
#set_property -dict {PACKAGE_PIN Y7   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[21]]
#set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[22]]
#set_property -dict {PACKAGE_PIN T9   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[23]]
#set_property -dict {PACKAGE_PIN AD8  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[24]]
#set_property -dict {PACKAGE_PIN AF7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[25]]
#set_property -dict {PACKAGE_PIN AE7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[26]]
#set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[27]]
#set_property -dict {PACKAGE_PIN AG7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[28]]
#set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[29]]
#set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[30]]
#set_property -dict {PACKAGE_PIN U10  IOSTANDARD LVCMOS33} [get_ports dsp_cb_addr[31]]

#set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_mssd[0]]
#set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports dsp_cb_mssd[1]]
#set_property -dict {PACKAGE_PIN T10  IOSTANDARD LVCMOS33} [get_ports dsp_cb_mssd[2]]
#set_property -dict {PACKAGE_PIN W9   IOSTANDARD LVCMOS33} [get_ports dsp_cb_mssd[3]]
#set_property -dict {PACKAGE_PIN T7 IOSTANDARD LVCMOS33} [get_ports dsp_cb_ms[0]]
#set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS33} [get_ports dsp_cb_ms[1]]
#set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[0]]
#set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[1]]
#set_property -dict {PACKAGE_PIN N9  IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[2]]
#set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[3]]
#set_property -dict {PACKAGE_PIN J3  IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[4]]
#set_property -dict {PACKAGE_PIN R7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[5]]
#set_property -dict {PACKAGE_PIN N7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[6]]
#set_property -dict {PACKAGE_PIN N8  IOSTANDARD LVCMOS33} [get_ports dsp_cb_br[7]]
#set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports dsp_cb_bm[0]]
#set_property -dict {PACKAGE_PIN P9  IOSTANDARD LVCMOS33} [get_ports dsp_cb_bm[1]]
#set_property -dict {PACKAGE_PIN R11 IOSTANDARD LVCMOS33} [get_ports dsp_cb_bm[2]]
#set_property -dict {PACKAGE_PIN L7  IOSTANDARD LVCMOS33} [get_ports dsp_cb_bm[3]]
#set_property -dict {PACKAGE_PIN K6  IOSTANDARD LVCMOS33} [get_ports dsp_cb_bms[0]]
#set_property -dict {PACKAGE_PIN J8  IOSTANDARD LVCMOS33} [get_ports dsp_cb_bms[1]]
#set_property -dict {PACKAGE_PIN J9  IOSTANDARD LVCMOS33} [get_ports dsp_cb_bms[2]]
#set_property -dict {PACKAGE_PIN K10 IOSTANDARD LVCMOS33} [get_ports dsp_cb_bms[3]]
#set_property -dict {PACKAGE_PIN AG1 IOSTANDARD LVCMOS33} [get_ports dsp_cb_ldqm]
#set_property -dict {PACKAGE_PIN M2  IOSTANDARD LVCMOS33} [get_ports dsp_cb_hdqm]
#set_property -dict {PACKAGE_PIN K1  IOSTANDARD LVCMOS33} [get_ports dsp_cb_cas]
#set_property -dict {PACKAGE_PIN AE1 IOSTANDARD LVCMOS33} [get_ports dsp_cb_ras]
#set_property -dict {PACKAGE_PIN AE2 IOSTANDARD LVCMOS33} [get_ports dsp_cb_we]
#set_property -dict {PACKAGE_PIN H7 IOSTANDARD LVCMOS33} [get_ports dsp_cb_clk]
#set_property -dict {PACKAGE_PIN L4 IOSTANDARD LVCMOS33} [get_ports dsp_cb_clke]
#set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports dsp_cb_buslock]
#set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports dsp_cb_brst]
#set_property -dict {PACKAGE_PIN P8 IOSTANDARD LVCMOS33} [get_ports dsp_id2]
#set_property -dict {PACKAGE_PIN M9 IOSTANDARD LVCMOS33} [get_ports dsp_cb_hbr]
#set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVCMOS33} [get_ports dsp_cb_hbg]
#set_property -dict {PACKAGE_PIN M11 IOSTANDARD LVCMOS33} [get_ports dsp_cb_dpa]
#set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS33} [get_ports dsp_cb_cpa]
#set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS33} [get_ports dsp_cb_ack]
#set_property -dict {PACKAGE_PIN N6 IOSTANDARD LVCMOS33} [get_ports dsp_cb_rd]
#set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports dsp_cb_wrl]
#set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports dsp_cb_wrh]
#set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports dsp_cb_boff]
#set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS33} [get_ports dsp_cb_msh]
#set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports dsp_cb_cerom]
#set_property -dict {PACKAGE_PIN L9 IOSTANDARD LVCMOS33} [get_ports dsp_cb_iord]
#set_property -dict {PACKAGE_PIN L8 IOSTANDARD LVCMOS33} [get_ports dsp_cb_iowr]
#set_property -dict {PACKAGE_PIN K8 IOSTANDARD LVCMOS33} [get_ports dsp_cb_ioen]

## DSP Timers
#set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVCMOS33} [get_ports dsp_t0e[0]]
#set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS33} [get_ports dsp_t0e[1]]
#set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS33} [get_ports dsp_t0e[2]]
#set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports dsp_t0e[3]]
