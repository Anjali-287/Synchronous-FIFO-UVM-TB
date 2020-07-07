


//Fifo Sequencer

class fifo_sequencer extends uvm_sequencer#(fifo_seq_item);
  
  `uvm_component_utils(fifo_sequencer)
  
  fifo_seq_item trans;
  bit full;
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
   function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
 
endclass
