set_property SRC_FILE_INFO {cfile:{E:/OUSL/5th Year/EEX7436/EEX7436 Design Project/DPP/DPP.srcs/constrs_1/new/FMU.xdc} rfile:../../../DPP.srcs/constrs_1/new/FMU.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { ext_clk }]
set_property src_info {type:XDC file:1 line:9 export:INPUT save:INPUT read:READ} [current_design]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];
set_property src_info {type:XDC file:1 line:15 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { ext_data[0] }]  ; # SW0
set_property src_info {type:XDC file:1 line:16 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { ext_data[1] }]  ; # SW1
set_property src_info {type:XDC file:1 line:17 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { ext_data[2] }]  ; # SW2
set_property src_info {type:XDC file:1 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { ext_data[3] }]  ; # SW3
set_property src_info {type:XDC file:1 line:19 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { ext_data[4] }]  ; # SW4
set_property src_info {type:XDC file:1 line:20 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { ext_data[5] }]  ; # SW5
set_property src_info {type:XDC file:1 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { ext_data[6] }]  ; # SW6
set_property src_info {type:XDC file:1 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { ext_data[7] }]  ; # SW7
set_property src_info {type:XDC file:1 line:23 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS33 } [get_ports { ext_data[8] }]  ; # SW8
set_property src_info {type:XDC file:1 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports { ext_data[9] }]  ; # SW9
set_property src_info {type:XDC file:1 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { ext_data[10] }]; # SW10
set_property src_info {type:XDC file:1 line:26 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { ext_data[11] }]; # SW11
set_property src_info {type:XDC file:1 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { ext_data[12] }]; # SW12
set_property src_info {type:XDC file:1 line:28 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { ext_data[13] }]; # SW13
set_property src_info {type:XDC file:1 line:29 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { ext_data[14] }]; # SW14
set_property src_info {type:XDC file:1 line:30 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { ext_data[15] }]; # SW15
set_property src_info {type:XDC file:1 line:33 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { ext_rst }]; #cpu_resetn
set_property src_info {type:XDC file:1 line:34 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { ext_enb }]; #btnc
set_property src_info {type:XDC file:1 line:35 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { ext_pulse }]; #btnu
set_property src_info {type:XDC file:1 line:36 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { ext_readd }]; #btnl
set_property src_info {type:XDC file:1 line:37 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { ext_savep }]; #btnr
set_property src_info {type:XDC file:1 line:38 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { ext_runp }]; #btnd
set_property src_info {type:XDC file:1 line:41 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { ext_do[0] }]   ; # LED0
set_property src_info {type:XDC file:1 line:42 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { ext_do[1] }]   ; # LED1
set_property src_info {type:XDC file:1 line:43 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { ext_do[2] }]   ; # LED2
set_property src_info {type:XDC file:1 line:44 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { ext_do[3] }]   ; # LED3
set_property src_info {type:XDC file:1 line:45 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { ext_do[4] }]   ; # LED4
set_property src_info {type:XDC file:1 line:46 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { ext_do[5] }]   ; # LED5
set_property src_info {type:XDC file:1 line:47 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { ext_do[6] }]   ; # LED6
set_property src_info {type:XDC file:1 line:48 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { ext_do[7] }]   ; # LED7
set_property src_info {type:XDC file:1 line:51 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { ext_prog_done }]; # LED17_B
set_property src_info {type:XDC file:1 line:52 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { ext_err }]; # LED17_R
set_property src_info {type:XDC file:1 line:53 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { ext_test }]; # LED15
set_property src_info {type:XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { ext_saveprog }]; # LED14
set_property src_info {type:XDC file:1 line:55 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { ext_runprog }]; # LED13
set_property src_info {type:XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { ext_readram }]; # LED12
set_property src_info {type:XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { ext_setled }]; # LED16_B
set_property src_info {type:XDC file:1 line:58 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { ext_setdone }]; # LED17_G
set_property src_info {type:XDC file:1 line:59 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { ext_savedins }]; # LED16_G
