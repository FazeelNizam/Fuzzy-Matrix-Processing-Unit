## Nexys A7-100T Constraint File for FMU Module
##
## This file maps the ports of the 'FMU' entity to the
## physical pins of the XC7A100T-1CSG324C FPGA.

## Clock
# 100MHz System Clock
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { ext_clk }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];

## Switches (ext_data[15:0])
# All switches use LVCMOS33. SW0-7 are pulled up to 3.3V
# SW8-15 are pulled up to 1.8V 
# for the 3.3V FPGA bank (Bank 14)
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { ext_data[0] }]  ; # SW0 
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { ext_data[1] }]  ; # SW1
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { ext_data[2] }]  ; # SW2 
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { ext_data[3] }]  ; # SW3 
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { ext_data[4] }]  ; # SW4 
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { ext_data[5] }]  ; # SW5 
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { ext_data[6] }]  ; # SW6 
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { ext_data[7] }]  ; # SW7 
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS33 } [get_ports { ext_data[8] }]  ; # SW8 
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports { ext_data[9] }]  ; # SW9 
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { ext_data[10] }]; # SW10
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { ext_data[11] }]; # SW11 
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { ext_data[12] }]; # SW12 
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { ext_data[13] }]; # SW13 
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { ext_data[14] }]; # SW14 
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { ext_data[15] }]; # SW15 

## Push-buttons
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { ext_rst }]; #cpu_resetn
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { ext_enb }]; #btnc
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { ext_pulse }]; #btnu
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { ext_readd }]; #btnl
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { ext_savep }]; #btnr
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { ext_runp }]; #btnd

## LEDs (ext_do[7:0])
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { ext_do[0] }]   ; # LED0 
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { ext_do[1] }]   ; # LED1 
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { ext_do[2] }]   ; # LED2 
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { ext_do[3] }]   ; # LED3 
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { ext_do[4] }]   ; # LED4 
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { ext_do[5] }]   ; # LED5 
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { ext_do[6] }]   ; # LED6 
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { ext_do[7] }]   ; # LED7 

## Status LEDs
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { ext_prog_done }]; # LED17_B 
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { ext_err }]; # LED17_R
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { ext_test }]; # LED15
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { ext_saveprog }]; # LED14
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { ext_runprog }]; # LED13
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { ext_readram }]; # LED12
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { ext_setled }]; # LED16_B
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { ext_setdone }]; # LED17_G
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { ext_savedins }]; # LED16_G