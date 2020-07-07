//Fifo Agent

class fifo_agent extends uvm_agent;
  
  fifo_sequencer seq;
  fifo_driver driv;
  fifo_monitor mon;
  
  virtual fifo_interface vif;
  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_component_utils_begin(fifo_agent)
  `uvm_field_object(seq, UVM_ALL_ON)
  `uvm_field_object(driv, UVM_ALL_ON)
  `uvm_field_object(mon, UVM_ALL_ON)
  `uvm_component_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //---------------------------------------
  //Build phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    seq=fifo_sequencer::type_id::create("seq",this);
    driv=fifo_driver::type_id::create("driv",this);
    mon=fifo_monitor::type_id::create("mon",this);
    uvm_config_db#(virtual fifo_interface)::set(this, "seq", "vif", vif);
    uvm_config_db#(virtual fifo_interface)::set(this, "driv", "vif", vif);
    uvm_config_db#(virtual fifo_interface)::set(this, "mon", "vif", vif);
    
    if(!uvm_config_db#(virtual fifo_interface)::get(this,"","vif",vif))
      begin
        `uvm_error("build_phase","agent virtual interface failed");
      end
    
  endfunction
  
  //---------------------------------------
  //Connect phase
  //---------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driv.seq_item_port.connect(seq.seq_item_export);
    uvm_report_info("FIFO_AGENT", "connect_phase, Connected driver to sequencer");
  endfunction
  
endclass
