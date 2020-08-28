`define MON_IF vif.MONITOR.monitor_cb

class fifo_monitor extends uvm_monitor;
  
  virtual fifo_interface vif;
  //---------------------------------------
  //Analysis port declaration
  //---------------------------------------
  uvm_analysis_port#(fifo_seq_item)ap;
  
  `uvm_component_utils(fifo_monitor)
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap=new("ap", this);
  endfunction
  
  //---------------------------------------
  //Build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) begin
       `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
       end
   endfunction
  
  
  //---------------------------------------
  //Run phase
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
     fifo_seq_item trans;
      trans=new();
      @(`MON_IF);
      wait(`MON_IF.wr==1 || `MON_IF.rd==1);
      begin
        if(`MON_IF.wr==1) begin
          trans.wr=`MON_IF.wr;
          trans.data_in=`MON_IF.data_in;
          trans.full=`MON_IF.full;
          @(`MON_IF);
        end
        if(`MON_IF.rd==1) begin
          trans.rd=`MON_IF.rd;
          @(`MON_IF);
          @(`MON_IF);
          trans.data_out=`MON_IF.data_out;
          trans.empty=`MON_IF.empty;
        end
        ap.write(trans);
      end
    end
  endtask
endclass
    
    
    

  
  
