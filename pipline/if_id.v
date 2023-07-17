module if_id(
  
  input wire        clk,
  input wire        rst_n,
  input wire        jmp,
  input wire        jmp_from_ex,
  input wire        flush,
  input wire        we_from_ex,
  input wire        if_id_stall,
  input wire[31:0]  inst_addr_from_if,
  input wire[31:0]  inst_from_if,
  output reg[31:0]  inst_addr_to_id,
  output reg[31:0]  inst_to_id,
  output reg        we_to_id,
  output reg        jmp_to_id
);
 
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    inst_addr_to_id <= 32'bz;
  else if(if_id_stall)
    inst_addr_to_id <= inst_addr_to_id;
  else if(jmp)
    inst_addr_to_id <= 32'bz;
  else if(flush)
    inst_addr_to_id <= 32'b0;
  else
    inst_addr_to_id <= inst_addr_from_if;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    inst_to_id <= 32'bz;
  else if(if_id_stall)
    inst_to_id <= inst_to_id;
  else if(jmp)
    inst_to_id <= 32'bz;
  else if(flush)
    inst_to_id <= 32'b0;
  else
    inst_to_id <= inst_from_if;

  always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
      we_to_id <= 1'b0;
    else
      we_to_id <= we_from_ex;
  end

  always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
      jmp_to_id <= 1'b0;
    else
      jmp_to_id <= jmp_from_ex;
  end

endmodule