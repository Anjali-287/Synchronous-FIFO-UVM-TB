//dut
module fifo(
  input [7:0]data_in,
  input clk,rst,wr,rd,
  output empty,full,
  output reg [3:0]fifo_cnt,
  output reg [7:0] data_out
);
  
  reg [7:0]mem[0:7];
  reg [2:0]rd_ptr, wr_ptr;
  
  assign empty=(fifo_cnt==0)?1:0;
  assign full=(fifo_cnt==8)?1:0;
  
  //Counter block
  
  always @(posedge clk)
    begin
      if(!rst)
        fifo_cnt<=0;
      else begin
        case({wr,rd})
          2'b00: fifo_cnt <= fifo_cnt;
          2'b01: fifo_cnt <= (fifo_cnt==0)?0:fifo_cnt-1;
          2'b10: fifo_cnt <= (fifo_cnt==8)?8:fifo_cnt+1;
          2'b11: fifo_cnt <= fifo_cnt;
        endcase
      end
    end
  
  //Pointer block
  
  always @(posedge clk)
    begin
      if(!rst) begin
        wr_ptr<=0;
        rd_ptr<=0;
      end
      else begin
        wr_ptr<= (wr && !full)||(wr && rd) ? wr_ptr+1 : wr_ptr;
        rd_ptr<= (rd && !empty)||(wr && rd) ? rd_ptr+1 : rd_ptr;
      end
    end
  
  //Write and read block

  always @(posedge clk)
    if(wr && !full)
      mem[wr_ptr] <= data_in;
    else if(wr && rd)
      mem[wr_ptr] <= data_in;
  
  always @(posedge clk)
    if(rd && !empty)
      data_out<=mem[rd_ptr];
    else if(wr && rd)
      data_out<=mem[rd_ptr];
  
 
  //assertions

  property reset;
    @(posedge clk)
    (rst==0 |=> (wr_ptr==0 && rd_ptr==0 && fifo_cnt==0 && full==0 && empty==1));
  endproperty
  
  property fifo_full;
    @(posedge clk)
    disable iff(!rst)
    (fifo_cnt > 7|-> full==1 );
  endproperty
  
  property fifo_not_full;
    @(posedge clk)
    disable iff(!rst)
    (fifo_cnt < 8|-> !full);
  endproperty
  
  property fifo_should_go_full;
    @(posedge clk)
    disable iff(!rst)
    (fifo_cnt==7 && rd==0 && wr==1|=> full);
  endproperty
  
  property full_write_full;
    @(posedge clk) 
    disable iff (!rst)
    (full && wr && !rd |=> full && $stable(wr_ptr) );
  endproperty
  
  property fifo_empty;
    @(posedge clk)
    disable iff(!rst)
    (fifo_cnt==0 |-> empty );
  endproperty
    
  property empty_read;
    @(posedge clk) 
    disable iff(!rst)
    (empty && rd && !wr |=> empty);
  endproperty
  

  
  assert property(reset)
    begin
      $display($time, ": Assertion Passed: The design passed the reset condition");
      $display("Read pointer, write pointer, fifo count, full flag and empty flag are now reset");
    end
    else
      $display("Assertion Failed: The design failed the reset condition");
      
  assert property(fifo_full)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo full condition.");
      $display("Fifo full flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo full condition.");
   
  assert property(fifo_not_full)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo not full condition.");
      $display("Fifo full flag is not high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo not full condition.");
    
    
  assert property(fifo_should_go_full)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo should go full condition.");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo should go full condition.");
   
    
  assert property(full_write_full)
    begin
      $display($time, ": Assertion Passed: The design passed the write in full fifo condition.");
      $display("You are writing in a full fifo and fifo full flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the write in full fifo condition.");
  
    
  assert property(fifo_empty)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo empty condition.");
      $display("Fifo empty flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo empty condition.");
   
  assert property(empty_read)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo empty read condition.");
      $display("You are trying to read from empty fifo, fifo empty flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo empty read condition.");
   
endmodule
  
  
