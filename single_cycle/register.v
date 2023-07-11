module register(
  
  input wire       clk,
  input wire       rst,
  input wire       read_reg1,
  input wire       read_reg2,
  input wire       write_reg,
  input wire       read_mem,
  input wire       write_mem,
  input wire[4:0]  rs1,
  input wire[4:0]  rs2,
  input wire[4:0]  rd,
  input wire[31:0] result,
  input wire[31:0] data_from_mem,
  output reg[31:0] reg_data1,
  output reg[31:0] reg_data2,
  output reg[31:0] data_to_mem

);

  reg[31:0] registers[0:31];
  
  always @ *
  if(read_reg1)
    reg_data1 <= registers[rs1];
  else
    reg_data1 <= 32'bz;
    
  always @ *
  if(read_reg2)
    reg_data2 <= registers[rs2];
  else
    reg_data2 <= 32'bz;
    
  always @ *
  if(write_mem)
    data_to_mem <= registers[rs2];
  else
    data_to_mem <= 32'bz;
    
  always @ (posedge clk or posedge rst)
  if(rst)
    registers[0] <= 32'b0;
  else if(write_reg && rd!=5'b0)
    if(read_mem)
      registers[rd] <= data_from_mem;
    else
      registers[rd] <= result;//data from alu
  else
    begin end  
endmodule