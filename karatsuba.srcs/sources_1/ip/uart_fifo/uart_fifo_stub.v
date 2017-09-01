// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
// Date        : Wed Aug 23 11:08:31 2017
// Host        : vivado running 64-bit Debian GNU/Linux 9.1 (stretch)
// Command     : write_verilog -force -mode synth_stub -rename_top uart_fifo -prefix
//               uart_fifo_ uart_fifo_stub.v
// Design      : uart_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_4,Vivado 2017.2" *)
module uart_fifo(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[17:0],wr_en,rd_en,dout[17:0],full,empty" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [17:0]din;
  input wr_en;
  input rd_en;
  output [17:0]dout;
  output full;
  output empty;
endmodule
