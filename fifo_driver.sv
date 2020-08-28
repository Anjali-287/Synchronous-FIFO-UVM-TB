`define DRIV_IF vif.DRIVER.driver_cb


class fifo_driver extends uvm_driver#(fifo_seq_item);
  
  `uvm_component_utils(fifo_driver)
  
  virtual fifo_interface vif;
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //---------------------------------------
  //Build Phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) 
      begin
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
      end
  endfunction
  
  //---------------------------------------
  //Run Phase
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    forever begin
      fifo_seq_item trans;
      seq_item_port.get_next_item(trans);
      uvm_report_info("FIFO_DRIVER ", $psprintf("Got Transaction %s",trans.convert2string()));
      
      @(`DRIV_IF);
      //---------------------------------------
      //Driver's writing logic
      //---------------------------------------
      if(trans.wr) begin
        `DRIV_IF.wr<=trans.wr;
        `DRIV_IF.rd<=trans.rd;
        `DRIV_IF.data_in<=trans.data_in;
        @(`DRIV_IF);begin
        `DRIV_IF.wr<=0;
        trans.full=`DRIV_IF.full;
        end
      end
      //---------------------------------------
      //Driver's reading logic
      //---------------------------------------
      if(trans.rd) begin
        `DRIV_IF.wr<=trans.wr;
        `DRIV_IF.rd<=trans.rd;
        @(`DRIV_IF);
        `DRIV_IF.rd<=0;
        @(`DRIV_IF); 
        begin
          trans.data_out=`DRIV_IF.data_out;
          trans.empty=`DRIV_IF.empty;
        end
      end
     
        uvm_report_info("FIFO_DRIVER ", $psprintf("Got Response %s",trans.convert2string()));
      //Putting back response
      seq_item_port.put(trans);
      seq_item_port.item_done();
    end
  endtask
  
endclass
