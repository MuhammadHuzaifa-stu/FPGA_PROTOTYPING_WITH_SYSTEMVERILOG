set_property CFGBVS VCCO [current_design] 
set_property CONFIG_VOLTAGE 3.3 [current_design] 
set_property BITSTREAM.GENERAL.COMPRESS true [current_design] 
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design] 

set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_n] 

set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports sys_rstn] 

set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {seg_sel[0]}] 
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports {seg_sel[1]}] 
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {seg_sel[2]}] 
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports {seg_sel[3]}] 

set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {seg_led[0]}] 
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {seg_led[1]}] 
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {seg_led[2]}] 
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {seg_led[3]}] 
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {seg_led[4]}] 
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports {seg_led[5]}] 
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {seg_led[6]}] 
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS33} [get_ports {seg_led[7]}]

set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports {button[1]}] 
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports {button[0]}] 