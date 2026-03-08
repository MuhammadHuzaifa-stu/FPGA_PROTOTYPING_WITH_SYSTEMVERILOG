//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
//Date        : Sun Mar  8 11:15:53 2026
//Host        : DESKTOP-QOVO705 running 64-bit major release  (build 9200)
//Command     : generate_target uBlaze_MCS.bd
//Design      : uBlaze_MCS
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "uBlaze_MCS,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=uBlaze_MCS,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_board_cnt=2,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "uBlaze_MCS.hwdef" *) 
module uBlaze_MCS
   (IO_0_addr_strobe,
    IO_0_address,
    IO_0_byte_enable,
    IO_0_read_data,
    IO_0_read_strobe,
    IO_0_ready,
    IO_0_write_data,
    IO_0_write_strobe,
    clk_in1_0,
    reset_rtl_0);
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 ADDR_STROBE" *) output IO_0_addr_strobe;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 ADDRESS" *) output [31:0]IO_0_address;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 BYTE_ENABLE" *) output [3:0]IO_0_byte_enable;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 READ_DATA" *) input [31:0]IO_0_read_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 READ_STROBE" *) output IO_0_read_strobe;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 READY" *) input IO_0_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 WRITE_DATA" *) output [31:0]IO_0_write_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mcsio_bus:1.0 IO_0 WRITE_STROBE" *) output IO_0_write_strobe;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_0, CLK_DOMAIN uBlaze_MCS_clk_in1_0, FREQ_HZ 100000000, PHASE 0.000" *) input clk_in1_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL_0, POLARITY ACTIVE_LOW" *) input reset_rtl_0;

  wire clk_in1_0_1;
  wire clk_wiz_clk_out1;
  wire [31:0]microblaze_mcs_0_IO_ADDRESS;
  wire microblaze_mcs_0_IO_ADDR_STROBE;
  wire [3:0]microblaze_mcs_0_IO_BYTE_ENABLE;
  wire microblaze_mcs_0_IO_READY;
  wire [31:0]microblaze_mcs_0_IO_READ_DATA;
  wire microblaze_mcs_0_IO_READ_STROBE;
  wire [31:0]microblaze_mcs_0_IO_WRITE_DATA;
  wire microblaze_mcs_0_IO_WRITE_STROBE;
  wire reset_rtl_0_1;

  assign IO_0_addr_strobe = microblaze_mcs_0_IO_ADDR_STROBE;
  assign IO_0_address[31:0] = microblaze_mcs_0_IO_ADDRESS;
  assign IO_0_byte_enable[3:0] = microblaze_mcs_0_IO_BYTE_ENABLE;
  assign IO_0_read_strobe = microblaze_mcs_0_IO_READ_STROBE;
  assign IO_0_write_data[31:0] = microblaze_mcs_0_IO_WRITE_DATA;
  assign IO_0_write_strobe = microblaze_mcs_0_IO_WRITE_STROBE;
  assign clk_in1_0_1 = clk_in1_0;
  assign microblaze_mcs_0_IO_READY = IO_0_ready;
  assign microblaze_mcs_0_IO_READ_DATA = IO_0_read_data[31:0];
  assign reset_rtl_0_1 = reset_rtl_0;
  uBlaze_MCS_clk_wiz_0 clk_wiz
       (.clk_in1(clk_in1_0_1),
        .clk_out1(clk_wiz_clk_out1),
        .resetn(reset_rtl_0_1));
  uBlaze_MCS_microblaze_mcs_0_0 microblaze_mcs_0
       (.Clk(clk_wiz_clk_out1),
        .IO_addr_strobe(microblaze_mcs_0_IO_ADDR_STROBE),
        .IO_address(microblaze_mcs_0_IO_ADDRESS),
        .IO_byte_enable(microblaze_mcs_0_IO_BYTE_ENABLE),
        .IO_read_data(microblaze_mcs_0_IO_READ_DATA),
        .IO_read_strobe(microblaze_mcs_0_IO_READ_STROBE),
        .IO_ready(microblaze_mcs_0_IO_READY),
        .IO_write_data(microblaze_mcs_0_IO_WRITE_DATA),
        .IO_write_strobe(microblaze_mcs_0_IO_WRITE_STROBE),
        .Reset(reset_rtl_0_1));
endmodule
