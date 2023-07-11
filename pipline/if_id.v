module if_id(
  
  input wire        clk,
  input wire        rst,
  input wire        jmp,
  input wire        if_id_stall,
  input wire[31:0]  inst_addr_from_if,
  input wire[31:0]  inst_from_if,
  output reg[31:0]  inst_addr_to_id,
  output reg[31:0]  inst_to_id
  
);
 
  always @ (posedge clk or posedge rst)
  if(rst)
    inst_addr_to_id <= 32'bz;
  else if(if_id_stall)
    inst_addr_to_id <= inst_addr_to_id;
  else if(jmp)
    inst_addr_to_id <= 32'bz;
  else
    inst_addr_to_id <= inst_addr_from_if;
    
  always @ (posedge clk or posedge rst)
  if(rst)
    inst_to_id <= 32'bz;
  else if(if_id_stall)
    inst_to_id <= inst_to_id;
  else if(jmp)
    inst_to_id <= 32'bz;
  else
    inst_to_id <= inst_from_if;

endmodule