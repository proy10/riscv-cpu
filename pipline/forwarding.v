//For Hazard
module forwarding(
  
 	input wire[4:0]    id_ex_rs1,
	input wire[4:0]    id_ex_rs2,
	input wire         ex_mem_write_reg,
	input wire[4:0]    ex_mem_rd,
	input wire         mem_wb_write_reg,
	input wire[4:0]    mem_wb_rd,
	input wire[31:0]   ex_mem_result,
	input wire[31:0]   write_back_data,
	input wire[31:0]   old_reg_data1,
	input wire[31:0]   old_reg_data2,
	output reg[31:0]   new_reg_data1,
	output reg[31:0]   new_reg_data2
	
);
  
  always @ *
  if(ex_mem_write_reg && ex_mem_rd != 5'b0 &&
    ex_mem_rd == id_ex_rs1)
        new_reg_data1 <= ex_mem_result;
  else if(mem_wb_write_reg && mem_wb_rd != 5'b0 &&
    mem_wb_rd == id_ex_rs1)
        new_reg_data1 <= write_back_data;
  else
        new_reg_data1 <= old_reg_data1;

  always @ *
  if(ex_mem_write_reg && ex_mem_rd != 5'b0 &&
    ex_mem_rd == id_ex_rs2)
        new_reg_data2 <= ex_mem_result;
  else if(mem_wb_write_reg && mem_wb_rd != 5'b0 &&
    mem_wb_rd == id_ex_rs2)
        new_reg_data2 <= write_back_data;
  else
        new_reg_data2 <= old_reg_data2;
  
endmodule

