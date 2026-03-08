//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
//Date        : Sun Mar  8 17:13:17 2026
//Host        : DESKTOP-QOVO705 running 64-bit major release  (build 9200)
//Command     : generate_target uBlaze_MCS_wrapper.bd
//Design      : uBlaze_MCS_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module uBlaze_MCS_wrapper
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
  output IO_0_addr_strobe;
  output [31:0]IO_0_address;
  output [3:0]IO_0_byte_enable;
  input [31:0]IO_0_read_data;
  output IO_0_read_strobe;
  input IO_0_ready;
  output [31:0]IO_0_write_data;
  output IO_0_write_strobe;
  input clk_in1_0;
  input reset_rtl_0;

  wire IO_0_addr_strobe;
  wire [31:0]IO_0_address;
  wire [3:0]IO_0_byte_enable;
  wire [31:0]IO_0_read_data;
  wire IO_0_read_strobe;
  wire IO_0_ready;
  wire [31:0]IO_0_write_data;
  wire IO_0_write_strobe;
  wire clk_in1_0;
  wire reset_rtl_0;

  uBlaze_MCS uBlaze_MCS_i
       (.IO_0_addr_strobe(IO_0_addr_strobe),
        .IO_0_address(IO_0_address),
        .IO_0_byte_enable(IO_0_byte_enable),
        .IO_0_read_data(IO_0_read_data),
        .IO_0_read_strobe(IO_0_read_strobe),
        .IO_0_ready(IO_0_ready),
        .IO_0_write_data(IO_0_write_data),
        .IO_0_write_strobe(IO_0_write_strobe),
        .clk_in1_0(clk_in1_0),
        .reset_rtl_0(reset_rtl_0));
endmodule
