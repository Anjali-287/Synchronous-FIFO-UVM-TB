 import uvm_pkg::*;
`include "sequence_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "interface.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"
module tbench_top;
  
  bit clk;
  bit reset;
  
  initial begin
    clk=0;
  end
  
  always begin
    #5 clk <= ~clk;
  end
  
  initial begin
    reset = 0;
    #10 reset =1;
  end
  
  fifo_interface in(clk,reset);
  
  fifo dut(in.data_in,in.clk,in.rst,in.wr,in.rd,in.empty,in.full,in.fifo_cnt,in.data_out);
  
   initial begin 
     uvm_config_db#(virtual fifo_interface)::set(uvm_root::get(),"*","vif",in);
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  //---------------------------------------
  //Calling test
  //--------------------------------------
  initial begin 
    run_test("fifo_test");
  end
  
endmodule
