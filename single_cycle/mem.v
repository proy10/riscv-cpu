module mem(
  
  input wire  read_mem,
  input wire  write_mem,
  output reg  ce,
  output reg  we

);
  
  always@ *
  if(read_mem || write_mem)
    ce <= 1'b1;
  else
    ce <= 1'b0;
  
  always@ *
  if(read_mem)
    we <= 1'b0;
  else if(write_mem)
    we <= 1'b1;
  else
    we <= 1'bz;
endmodule