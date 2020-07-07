




class fifo_seq_item extends uvm_sequence_item;
  
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit [7:0]data_in;
  rand bit rd;
  rand bit wr;
  bit full;
  bit empty;
  bit [7:0]data_out;
  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(fifo_seq_item)
  `uvm_field_int(data_in, UVM_ALL_ON)
  `uvm_field_int(rd, UVM_ALL_ON)
  `uvm_field_int(wr, UVM_ALL_ON)
  `uvm_field_int(full, UVM_ALL_ON)
  `uvm_field_int(empty, UVM_ALL_ON)
  `uvm_field_int(data_out, UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constraint
  //---------------------------------------
  constraint c1{rd!=wr;};
  
  //---------------------------------------
  //Pre randomize function
  //---------------------------------------
  function void pre_randomize();
    if(rd)
      data_in.rand_mode(0);
  endfunction
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name="fifo_seq_item");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $psprintf("data_in=%0h,data_out=%0h,wr=%0d,rd=%0d,full=%od,empty=%0d",data_in,data_out,wr,rd,full,empty);
  endfunction
  
endclass
