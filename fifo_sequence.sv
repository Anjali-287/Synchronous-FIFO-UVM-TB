

//Fifo Sequence

class fifo_write_sequence extends uvm_sequence#(fifo_seq_item);
  `uvm_object_utils(fifo_write_sequence)
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name="fifo_write_sequence");
    super.new(name);
  endfunction
  bit full;
  
  virtual task body();
    fifo_seq_item seq;
    fifo_seq_item rsp;
    //---------------------------------------
    //Write sequence
    //---------------------------------------
    do begin
      seq=new();
      start_item(seq);
      assert(seq.randomize()with{seq.wr==1;});
      finish_item(seq);
      get_response(rsp);
    end while(rsp.full!=1);
    //---------------------------------------
    //Read sequence
    //---------------------------------------
    do begin
      seq=new();
      start_item(seq);
      assert(seq.randomize()with{seq.rd==1;});
      finish_item(seq);
      get_response(rsp);
    end while(rsp.empty!=1);
    
  endtask
  

endclass
