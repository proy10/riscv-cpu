module stall(
  
  input wire stall_req_id,
  input wire stall_req_ex,
  input wire stall_req_men,
  output reg if_stall,
  output reg if_id_stall,
  output reg id_ex_stall,
  output reg ex_mem_stall
  
);

  always @ *
  if(stall_req_id  || stall_req_ex || stall_req_men)
      if_stall = 1'b1;
  else
      if_stall = 1'b0;

  always @ *
  if(stall_req_id  || stall_req_ex || stall_req_men)
      if_id_stall = 1'b1;
  else
      if_id_stall = 1'b0;
       
  always @ *
  if(stall_req_ex || stall_req_men) 
      id_ex_stall = 1'b1;
  else
      id_ex_stall = 1'b0;
      
  always @ *
  if(stall_req_men)
      ex_mem_stall = 1'b1;
  else
      ex_mem_stall = 1'b0;
      
endmodule