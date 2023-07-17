module mem(
  
  input wire          read_mem,
  input wire          write_mem,
  input wire[31:0]    result,
  output reg          ce,
  output reg          we,
 	output reg[31:0]    data_addr
);
  
  always@ *
  if(read_mem || write_mem)
    ce = 1'b1;
  else
    ce = 1'b0;
  
  always@ *
  if(read_mem)
    we = 1'b0;
  else if(write_mem)
    we = 1'b1;
  else
    we = 1'bz;
    
  always@ *
  if(read_mem || write_mem)
    data_addr = result;
  else
    data_addr = 32'bz;
    
  endmodule