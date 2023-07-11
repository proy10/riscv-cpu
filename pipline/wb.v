module wb(
  
  input wire        read_mem,
  input wire[31:0]  result,
  input wire[31:0]  data_from_mem,
  output reg[31:0]  write_back_data
  
  );
  
  always @ *
  if(read_mem)
    write_back_data <= data_from_mem;
  else
    write_back_data <= result;
   
endmodule